import 'package:get/get.dart';
import 'package:kakilima/features/auth/domain/entities/auth_user_entity.dart';
import 'package:kakilima/features/auth/domain/usecases/auth_usecase.dart';
import 'package:kakilima/core/user_role.dart';
import 'package:kakilima/core/location/vendor_location_service.dart';
import 'package:kakilima/core/storage/location_sharing_storage.dart';

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
    // Load the persisted location sharing status
    final savedStatus = await LocationSharingStorage.getStatus();
    isLocationSharingActive.value = savedStatus;
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
      await LocationSharingStorage.setStatus(false);
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
      await LocationSharingStorage.setStatus(false);
    } else {
      await VendorLocationService.start();
      isLocationSharingActive.value = true;
      await LocationSharingStorage.setStatus(true);
    }
  }
}
