import 'package:get/get.dart';
import 'package:kakilima/features/auth/domain/entities/auth_user_entity.dart';
import 'package:kakilima/features/auth/domain/usecases/auth_usecase.dart';
import 'package:kakilima/core/user_role.dart';
import 'package:kakilima/core/location/vendor_location_service.dart';

class ProfileController extends GetxController {
  final AuthUsecase _authUsecase;
  
  final Rx<AuthUserEntity?> currentUser = Rx<AuthUserEntity?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isLocationSharingActive = false.obs;

  ProfileController(this._authUsecase);

  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
    _checkLocationSharingStatus();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh auth state when page becomes ready (e.g., after returning from login)
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    isLoading.value = true;
    final result = await _authUsecase.getCurrentUser();
    result.fold(
      (failure) {
        currentUser.value = null;
        isLoading.value = false;
      },
      (user) {
        currentUser.value = user;
        isLoading.value = false;
      },
    );
  }

  Future<void> _checkLocationSharingStatus() async {
    // Check if workmanager task is registered
    // Note: Workmanager doesn't have a direct way to check if task is active
    // We'll track it manually or check via a flag
    // For now, we'll assume it's false and update when start/stop is called
    isLocationSharingActive.value = false;
  }

  bool get isLoggedIn => currentUser.value != null;
  bool get isVendor => currentUser.value?.role == UserRole.vendor;

  Future<void> refreshUser() async {
    await _checkAuthState();
  }

  Future<void> signOut() async {
    // Stop location sharing if active
    if (isLocationSharingActive.value) {
      await VendorLocationService.stop();
      isLocationSharingActive.value = false;
    }
    
    final result = await _authUsecase.signOut();
    result.fold(
      (failure) {
        // Handle error if needed
      },
      (_) {
        currentUser.value = null;
      },
    );
  }

  Future<void> toggleLocationSharing() async {
    if (!isVendor) return;

    if (isLocationSharingActive.value) {
      await VendorLocationService.stop();
      isLocationSharingActive.value = false;
    } else {
      await VendorLocationService.start();
      isLocationSharingActive.value = true;
    }
  }
}
