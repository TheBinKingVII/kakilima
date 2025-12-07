import 'package:get/get.dart';
import 'package:kakilima/features/auth/presentation/pages/login_page.dart';
import 'package:kakilima/features/auth/presentation/pages/register_page.dart';
import 'package:kakilima/screens/main_screen.dart';
import 'package:kakilima/features/product/presentation/pages/product_page.dart';
import 'package:kakilima/features/product/presentation/pages/rating_detail_page.dart';

class AppPages {
  static const initial = Routes.main;

  static final routes = [
    GetPage(name: Routes.main, page: () => MainScreen()),
    GetPage(name: Routes.authLogin, page: () => LoginPage()),
    GetPage(name: Routes.authRegister, page: () => RegisterPage()),
  ];
}

class Routes {
  static const main = '/main';
  static const authLogin = '/auth/login';
  static const authRegister = '/auth/register';
}
