import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kakilima/features/auth/domain/usecases/auth_usecase.dart';
import 'package:kakilima/features/stall/domain/usecases/stall_usecase.dart';
import 'package:kakilima/core/user_role.dart';

class StallController extends GetxController {
  final StallUsecase _stallUsecase;
  final AuthUsecase _authUsecase;

  final RxBool isLoading = false.obs;
  final RxBool isGettingLocation = false.obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxString errorMessage = ''.obs;

  StallController(this._stallUsecase, this._authUsecase);

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> refreshLocation() async {
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    isGettingLocation.value = true;
    try {
      // Check permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        errorMessage.value = 'Layanan lokasi tidak aktif. Silakan aktifkan di pengaturan.';
        isGettingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          errorMessage.value = 'Izin lokasi ditolak.';
          isGettingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        errorMessage.value = 'Izin lokasi ditolak secara permanen. Silakan aktifkan di pengaturan.';
        isGettingLocation.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = position;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Gagal mendapatkan lokasi: $e';
    } finally {
      isGettingLocation.value = false;
    }
  }

  Future<void> createStall() async {
    if (nameController.text.trim().isEmpty) {
      errorMessage.value = 'Nama warung tidak boleh kosong';
      return;
    }

    if (currentPosition.value == null) {
      errorMessage.value = 'Lokasi belum didapatkan. Silakan coba lagi.';
      await _getCurrentLocation();
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Get current user
      final userResult = await _authUsecase.getCurrentUser();
      await userResult.fold(
        (failure) async {
          errorMessage.value = 'Gagal mendapatkan informasi pengguna';
          isLoading.value = false;
        },
        (user) async {
          if (user == null || user.role != UserRole.vendor) {
            errorMessage.value = 'Hanya pedagang yang dapat membuat warung';
            isLoading.value = false;
            return;
          }

          final result = await _stallUsecase.createStall(
            vendorId: user.id,
            name: nameController.text.trim(),
            description: descriptionController.text.trim().isEmpty
                ? null
                : descriptionController.text.trim(),
            longitude: currentPosition.value!.longitude,
            latitude: currentPosition.value!.latitude,
          );

          result.fold(
            (failure) {
              errorMessage.value = failure.message;
              isLoading.value = false;
            },
            (stall) {
              // Success - redirect to main screen
              isLoading.value = false;
              Get.offAllNamed('/main');
            },
          );
        },
      );
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      isLoading.value = false;
    }
  }
}

