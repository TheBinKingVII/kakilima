import 'package:get/get.dart';
import 'package:kakilima/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kakilima/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kakilima/features/auth/domain/repositories/auth_repository.dart';
import 'package:kakilima/features/auth/domain/usecases/auth_usecase.dart';
import 'package:kakilima/features/auth/presentation/controllers/auth_controllers.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure dependencies are registered (reuse if exists, otherwise create)
    if (!Get.isRegistered<AuthRemoteDatasource>()) {
      Get.lazyPut<AuthRemoteDatasource>(() => AuthRemoteDatasource());
    }
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    }
    if (!Get.isRegistered<AuthUsecase>()) {
      Get.lazyPut<AuthUsecase>(() => AuthUsecase(Get.find()));
    }
    // Reuse AuthControllers if it exists and is valid, otherwise create new one
    // Use put with permanent: true to ensure controller persists across auth page navigations
    // We'll manually dispose it when navigating away from auth flow (e.g., to main)
    try {
      // Try to get existing controller
      if (Get.isRegistered<AuthControllers>()) {
        Get.find<AuthControllers>(); // Verify controller is accessible
        // Controller exists and is accessible, no need to create new one
        return;
      }
    } catch (e) {
      // Controller was disposed or not found, will create new one below
    }
    // Create new controller if it doesn't exist or was disposed
    Get.put<AuthControllers>(AuthControllers(Get.find()), permanent: true);
  }
}

