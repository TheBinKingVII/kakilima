import 'package:get/get.dart';
import 'package:kakilima/screens/main_screen.dart';
import 'package:kakilima/features/product/presentation/pages/product_page.dart';
import 'package:kakilima/features/product/presentation/pages/rating_detail_page.dart';

class AppPages {
  static const initial = Routes.main;

  static final routes = [
    GetPage(
      name: Routes.main,
      page: () => MainScreen(),
    ),
    GetPage(
      name: Routes.product,
      page: () => const ProductPage(),
    ),
    GetPage(
      name: Routes.ratingDetail,
      page: () => const RatingDetailPage(),
    ),
  ];
}

class Routes {
  static const main = '/main';
  static const product = '/product';
  static const ratingDetail = '/rating-detail';
}

