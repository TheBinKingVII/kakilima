import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/share_bottom_sheet.dart';

class ProductController extends GetxController {
  // Dummy data untuk UI
  final merchantName = 'Siomay Hengki'.obs;
  final merchantAddress = 'Jl. Soekarno Hatta 15A'.obs;
  final merchantRating = 4.0.obs;
  final totalReviews = 1034.obs;
  final merchantImage = 'https://via.placeholder.com/150'.obs;
  final bannerImage = 'https://via.placeholder.com/400x200'.obs;

  // Dummy product list
  final products = <Map<String, dynamic>>[
    {
      'name': 'Siomay Ikan Komplit',
      'description':
          'Isi 5 pcs campur (2 Siomay, 1 Tahu, 1 Kentang, 1 Telur) disirami bumbu kaca...',
      'price': 15000,
      'image': 'https://via.placeholder.com/100',
    },
    {
      'name': 'Siomay Ikan Tenggiri (Original)',
      'description':
          'Primadona kami. Terbuat dari 100% ikan tenggiri asli tanpa banyak tepung.',
      'price': 5000,
      'image': 'https://via.placeholder.com/100',
    },
    {
      'name': 'Paket Batagor Kriuk',
      'description':
          'Bakso Tahu Goreng yang digoreng dadakan. Renyah di luar, lembut di dalam. Cocok buat yang suka tekstur garing.',
      'price': 20000,
      'image': 'https://via.placeholder.com/100',
    },
    {
      'name': 'Kol Gulung',
      'description':
          'Lembaran kol manis yang digulung hingga layis, digulung rapi. Teksturnya crunchy tapi lembut.',
      'price': 3000,
      'image': 'https://via.placeholder.com/100',
    },
    {
      'name': 'Siomay Ikan Tenggiri (Original)',
      'description':
          'Primadona kami. Terbuat dari 100% ikan tenggiri asli tanpa banyak tepung.',
      'price': 5000,
      'image': 'https://via.placeholder.com/100',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize data here if needed
  }

  void shareProduct() {
    Get.bottomSheet(
      const ShareBottomSheet(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void editProduct() {
    // Edit functionality will be implemented later
    Get.snackbar('Edit', 'Edit functionality');
  }

  void viewRatingDetails() {
    // Navigate to rating details page
    Get.toNamed('/rating-detail');
  }
}
