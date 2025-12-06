import 'package:flutter/material.dart';
import 'package:kakilima/features/home/presentation/pages/home_page.dart';
import 'package:kakilima/features/product/presentation/pages/product_page.dart';
import 'package:kakilima/features/search/presentation/pages/seacrh_page.dart';
import 'package:kakilima/features/auth/presentation/pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _optionWidgets = [
    HomePage(),
    SeacrhPage(),
    ProductPage(),
    ProfilePage(),
  ];

  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.search_outlined,
    Icons.store_outlined,
    Icons.person_outline_rounded,
  ];

  final List<String> labels = ["Beranda", "Pencarian", "Produk", "Profil"];

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _optionWidgets.elementAt(_selectedIndex)),
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
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  _onTapped(index);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(0xFFF95929)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icons[index],
                        size: 26,
                        color: isSelected ? Colors.white : Colors.grey,
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
              final isSelected = _selectedIndex == navIndex;
              return GestureDetector(
                onTap: () {
                  _onTapped(navIndex);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(0xFFF95929)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icons[navIndex],
                        size: 26,
                        color: isSelected ? Colors.white : Colors.grey,
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
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          // FAB untuk action khusus, tidak mengubah navigasi
          // Tambahkan logic untuk play button di sini jika diperlukan
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
