-- ============================================
-- Kakilima Supabase Database Initialization
-- MVP Schema - Launch Only
-- ============================================

-- Enable PostGIS extension for geographic queries
CREATE EXTENSION IF NOT EXISTS postgis;

-- ============================================
-- 1. PROFILES TABLE
-- Auto-created by trigger on auth.users
-- ============================================

CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'customer' CHECK (role IN ('customer', 'vendor')),
    full_name TEXT,
    phone TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for role-based queries
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);

-- ============================================
-- 2. STALLS TABLE
-- One stall per vendor (enforced by unique constraint)
-- ============================================

CREATE TABLE IF NOT EXISTS stalls (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vendor_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    name_enhanced TEXT, -- AI-filled on create
    description TEXT,
    photo_url TEXT,
    location GEOGRAPHY(POINT, 4326), -- Base/registered location
    current_location GEOGRAPHY(POINT, 4326), -- Real-time tracking location (updated every 5 min)
    is_active BOOLEAN NOT NULL DEFAULT true,
    last_seen_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    -- Enforce only one stall per vendor (Rule 9)
    CONSTRAINT unique_vendor_stall UNIQUE (vendor_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_stalls_vendor_id ON stalls(vendor_id);
CREATE INDEX IF NOT EXISTS idx_stalls_is_active ON stalls(is_active);
CREATE INDEX IF NOT EXISTS idx_stalls_location ON stalls USING GIST(location);
CREATE INDEX IF NOT EXISTS idx_stalls_current_location ON stalls USING GIST(current_location);
CREATE INDEX IF NOT EXISTS idx_stalls_last_seen_at ON stalls(last_seen_at);

-- ============================================
-- 3. MENUS TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS menus (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stall_id UUID NOT NULL REFERENCES stalls(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    name_enhanced TEXT, -- AI-enhanced name
    price INTEGER NOT NULL CHECK (price >= 0),
    photo_url TEXT,
    is_available BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_menus_stall_id ON menus(stall_id);
CREATE INDEX IF NOT EXISTS idx_menus_is_available ON menus(is_available);

-- ============================================
-- 4. VENDOR LOCATION HISTORY TABLE
-- Tracks location history for vendors
-- ============================================

CREATE TABLE IF NOT EXISTS vendor_location_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stall_id UUID NOT NULL REFERENCES stalls(id) ON DELETE CASCADE,
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_location_history_stall_id ON vendor_location_history(stall_id);
CREATE INDEX IF NOT EXISTS idx_location_history_recorded_at ON vendor_location_history(recorded_at DESC);
CREATE INDEX IF NOT EXISTS idx_location_history_location ON vendor_location_history USING GIST(location);
-- Composite index for common queries (stall_id + recorded_at)
CREATE INDEX IF NOT EXISTS idx_location_history_stall_recorded ON vendor_location_history(stall_id, recorded_at DESC);

-- ============================================
-- TRIGGERS
-- ============================================

-- Auto-create profile when user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, role, full_name, phone)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'role', 'customer'),
        NEW.raw_user_meta_data->>'full_name',
        NEW.raw_user_meta_data->>'phone'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- Auto-deactivate stale vendors (20 minutes rule)
CREATE OR REPLACE FUNCTION deactivate_stale()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.last_seen_at < NOW() - INTERVAL '20 minutes' THEN
        NEW.is_active := false;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS stall_deactivate ON stalls;
CREATE TRIGGER stall_deactivate
    BEFORE UPDATE ON stalls
    FOR EACH ROW
    EXECUTE FUNCTION deactivate_stale();

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at trigger to stalls
DROP TRIGGER IF EXISTS update_stalls_updated_at ON stalls;
CREATE TRIGGER update_stalls_updated_at
    BEFORE UPDATE ON stalls
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Apply updated_at trigger to menus
DROP TRIGGER IF EXISTS update_menus_updated_at ON menus;
CREATE TRIGGER update_menus_updated_at
    BEFORE UPDATE ON menus
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Log location history when current_location is updated
CREATE OR REPLACE FUNCTION log_location_history()
RETURNS TRIGGER AS $$
DECLARE
    distance_meters NUMERIC;
BEGIN
    -- Only log if current_location actually changed and is not null
    IF NEW.current_location IS NOT NULL THEN
        -- Check if this is the first location or if vendor moved significantly (>10 meters)
        IF OLD.current_location IS NULL THEN
            -- First location update, always log
            INSERT INTO vendor_location_history (stall_id, location, recorded_at)
            VALUES (NEW.id, NEW.current_location, NOW());
        ELSE
            -- Calculate distance between old and new location
            distance_meters := ST_Distance(NEW.current_location::geography, OLD.current_location::geography);
            
            -- Log if moved more than 10 meters (reduces noise from GPS jitter)
            IF distance_meters > 10 THEN
                INSERT INTO vendor_location_history (stall_id, location, recorded_at)
                VALUES (NEW.id, NEW.current_location, NOW());
            END IF;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS log_location_on_update ON stalls;
CREATE TRIGGER log_location_on_update
    AFTER UPDATE OF current_location ON stalls
    FOR EACH ROW
    WHEN (NEW.current_location IS NOT NULL)
    EXECUTE FUNCTION log_location_history();

-- ============================================
-- HELPER FUNCTIONS FOR RLS
-- ============================================

-- Function to check if current user is a vendor
CREATE OR REPLACE FUNCTION is_vendor()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid()
        AND role = 'vendor'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if current user is a customer
CREATE OR REPLACE FUNCTION is_customer()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid()
        AND role = 'customer'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get current user's role
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS TEXT AS $$
DECLARE
    user_role TEXT;
BEGIN
    SELECT role INTO user_role
    FROM profiles
    WHERE id = auth.uid();
    RETURN COALESCE(user_role, 'customer');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE stalls ENABLE ROW LEVEL SECURITY;
ALTER TABLE menus ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendor_location_history ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Profiles are viewable by everyone" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Active stalls are viewable by everyone" ON stalls;
DROP POLICY IF EXISTS "Vendors can view own stall" ON stalls;
DROP POLICY IF EXISTS "Vendors can create own stall" ON stalls;
DROP POLICY IF EXISTS "Vendors can update own stall" ON stalls;
DROP POLICY IF EXISTS "Vendors can delete own stall" ON stalls;
DROP POLICY IF EXISTS "Menus of active stalls are viewable by everyone" ON menus;
DROP POLICY IF EXISTS "Vendors can manage menus of own stall" ON menus;

-- ============================================
-- PROFILES POLICIES (Role-based)
-- ============================================

-- Everyone (authenticated) can read all profiles
CREATE POLICY "Profiles are viewable by authenticated users"
    ON profiles FOR SELECT
    USING (auth.uid() IS NOT NULL);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
    ON profiles FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- Users can insert their own profile (via trigger, but allow direct insert too)
CREATE POLICY "Users can insert own profile"
    ON profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

-- ============================================
-- STALLS POLICIES (Role-based)
-- ============================================

-- Customers and vendors can view active stalls (for discover map)
CREATE POLICY "Customers and vendors can view active stalls"
    ON stalls FOR SELECT
    USING (
        is_active = true
        AND auth.uid() IS NOT NULL
        AND (
            is_customer() OR is_vendor()
        )
    );

-- Vendors can view their own stall (even if inactive)
CREATE POLICY "Vendors can view own stall"
    ON stalls FOR SELECT
    USING (
        auth.uid() = vendor_id
        AND is_vendor()
    );

-- Only vendors can create stalls
CREATE POLICY "Only vendors can create stalls"
    ON stalls FOR INSERT
    WITH CHECK (
        auth.uid() = vendor_id
        AND is_vendor()
    );

-- Vendors can update their own stall
-- This includes updating current_location for background service tracking
CREATE POLICY "Vendors can update own stall"
    ON stalls FOR UPDATE
    USING (
        auth.uid() = vendor_id
        AND is_vendor()
    )
    WITH CHECK (
        auth.uid() = vendor_id
        AND is_vendor()
    );

-- Only vendors can delete their own stall
CREATE POLICY "Only vendors can delete own stall"
    ON stalls FOR DELETE
    USING (
        auth.uid() = vendor_id
        AND is_vendor()
    );

-- ============================================
-- MENUS POLICIES (Role-based)
-- ============================================

-- Customers and vendors can view menus of active stalls
CREATE POLICY "Customers and vendors can view menus of active stalls"
    ON menus FOR SELECT
    USING (
        auth.uid() IS NOT NULL
        AND (
            is_customer() OR is_vendor()
        )
        AND EXISTS (
            SELECT 1 FROM stalls
            WHERE stalls.id = menus.stall_id
            AND stalls.is_active = true
        )
    );

-- Vendors can view menus of their own stall (even if inactive)
CREATE POLICY "Vendors can view menus of own stall"
    ON menus FOR SELECT
    USING (
        is_vendor()
        AND EXISTS (
            SELECT 1 FROM stalls
            WHERE stalls.id = menus.stall_id
            AND stalls.vendor_id = auth.uid()
        )
    );

-- Only vendors can create menus for their own stall
CREATE POLICY "Only vendors can create menus for own stall"
    ON menus FOR INSERT
    WITH CHECK (
        is_vendor()
        AND EXISTS (
            SELECT 1 FROM stalls
            WHERE stalls.id = menus.stall_id
            AND stalls.vendor_id = auth.uid()
        )
    );

-- Only vendors can update menus of their own stall
CREATE POLICY "Only vendors can update menus of own stall"
    ON menus FOR UPDATE
    USING (
        is_vendor()
        AND EXISTS (
            SELECT 1 FROM stalls
            WHERE stalls.id = menus.stall_id
            AND stalls.vendor_id = auth.uid()
        )
    )
    WITH CHECK (
        is_vendor()
        AND EXISTS (
            SELECT 1 FROM stalls
            WHERE stalls.id = menus.stall_id
            AND stalls.vendor_id = auth.uid()
        )
    );

-- Only vendors can delete menus of their own stall
CREATE POLICY "Only vendors can delete menus of own stall"
    ON menus FOR DELETE
    USING (
        is_vendor()
        AND EXISTS (
            SELECT 1 FROM stalls
            WHERE stalls.id = menus.stall_id
            AND stalls.vendor_id = auth.uid()
        )
    );

-- ============================================
-- VENDOR LOCATION HISTORY POLICIES (Role-based)
-- ============================================

-- Only vendors can view their own location history
CREATE POLICY "Vendors can view own location history"
    ON vendor_location_history FOR SELECT
    USING (
        is_vendor()
        AND EXISTS (
            SELECT 1 FROM stalls
            WHERE stalls.id = vendor_location_history.stall_id
            AND stalls.vendor_id = auth.uid()
        )
    );

-- Location history is inserted automatically by trigger, no manual inserts needed
-- But allow vendors to insert if needed (for manual corrections)
CREATE POLICY "Vendors can insert own location history"
    ON vendor_location_history FOR INSERT
    WITH CHECK (
        is_vendor()
        AND EXISTS (
            SELECT 1 FROM stalls
            WHERE stalls.id = vendor_location_history.stall_id
            AND stalls.vendor_id = auth.uid()
        )
    );

-- Vendors can delete their own location history (for privacy/cleanup)
CREATE POLICY "Vendors can delete own location history"
    ON vendor_location_history FOR DELETE
    USING (
        is_vendor()
        AND EXISTS (
            SELECT 1 FROM stalls
            WHERE stalls.id = vendor_location_history.stall_id
            AND stalls.vendor_id = auth.uid()
        )
    );

-- ============================================
-- PROTOTYPING: AUTO-CONFIRM EMAIL FUNCTION
-- This function bypasses email confirmation for prototyping
-- TODO: Remove this before production
-- ============================================

CREATE OR REPLACE FUNCTION auto_confirm_email(user_email TEXT)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE auth.users
    SET email_confirmed_at = NOW(),
        confirmed_at = NOW()
    WHERE email = user_email
    AND email_confirmed_at IS NULL;
END;
$$;

-- Grant execute permission to authenticated users (for prototyping)
GRANT EXECUTE ON FUNCTION auto_confirm_email(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION auto_confirm_email(TEXT) TO anon;

-- ============================================
-- INITIALIZATION COMPLETE
-- ============================================

