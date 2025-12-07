import 'package:get/get.dart';
import 'package:kakilima/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kakilima/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kakilima/features/auth/domain/repositories/auth_repository.dart';
import 'package:kakilima/features/auth/domain/usecases/auth_usecase.dart';
import 'package:kakilima/features/auth/presentation/controllers/auth_controllers.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDatasource>(() => AuthRemoteDatasource());
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    Get.lazyPut<AuthUsecase>(() => AuthUsecase(Get.find()));
    Get.lazyPut<AuthControllers>(() => AuthControllers(Get.find()));
  }
}

