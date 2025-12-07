import 'package:get/get.dart';
import 'package:kakilima/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kakilima/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kakilima/features/auth/domain/repositories/auth_repository.dart';
import 'package:kakilima/features/auth/domain/usecases/auth_usecase.dart';
import 'package:kakilima/features/auth/presentation/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthUsecase is registered (reuse if exists, otherwise create)
    if (!Get.isRegistered<AuthUsecase>()) {
      Get.lazyPut<AuthRemoteDatasource>(() => AuthRemoteDatasource());
      Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
      Get.lazyPut<AuthUsecase>(() => AuthUsecase(Get.find()));
    }
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find<AuthUsecase>()));
  }
}

