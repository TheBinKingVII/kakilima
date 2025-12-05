import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

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

