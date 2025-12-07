import 'package:get/get.dart';
import 'package:kakilima/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kakilima/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kakilima/features/auth/domain/repositories/auth_repository.dart';
import 'package:kakilima/features/auth/domain/usecases/auth_usecase.dart';
import 'package:kakilima/features/stall/data/datasources/stall_remote_datasource.dart';
import 'package:kakilima/features/stall/data/repositories/stall_repository_impl.dart';
import 'package:kakilima/features/stall/domain/repositories/stall_repository.dart';
import 'package:kakilima/features/stall/domain/usecases/stall_usecase.dart';
import 'package:kakilima/features/stall/presentation/controllers/stall_controller.dart';

class StallBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthUsecase is registered (reuse if exists, otherwise create)
    if (!Get.isRegistered<AuthUsecase>()) {
      Get.lazyPut<AuthRemoteDatasource>(() => AuthRemoteDatasource());
      Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
      Get.lazyPut<AuthUsecase>(() => AuthUsecase(Get.find()));
    }
    
    Get.lazyPut<StallRemoteDatasource>(() => StallRemoteDatasource());
    Get.lazyPut<StallRepository>(() => StallRepositoryImpl(Get.find()));
    Get.lazyPut<StallUsecase>(() => StallUsecase(Get.find()));
    Get.lazyPut<StallController>(() => StallController(Get.find(), Get.find()));
  }
}

