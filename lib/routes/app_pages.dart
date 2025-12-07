import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakilima/features/auth/presentation/bindings/auth_binding.dart';
import 'package:kakilima/features/auth/presentation/pages/login_page.dart';
import 'package:kakilima/features/auth/presentation/pages/register_page.dart';
import 'package:kakilima/screens/main_screen.dart';
import 'package:kakilima/screens/main_screen_binding.dart';
import 'package:kakilima/features/product/presentation/pages/product_page.dart';
import 'package:kakilima/features/product/presentation/pages/rating_detail_page.dart';
import 'package:kakilima/features/stall/presentation/pages/create_stall_page.dart';
import 'package:kakilima/features/stall/presentation/bindings/stall_binding.dart';

class AppPages {
  static const initial = Routes.main;

  static final routes = [
    GetPage(
      name: Routes.main,
      page: () => MainScreen(),
      binding: MainScreenBinding(),
      middlewares: [VendorStallMiddleware()],
    ),
    GetPage(
      name: Routes.authLogin,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.authRegister,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.createStall,
      page: () => const CreateStallPage(),
      binding: StallBinding(),
    ),
    GetPage(
      name: Routes.productPage,
      page: () => ProductPage(),
      // binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.ratingDetailPage,
      page: () => RatingDetailPage(),
      // binding: RatingDetailBinding(),
    ),
  ];
}

class Routes {
  static const main = '/main';
  static const authLogin = '/auth/login';
  static const authRegister = '/auth/register';
  static const createStall = '/stall/create';
  static const productPage = '/products';
  static const ratingDetailPage = '/rating/details';
}

// Middleware to check if vendor has a stall
class VendorStallMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // This will be handled in MainScreenController
    return null;
  }
}
