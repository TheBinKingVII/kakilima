import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:kakilima/features/auth/domain/usecases/auth_usecase.dart';
import 'package:kakilima/core/user_role.dart';

class HomeController extends GetxController {
  final AuthUsecase _authUsecase;
  final MapController mapController = MapController();
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxBool isLoadingLocation = true.obs;
  final RxBool isVendor = false.obs;
  final RxBool isMapReady = false.obs;
  
  // Default location for customers (Jakarta center)
  static const LatLng defaultCustomerLocation = LatLng(-6.2088, 106.8456);

  HomeController(this._authUsecase);

  @override
  void onInit() {
    super.onInit();
    _initializeMap();
  }

  @override
  void onReady() {
    super.onReady();
    // Check user role again when page becomes ready (e.g., after login)
    _checkAndUpdateUserRole();
  }

  void onMapReady() {
    isMapReady.value = true;
    // Move map if we have a location ready
    if (isVendor.value && currentPosition.value != null) {
      _moveToLocation(
        LatLng(
          currentPosition.value!.latitude,
          currentPosition.value!.longitude,
        ),
        15.0,
      );
    }
  }

  /// Check user role and update map accordingly
  /// This is called after login to detect role changes
  Future<void> _checkAndUpdateUserRole() async {
    try {
      final result = await _authUsecase.getCurrentUser();
      result.fold(
        (failure) {
          // If no user, treat as customer
          if (isVendor.value) {
            // User was vendor but now logged out or error
            isVendor.value = false;
            _setDefaultCustomerLocation();
          }
        },
        (user) {
          if (user != null && user.role == UserRole.vendor) {
            // User is vendor
            if (!isVendor.value) {
              // Was customer, now vendor - request location
              isVendor.value = true;
              _getCurrentLocation();
            } else if (currentPosition.value == null) {
              // Already vendor but no location - get it
              _getCurrentLocation();
            }
          } else {
            // User is customer or no user
            if (isVendor.value) {
              // Was vendor, now customer
              isVendor.value = false;
              _setDefaultCustomerLocation();
            }
          }
        },
      );
    } catch (e) {
      // On error, keep current state
    }
  }

  void _moveToLocation(LatLng location, double zoom) {
    // Use post-frame callback to ensure map is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _safeMoveToLocation(location, zoom);
    });
  }

  void _safeMoveToLocation(LatLng location, double zoom) {
    try {
      if (isMapReady.value) {
        mapController.move(location, zoom);
      } else {
        // If map not ready yet, wait a bit and try again
        Future.delayed(const Duration(milliseconds: 500), () {
          try {
            if (isMapReady.value) {
              mapController.move(location, zoom);
            } else {
              // If still not ready, try one more time after a longer delay
              Future.delayed(const Duration(milliseconds: 1000), () {
                try {
                  if (isMapReady.value) {
                    mapController.move(location, zoom);
                  }
                } catch (e) {
                  // Silently fail if map still not ready
                  print('Map not ready for move: $e');
                }
              });
            }
          } catch (e) {
            // Silently fail if map not ready
            print('Map not ready for move: $e');
          }
        });
      }
    } catch (e) {
      // Silently fail if map controller is not ready
      print('Error moving map: $e');
    }
  }

  Future<void> _initializeMap() async {
    isLoadingLocation.value = true;
    
    try {
      // Get current user to check role
      final result = await _authUsecase.getCurrentUser();
      result.fold(
        (failure) {
          // If no user or error, treat as customer
          _setDefaultCustomerLocation();
        },
        (user) {
          if (user != null && user.role == UserRole.vendor) {
            isVendor.value = true;
            _getCurrentLocation();
          } else {
            // Customer or no user
            isVendor.value = false;
            _setDefaultCustomerLocation();
          }
        },
      );
    } catch (e) {
      // On error, default to customer view
      _setDefaultCustomerLocation();
    }
  }

  void _setDefaultCustomerLocation() {
    // Set default location for customers (no actual GPS position)
    currentPosition.value = null;
    // Don't move map here - let initialCenter handle it
    isLoadingLocation.value = false;
  }

  Future<void> _getCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Error', 'Location services are disabled');
        _setDefaultCustomerLocation();
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permissions are denied');
          _setDefaultCustomerLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permissions are permanently denied. Please enable in settings.');
        _setDefaultCustomerLocation();
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition.value = position;
      
      // Move camera to current location (will wait for map to be ready)
      _moveToLocation(
        LatLng(position.latitude, position.longitude),
        15.0,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
      _setDefaultCustomerLocation();
    } finally {
      isLoadingLocation.value = false;
    }
  }

  Future<void> recenterToUserLocation() async {
    if (isVendor.value) {
      // For vendors, recenter to actual location
      if (currentPosition.value != null) {
        _moveToLocation(
          LatLng(
            currentPosition.value!.latitude,
            currentPosition.value!.longitude,
          ),
          15.0,
        );
      } else {
        await _getCurrentLocation();
      }
    } else {
      // For customers, recenter to default location
      _moveToLocation(defaultCustomerLocation, 12.0);
    }
  }

  LatLng get mapCenter {
    if (isVendor.value && currentPosition.value != null) {
      return LatLng(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
      );
    }
    return defaultCustomerLocation;
  }

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }
}

