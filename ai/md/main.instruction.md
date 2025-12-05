# Kakilima – Quick-Shipment Technical Manual  
**Target: MVP Live in 3 Weeks**  
**Focus: Only What’s Absolutely Required for Launch**

### Launch-Scope Features (Non-Negotiable Minimum)

| Feature                | Must Ship With | Notes                                                                 |
|-----------------------|----------------|-----------------------------------------------------------------------|
| auth                  | Yes            | Supabase Auth + role (customer/vendor)                               |
| discover              | Yes            | Real-time map of active vendors within 3 km                           |
| stall                 | Yes            | Vendor can create & edit 1 stall                                      |
| vendor live location  | Yes            | Auto-update every 5 min → Supabase (foreground + background)         |
| search                | Yes            | Simple full-text search (enhanced names)                              |
| stall detail          | Yes            | Menu, photos, distance, “Tap to navigate”                             |
| basic profile         | Yes            | Show role + logout                                                    |

**Everything else is POST-MVP** (reviews, favorites, AI suggestions, photo search, vendor analytics → cut completely for v1).

### Final Slimmed Package List (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Core
  get: ^4.6.6
  supabase_flutter: ^2.8.0
  get_it: ^8.0.0
  dartz: ^0.10.1
  equatable: ^2.0.5

  # Location & Background (Android-first)
  geolocator: ^12.0.0
  workmanager: ^0.6.2
  permission_handler: ^11.3.1

  # Maps
  google_maps_flutter: ^2.9.0

  # UI
  cached_network_image: ^3.3.1

  # Env
  flutter_dotenv: ^5.1.0
```

No Hive, no image_picker, no geocoding, no uuid, no extra fluff.

### Supabase Schema – Launch Only (8 tables max)

```sql
-- 1. profiles (auto-created by trigger on auth.users)
id (uuid) pk
role text ('customer' or 'vendor') DEFAULT 'customer'
full_name text
phone text
created_at

-- 2. stalls
id (uuid) pk
vendor_id (uuid) → profiles.id
name text
name_enhanced text           -- AI-filled on create
description text
photo_url text
location geography(Point,4326)
is_active boolean DEFAULT true
last_seen_at timestamptz
created_at timestamptz

-- 3. menus
id (uuid) pk
stall_id → stalls.id
name text
name_enhanced text
price int
photo_url text
is_available boolean DEFAULT true

-- Enable PostGIS once
CREATE EXTENSION IF NOT EXISTS postgis;
```

### Android Configuration – Copy-Paste Ready

#### android/app/src/main/AndroidManifest.xml (minimal working)

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />
<uses-permission android:android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />

<application
    android:usesCleartextTraffic="true">

  <service
      android:name="com.dexterous.flutterworkmanager.WorkerService"
      android:exported="false"/>
      
  <receiver
      android:name="com.dexterous.flutterworkmanager.BootReceiver"
      android:enabled="true"
      android:exported="true">
    <intent-filter>
      <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
  </receiver>
</application>
```

#### android/app/build.gradle

```gradle
android {
    compileSdk 34
    defaultConfig {
        minSdkVersion 23
        targetSdkVersion 34
    }
}
```

### Mandatory Background Location Service (Only code you need)

```dart
// core/location/vendor_location_service.dart
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';

const String taskId = "kakilima-live-location";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != taskId) return false;

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied || 
        perm == LocationPermission.deniedForever) return false;

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return false;

    await Supabase.instance.client
        .from('stalls')
        .update({
          'location': 'POINT(${pos.longitude} ${pos.latitude})',
          'last_seen_at': DateTime.now().toIso8601String(),
          'is_active': true,
        })
        .eq('vendor_id', userId);

    return true;
  });
}

class VendorLocationService {
  static Future<void> start() async {
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      taskId,
      taskId,
      frequency: const Duration(minutes: 5),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  static Future<void> stop() => Workmanager().cancelAll();
}
```

Call `VendorLocationService.start()` immediately after vendor login.

### Auto-Deactivate Stale Vendors (Supabase Trigger – One-time setup)

```sql
CREATE OR REPLACE FUNCTION deactivate_stale() 
RETURNS trigger AS $$
BEGIN
  IF NEW.last_seen_at < NOW() - INTERVAL '20 minutes' THEN
    NEW.is_active := false;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER stall_deactivate 
  BEFORE UPDATE ON stalls
  FOR EACH ROW
  EXECUTE FUNCTION deactivate_stale();
```

### Discover Query (Real-time 3 km)

```dart
supabase
  .from('stalls')
  .stream(primaryKey: ['id'])
  .eq('is_active', true)
  .filter('location', 'st_dwithin', 
      'ST_PointFromText(\'POINT($lng $lat)\', 4326)::geography, 3000')
  .order('location <-> ST_PointFromText(\'POINT($lng $lat)\', 4326)');
```

### Quick-Shipment Development Rules

| Rule                                    | Reason                          |
|----------------------------------------|---------------------------------|
| No offline support                     | Not needed for MVP              |
| No image upload in v1                  | Use placeholder or external link|
| No reviews, favorites, AI suggestion   | Post-MVP                        |
| Only one stall per vendor              | Simplicity                      |
| Vendor stall auto-created on first login| Faster onboarding             |
| Hard-coded radius 3 km                 | Good enough for launch          |
| No unit tests for first release        | Speed over perfection           |

### Final Folder Structure (What actually gets used)

```
lib/
├── core/
│   ├── di/
│   ├── network/supabase_client.dart
│   └── location/vendor_location_service.dart
├── features/
│   ├── auth/
│   ├── discover/
│   ├── stall/
│   └── search/
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── discover_screen.dart
│   └── stall_detail_screen.dart
├── routes/
└── main.dart
```

That’s it.

Ship in 3 weeks.  
Get vendors on the street.  
Get customers eating.

Everything else comes in v2.