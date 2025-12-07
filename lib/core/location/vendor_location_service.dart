import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

const String taskId = "kakilima-live-location";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != taskId) return false;

    try {
      // Check location permissions
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return false;
      }

      // Get current position with high accuracy
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      // Check if user is authenticated
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return false;

      // Update current_location using PostGIS POINT format
      // The trigger will automatically log to vendor_location_history if moved >10 meters
      final response = await Supabase.instance.client
          .from('stalls')
          .update({
            'current_location': 'POINT(${pos.longitude} ${pos.latitude})',
            'last_seen_at': DateTime.now().toIso8601String(),
            'is_active': true,
          })
          .eq('vendor_id', userId)
          .select()
          .maybeSingle();

      // Check if vendor has a stall (response will be null if no stall exists)
      if (response == null) {
        // Vendor doesn't have a stall yet, silently fail
        return false;
      }

      final historyResponse = await Supabase.instance.client
          .from('vendor_location_history')
          .insert({
            'stall_id': response['id'],
            'location': 'POINT(${pos.longitude} ${pos.latitude})',
          });
      if (historyResponse.error != null) {
        return false;
      }

      return true;
    } catch (e) {
      // Handle network errors and other exceptions
      // Return false to indicate task failure (Workmanager will retry)
      return false;
    }
  });
}

class VendorLocationService {
  static Future<void> start() async {
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      taskId,
      taskId,
      frequency: const Duration(minutes: 3),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  static Future<void> stop() => Workmanager().cancelAll();
}

