import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:kakilima/features/home/presentation/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Notify controller that map widget is being built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isMapReady.value) {
        controller.onMapReady();
      }
    });

    return Obx(() {
      if (controller.isLoadingLocation.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final mapCenter = controller.mapCenter;
      final isVendor = controller.isVendor.value;
      final position = controller.currentPosition.value;

      return Stack(
        children: [
          FlutterMap(
            mapController: controller.mapController,
            options: MapOptions(
              initialCenter: mapCenter,
              initialZoom: isVendor ? 15.0 : 12.0,
              minZoom: 3.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.kakilima',
              ),
              // Only show location marker for vendors
              if (isVendor && position != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(position.latitude, position.longitude),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          // Map controls
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                // Compass button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.explore),
                    onPressed: () {
                      // Compass functionality can be added later
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Recenter button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.my_location,
                      color: isVendor ? Colors.red : Colors.grey,
                    ),
                    onPressed: controller.recenterToUserLocation,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
