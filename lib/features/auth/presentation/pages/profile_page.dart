import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakilima/features/auth/presentation/controllers/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Profile Section
              _buildProfileSection(context),
              const SizedBox(height: 32),
              // Statistics Card
              _buildStatisticsCard(context),
              const SizedBox(height: 24),
              // Settings Section
              _buildSettingsSection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/profile_placeholder.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey.shade400,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name with Edit Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFF95929), width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Hengki',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.edit_square, size: 16, color: Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF95929).withAlpha(40),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFF95929),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.bar_chart, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistik',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFC6C40).withAlpha(100),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Seberapa keras saya bekerja hari ini?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFC6C40),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFFC6C40)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF95929),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFF95929), width: 0.5),
            ),
            child: Column(
              children: [
                _buildSettingItem(
                  icon: Icons.eco,
                  iconColor: Colors.green,
                  title: 'Mode Hemat Baterai',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                    activeColor: Colors.green,
                  ),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: Icons.language,
                  iconColor: Color(0xFFFEBB0E),
                  title: 'Bahasa',
                  subtitle: 'Bawaan',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: Icons.headset_mic,
                  iconColor: Colors.blue,
                  title: 'Customer Service',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: Icons.widgets,
                  iconColor: Color(0xFF8AC926),
                  title: 'Widget',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: Icons.notifications,
                  iconColor: Color(0xFF4B45ED),
                  title: 'Notifikasi',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: Icons.help_outline,
                  iconColor: Color(0xFF9A9C95),
                  title: 'Bantuan',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
                _buildDivider(),
                _buildSettingItem(
                  icon: Icons.exit_to_app,
                  iconColor: const Color(0xFFF95929),
                  title: 'Keluar Aplikasi',
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: const Color(0xFFF95929),
      indent: 16,
      endIndent: 16,
    );
  }
}
