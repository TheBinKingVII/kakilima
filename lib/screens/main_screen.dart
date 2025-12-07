import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakilima/features/home/presentation/bindings/home_binding.dart';
import 'package:kakilima/features/home/presentation/pages/home_page.dart';
import 'package:kakilima/features/product/presentation/pages/product_page.dart';
import 'package:kakilima/features/search/presentation/pages/seacrh_page.dart';
import 'package:kakilima/features/auth/presentation/pages/profile_page.dart';
import 'package:kakilima/features/auth/presentation/bindings/profile_binding.dart';
import 'package:kakilima/features/auth/presentation/controllers/profile_controller.dart';
import 'package:kakilima/features/home/presentation/controllers/home_controller.dart';
import 'package:kakilima/screens/main_screen_controller.dart';

class MainScreen extends GetView<MainScreenController> {
  MainScreen({super.key});

  List<Widget> get _optionWidgets {
    // Initialize HomeBinding on first access
    if (!Get.isRegistered<HomeController>()) {
      HomeBinding().dependencies();
    }
    // Initialize ProfileBinding when ProfilePage is accessed
    if (!Get.isRegistered<ProfileController>()) {
      ProfileBinding().dependencies();
    }
    return [
      const HomePage(),
      SeacrhPage(),
      ProductPage(),
      const ProfilePage(),
    ];
  }

  final List<IconData> icons = [
    Icons.home_filled,
    Icons.search,
    Icons.store_mall_directory_outlined,
    Icons.person_3_rounded,
  ];

  final List<String> labels = ["Beranda", "Pencarian", "Produk", "Profil"];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading while checking for vendor stall
      if (controller.isCheckingStall.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      
      return Scaffold(
        body: _optionWidgets.elementAt(controller.selectedIndex.value),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Item kiri (Beranda dan Pencarian)
            ...List.generate(2, (index) {
              final isSelected = controller.selectedIndex.value == index;
              return GestureDetector(
                onTap: () {
                  controller.changeIndex(index);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Icon(
                        icons[index],
                        size: 26,
                        color: isSelected ? Color(0xFFF95929) : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: isSelected ? 12 : 11,
                        color: isSelected ? Color(0xFFF95929) : Colors.grey,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
            // Spacer untuk FloatingActionButton di tengah
            SizedBox(width: 56),
            // Item kanan (Produk dan Profil)
            ...List.generate(2, (index) {
              final navIndex =
                  index + 2; // Index 2 dan 3 untuk Produk dan Profil
              final isSelected = controller.selectedIndex.value == navIndex;
              return GestureDetector(
                onTap: () {
                  controller.changeIndex(navIndex);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Icon(
                        icons[navIndex],
                        size: 26,
                        color: isSelected ? Color(0xFFF95929) : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      labels[navIndex],
                      style: TextStyle(
                        fontSize: isSelected ? 12 : 11,
                        color: isSelected ? Color(0xFFF95929) : Colors.grey,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: controller.isVendor
          ? Obx(() => FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {
                controller.toggleLocationSharing();
              },
              backgroundColor: controller.isLocationSharingActive.value
                  ? Colors.orange
                  : Colors.green,
              child: Icon(
                controller.isLocationSharingActive.value
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 32,
              ),
            ))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }
}
