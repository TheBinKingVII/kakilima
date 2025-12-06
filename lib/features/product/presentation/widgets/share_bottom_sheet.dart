import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareBottomSheet extends StatelessWidget {
  const ShareBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          const Text(
            'Bagikan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Social media icons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSocialIconWithImage(
                  imagePath: 'assets/google_icon.png',
                  onTap: () {
                    Get.back();
                    Get.snackbar('Share', 'Share to Facebook');
                    // TODO: Implement Facebook share
                  },
                ),
                _buildSocialIconWithImage(
                  imagePath: 'assets/massage_icon.png',
                  onTap: () {
                    Get.back();
                    Get.snackbar('Share', 'Share to Messenger');
                    // TODO: Implement Messenger share
                  },
                ),
                _buildSocialIconWithImage(
                  imagePath: 'assets/email_icon.png',
                  onTap: () {
                    Get.back();
                    Get.snackbar('Share', 'Share via Email');
                    // TODO: Implement Email share
                  },
                ),
                _buildSocialIconWithImage(
                  imagePath: 'assets/instagram_icon.png',
                  onTap: () {
                    Get.back();
                    Get.snackbar('Share', 'Share to Instagram');
                    // TODO: Implement Instagram share
                  },
                ),
                _buildSocialIconWithImage(
                  imagePath: 'assets/whatsapp_icon.png',
                  onTap: () {
                    Get.back();
                    Get.snackbar('Share', 'Share to WhatsApp');
                    // TODO: Implement WhatsApp share
                  },
                ),
                _buildSocialIcon(
                  icon: Icons.more_horiz,
                  color: const Color(0xFF757575),
                  label: '',
                  onTap: () {
                    Get.back();
                    Get.snackbar('Share', 'More options');
                    // TODO: Implement native share
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Link field with copy icon
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Teks',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.copy,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Cancel button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6838),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildSocialIconWithImage({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
