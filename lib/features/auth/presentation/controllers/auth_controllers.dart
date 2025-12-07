import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakilima/features/auth/domain/entities/auth_user_entity.dart';
import 'package:kakilima/features/auth/domain/usecases/auth_usecase.dart';
import 'package:kakilima/routes/app_pages.dart';

class AuthControllers extends GetxController {
  final AuthUsecase _authUsecase;
  final Rx<AuthUserEntity?> _currentUser = Rx<AuthUserEntity?>(null);

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool _isLoading = RxBool(false);
  final RxnString _error = RxnString();

  final isPedagang = false.obs;
  final isPasswordVisible = false.obs;

  final List<Map<String, String>> countries = const [
    {'code': '+62', 'name': 'Indonesia', 'flag_top': '#CE1126', 'flag_bottom': 'white'},
    {'code': '+1', 'name': 'United States', 'flag_top': '#002868', 'flag_bottom': 'white'},
    {'code': '+44', 'name': 'United Kingdom', 'flag_top': '#012169', 'flag_bottom': 'white'},
    {'code': '+81', 'name': 'Japan', 'flag_top': 'white', 'flag_bottom': 'white'},
    {'code': '+86', 'name': 'China', 'flag_top': '#DE2910', 'flag_bottom': '#DE2910'},
    {'code': '+60', 'name': 'Malaysia', 'flag_top': '#007A5E', 'flag_bottom': '#FFFFFF'},
  ];

  final RxMap<String, String> selectedCountry = <String, String>{}.obs;

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  AuthUserEntity? get currentUser => _currentUser.value;

  AuthControllers(this._authUsecase);

  @override
  void onInit() {
    super.onInit();
    selectedCountry.assignAll(countries.first);
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final result = await _authUsecase.getCurrentUser();
    result.fold(
      (failure) => throw failure,
      (user) => _currentUser.value = user!
    );
  }

  Future<void> vendorSignInWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading.value = true;
    _error.value = null;
    final result = await _authUsecase.vendorSignInWithEmail(email: email, password: password);
    result.fold(
      (failure) {
        _error.value = failure.message;
        _isLoading.value = false;
        return;
      },
      (user) {
        _currentUser.value = user;
        _clearCredentials();
        _isLoading.value = false;
        return;
      },
    );
  }

  Future<void> customerSignInWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading.value = true;
    _error.value = null;
    final result = await _authUsecase.customerSignInWithEmail(email: email, password: password);
    result.fold(
      (failure) {
        _error.value = failure.message;
        _isLoading.value = false;
        return;
      },
      (user) {
        _currentUser.value = user;
        _clearCredentials();
        _isLoading.value = false;
        return;
      },
    );
  }

  Future<void> registerWithEmail() async {
    final fullName = '${firstNameController.text.trim()} ${lastNameController.text.trim()}'.trim();
    final phone = '${selectedCountry['code'] ?? ''}${phoneController.text.trim()}';
    if (isPedagang.value) {
      try {
        await vendorSignUpWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text,
          fullName: fullName,
          phone: phone,
        );
        // Clear credentials before navigation
        _clearCredentials();
        // move to login page (using offNamed to keep controller alive)
        Get.offNamed(Routes.authLogin);
      } catch (e) {
        _error.value = e.toString();
        _isLoading.value = false;
        return;
      }
    } else {
      try {
        await customerSignUpWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text,
          fullName: fullName,
          phone: phone,
        );
        // Clear credentials before navigation
        _clearCredentials();
        // move to login page (using offNamed to keep controller alive)
        Get.offNamed(Routes.authLogin);
      } catch (e) {
        _error.value = e.toString();
        _isLoading.value = false;
        return;
      }
    }
  }

  void togglePedagang(bool value) => isPedagang.value = value;

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  void pickCountry(Map<String, String> country) => selectedCountry.assignAll(country);
  
  void _clearCredentials() {
    try {
      emailController.clear();
      passwordController.clear();
      firstNameController.clear();
      lastNameController.clear();
      phoneController.clear();
      isPedagang.value = false;
      isPasswordVisible.value = false;
      selectedCountry.assignAll(countries.first);
      _error.value = null;
    } catch (e) {
      // Controllers might be disposed, ignore
    }
  }

  Future<void> vendorSignUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    _isLoading.value = true;
    _error.value = null;
    final result = await _authUsecase.vendorSignUpWithEmail(email: email, password: password, fullName: fullName, phone: phone);
    result.fold(
      (failure) {
        _error.value = failure.message;
        _isLoading.value = false;
        return;
      },
      (user) {
        _currentUser.value = user;
        _isLoading.value = false;
        return;
      },
    );
  }

  Future<void> customerSignUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    _isLoading.value = true;
    _error.value = null;
    final result = await _authUsecase.customerSignUpWithEmail(email: email, password: password, fullName: fullName, phone: phone);
    result.fold(
      (failure) {
        _error.value = failure.message;
        _isLoading.value = false;
        return;
      },
      (user) {
      _currentUser.value = user;
      _isLoading.value = false;
      return;
      },
    );
  }

  Future<void> signOut() async {
    _isLoading.value = true;
    _error.value = null;
    final result = await _authUsecase.signOut();
    result.fold(
      (failure) {
        _error.value = failure.message;
        _isLoading.value = false;
        return;
      },
      (user) {
        _currentUser.value = null;
        _isLoading.value = false;
        return;
      },
    );
  }

  @override
  void onClose() {
    try {
      firstNameController.dispose();
      lastNameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      passwordController.dispose();
    } catch (e) {
      // Controllers might already be disposed, ignore
    }
    super.onClose();
  }

  
}