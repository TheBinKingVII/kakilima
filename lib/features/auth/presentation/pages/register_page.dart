import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakilima/features/auth/presentation/controllers/auth_controllers.dart';
import 'package:kakilima/routes/app_pages.dart';

class RegisterPage extends GetView<AuthControllers> {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: Image.asset(
                          'assets/vector_icon.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Get Started now',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Create an account or log in to explore\nabout our app',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextButton(
                            onPressed: () {
                              // Use offNamed to keep controller alive since both pages share AuthBinding
                              Get.offNamed(Routes.authLogin);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              minimumSize: const Size.fromHeight(40),
                            ),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                minimumSize: const Size.fromHeight(40),
                              ),
                              child: const Text(
                                'Daftar',
                                style: TextStyle(fontSize: 13, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sebagai Pedagang',
                      style: TextStyle(fontSize: 14),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Obx(
                        () => Switch(
                          value: controller.isPedagang.value,
                          onChanged: controller.togglePedagang,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama Depan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6C7278),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: controller.firstNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama Belakang',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6C7278),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: controller.lastNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6C7278),
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 8.0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Nomor Telfon',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6C7278),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () {
                    final country = controller.selectedCountry;
                    return TextField(
                      controller: controller.phoneController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 8.0,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 6.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PopupMenuButton<Map<String, String>>(
                                position: PopupMenuPosition.under,
                                onSelected: controller.pickCountry,
                                itemBuilder: (context) => controller.countries.map((country) {
                                  return PopupMenuItem<Map<String, String>>(
                                    value: country,
                                    child: Row(
                                      children: [
                                        _buildFlagCircle(
                                          country['flag_top'] ?? '#CE1126',
                                          country['flag_bottom'] ?? 'white',
                                        ),
                                        const SizedBox(width: 8),
                                        Text('${country['name']} (${country['code']})'),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildFlagCircle(
                                      country['flag_top'] ?? '#CE1126',
                                      country['flag_bottom'] ?? 'white',
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_drop_down, size: 18, color: Colors.grey),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 1,
                                height: 18,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                country['code'] ?? '+62',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kata Sandi',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6C7278),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => TextField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8.0,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Error Message
                Text(controller.error ?? '', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5722),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      minimumSize: const Size.fromHeight(52),
                    ),
                    onPressed: controller.isLoading ? null : controller.registerWithEmail,
                    child: controller.isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Daftar', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildFlagCircle(String topColor, String bottomColor) {
    Color parseColor(String colorStr) {
      if (colorStr == 'white') return Colors.white;
      final hexColor = colorStr.replaceFirst('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: parseColor(topColor),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: 28,
            height: 14,
            decoration: BoxDecoration(
              color: parseColor(bottomColor),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
