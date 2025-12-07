import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kakilima/features/stall/data/models/stall_model.dart';

class StallRemoteDatasource {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Search radius in meters (100km for debugging, can be changed later)
  static const double searchRadiusMeters = 100000.0;

  Future<StallModel?> getVendorStall(String vendorId) async {
    try {
      final response = await _supabase
          .from('stalls')
          .select()
          .eq('vendor_id', vendorId)
          .maybeSingle();
      
      if (response == null) {
        return null;
      }
      print("Response: $response");
      
      return StallModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get vendor stall: $e');
    }
  }

  Future<StallModel> createStall({
    required String vendorId,
    required String name,
    String? nameEnhanced,
    String? description,
    String? photoUrl,
    required double longitude,
    required double latitude,
  }) async {
    try {
      // Check if vendor already has a stall
      final existingStall = await getVendorStall(vendorId);
      if (existingStall != null) {
        throw Exception('Vendor already has a stall');
      }

      final response = await _supabase
          .from('stalls')
          .insert({
            'vendor_id': vendorId,
            'name': name,
            'name_enhanced': nameEnhanced,
            'description': description,
            'photo_url': photoUrl,
            'location': 'POINT($longitude $latitude)',
          })
          .select()
          .single();

      return StallModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create stall: $e');
    }
  }

  Future<List<StallModel>> getAllActiveStalls({
    double? latitude,
    double? longitude,
  }) async {
    try {
      // For debugging with 100km radius, fetch all active stalls
      // In production, this would use a database function with PostGIS st_dwithin
      // to filter server-side within the search radius
      final response = await _supabase
          .from('stalls')
          .select()
          .eq('is_active', true);
      
      final allStalls = (response as List)
          .map((json) => StallModel.fromJson(json))
          .toList();
      
      // If location is provided, filter client-side by distance
      // Note: For production, implement a database function using PostGIS st_dwithin
      // for proper server-side filtering
      // if (latitude != null && longitude != null) {
      //   // Filter stalls within search radius (client-side for now)
      //   // This is acceptable for debugging with 100km radius
      //   return allStalls.where((stall) {
      //     if (stall.currentLocation == null) return false;
      //     final stallLatLng = _parsePostGisPoint(stall.currentLocation!);
      //     if (stallLatLng == null) return false;
          
      //     // Calculate distance using Haversine formula (approximate)
      //     final distance = _calculateDistance(
      //       latitude,
      //       longitude,
      //       stallLatLng['latitude']!,
      //       stallLatLng['longitude']!,
      //     );
          
      //     return distance <= searchRadiusMeters;
      //   }).toList();
      // }
      
      return allStalls;
    } catch (e) {
      throw Exception('Failed to get all active stalls: $e');
    }
  }

  // Parse PostGIS POINT format: "POINT(longitude latitude)" or "SRID=4326;POINT(longitude latitude)"
  Map<String, double>? _parsePostGisPoint(String pointString) {
    try {
      // Extract coordinates from POINT format
      final match = RegExp(r'POINT\(([^)]+)\)').firstMatch(pointString);
      if (match != null) {
        final coords = match.group(1)!.trim().split(RegExp(r'\s+'));
        if (coords.length >= 2) {
          return {
            'longitude': double.parse(coords[0]),
            'latitude': double.parse(coords[1]),
          };
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Calculate distance between two points using Haversine formula (in meters)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Earth radius in meters
    
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    
    final c = 2 * math.asin(math.sqrt(a));
    
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * (math.pi / 180.0);
}

