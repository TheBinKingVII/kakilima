import 'package:get/get.dart';
import 'package:kakilima/screens/main_screen.dart';

class AppPages {
  static const initial = Routes.main;

  static final routes = [
    GetPage(
      name: Routes.main,
      page: () => MainScreen(),
    ),
    GetPage(
      name: Routes.authLogin,
      page: () => LoginPage(),
    ),
    GetPage(
      name: Routes.authRegister,
      page: () => RegisterPage(),
    ),
  ];

}

class Routes {
  static const main = '/main';
}
