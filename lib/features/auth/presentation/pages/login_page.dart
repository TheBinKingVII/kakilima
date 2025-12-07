import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakilima/features/auth/presentation/controllers/auth_controllers.dart';
import 'package:kakilima/routes/app_pages.dart';

class LoginPage extends GetView<AuthControllers> {
  const LoginPage({Key? key}) : super(key: key);

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
                      // Logo
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset(
                          'assets/vector_icon.png',
                          width: 30,
                          height: 30,
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
                      const SizedBox(height: 6),
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
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
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
                              'Masuk',
                              style: TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextButton(
                            onPressed: () {
                              // Use offNamed to keep controller alive since both pages share AuthBinding
                              Get.offNamed(Routes.authRegister);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              minimumSize: const Size.fromHeight(40),
                            ),
                            child: const Text(
                              'Daftar',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
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
                    const Text('Sebagai Pedagang'),
                    Obx(
                      () => Switch(
                        value: controller.isPedagang.value,
                        onChanged: controller.togglePedagang,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(value: false, onChanged: (v) {}),
                    const Text('Ingat Saya'),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Lupa Kata Sandi?',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(
                  () => controller.error != null && controller.error!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            controller.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
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
                    onPressed: controller.isLoading
                        ? null
                        : () async {
                            final email = controller.emailController.text.trim();
                            final password = controller.passwordController.text;
                            if (controller.isPedagang.value) {
                              await controller.vendorSignInWithEmail(
                                email: email,
                                password: password,
                              );
                              // Only move to home page if no error (successful login)
                              if (controller.error == null || controller.error!.isEmpty) {
                                // Small delay to ensure login state is fully updated
                                await Future.delayed(const Duration(milliseconds: 100));
                                Get.offAllNamed(Routes.main);
                              }
                            } else {
                              await controller.customerSignInWithEmail(
                                email: email,
                                password: password,
                              );
                              // Only move to home page if no error (successful login)
                              if (controller.error == null || controller.error!.isEmpty) {
                                Get.offAllNamed(Routes.main);
                              }
                            }
                          },
                    child: controller.isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Masuk', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 32),
                const Center(child: Text('Atau masuk dengan')),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SocialButton(
                      backgroundColor: Colors.white,
                      isGoogle: true,
                    ),
                    _SocialButton(
                      backgroundColor: Colors.white,
                      icon: Icons.facebook,
                      iconColor: const Color(0xFF1877F2),
                      iconSize: 28,
                    ),
                    _SocialButton(
                      backgroundColor: Colors.white,
                      icon: Icons.apple,
                      iconColor: Colors.black,
                      iconSize: 30,
                    ),
                    _SocialButton(
                      backgroundColor: Colors.white,
                      icon: Icons.smartphone,
                      iconColor: Colors.black,
                      iconSize: 23,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool isGoogle;
  final double? iconSize;

  const _SocialButton({
    this.icon,
    this.backgroundColor,
    this.iconColor,
    this.isGoogle = false,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: isGoogle
          ? Center(
              child: Image.asset(
                'assets/google_icon.png',
                width: 24,
                height: 24,
              ),
            )
          : icon != null
              ? Icon(icon, size: iconSize ?? 24, color: iconColor)
              : const SizedBox(),
    );
  }
}
