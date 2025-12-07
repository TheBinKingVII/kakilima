import 'package:get/get.dart';
import 'package:kakilima/features/auth/domain/entities/auth_user_entity.dart';
import 'package:kakilima/features/auth/domain/usecases/auth_usecase.dart';
import 'package:kakilima/features/stall/domain/usecases/stall_usecase.dart';
import 'package:kakilima/core/user_role.dart';
import 'package:kakilima/core/location/vendor_location_service.dart';
import 'package:kakilima/core/storage/location_sharing_storage.dart';
import 'package:kakilima/routes/app_pages.dart';

class MainScreenController extends GetxController {
  final AuthUsecase _authUsecase;
  final StallUsecase _stallUsecase;
  
  final Rx<AuthUserEntity?> currentUser = Rx<AuthUserEntity?>(null);
  final RxBool isLocationSharingActive = false.obs;
  final RxInt selectedIndex = 0.obs;
  final RxBool isCheckingStall = true.obs;

  MainScreenController(this._authUsecase, this._stallUsecase);

  @override
  void onInit() {
    super.onInit();
    _checkAuthStateAndStall();
    _checkLocationSharingStatus();
  }

  Future<void> _checkAuthStateAndStall() async {
    isCheckingStall.value = true;
    final result = await _authUsecase.getCurrentUser();
    await result.fold(
      (failure) async {
        currentUser.value = null;
        isCheckingStall.value = false;
      },
      (user) async {
        currentUser.value = user;
        
        // If user is vendor, check if they have a stall
        if (user != null && user.role == UserRole.vendor) {
          final stallResult = await _stallUsecase.getVendorStall(user.id);
          await stallResult.fold(
            (failure) {
              // Error checking stall, allow access (will show error if needed)
              isCheckingStall.value = false;
            },
            (stall) {
              if (stall == null) {
                // Vendor doesn't have a stall, redirect to create stall
                isCheckingStall.value = false;
                Get.offNamed(Routes.createStall);
              } else {
                // Vendor has a stall, allow access
                isCheckingStall.value = false;
              }
            },
          );
        } else {
          // Not a vendor or no stall usecase, allow access
          isCheckingStall.value = false;
        }
      },
    );
  }

  Future<void> _checkLocationSharingStatus() async {
    // Load the persisted location sharing status
    final savedStatus = await LocationSharingStorage.getStatus();
    isLocationSharingActive.value = savedStatus;
  }

  bool get isVendor => currentUser.value?.role == UserRole.vendor;

  void changeIndex(int index) {
    selectedIndex.value = index;
    // Refresh auth state when navigating to profile page (index 3)
    if (index == 3) {
      _checkAuthStateAndStall();
    }
  }

  Future<void> toggleLocationSharing() async {
    if (!isVendor) return;

    try {
      if (isLocationSharingActive.value) {
        await VendorLocationService.stop();
        isLocationSharingActive.value = false;
        await LocationSharingStorage.setStatus(false);
      } else {
        await VendorLocationService.start();
        isLocationSharingActive.value = true;
        await LocationSharingStorage.setStatus(true);
      }
    } catch (e) {
      // Handle any errors during start/stop
      // Keep the state as it was before the toggle attempt
      // In a production app, you might want to show an error message to the user
      print('Error: $e');
      Get.snackbar('Error', 'Failed to toggle location sharing: $e');
    }
  }

  Future<void> refreshUser() async {
    await _checkAuthStateAndStall();
  }
}

