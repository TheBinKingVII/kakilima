import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakilima/features/auth/domain/entities/auth_user_entity.dart';
import 'package:kakilima/features/auth/domain/usecases/auth_usecase.dart';
import 'package:kakilima/routes/app_pages.dart';

class AuthControllers extends GetxController {
  final AuthUsecase _authUsecase;
  final Rx<AuthUserEntity?> _currentUser = Rx<AuthUserEntity?>(null);

  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  TextEditingController? _passwordController;

  TextEditingController get firstNameController {
    try {
      if (_firstNameController == null ||
          !_isControllerValid(_firstNameController)) {
        _firstNameController?.dispose();
        _firstNameController = TextEditingController();
      }
      return _firstNameController!;
    } catch (e) {
      // If anything fails, create a new controller
      _firstNameController?.dispose();
      _firstNameController = TextEditingController();
      return _firstNameController!;
    }
  }

  TextEditingController get lastNameController {
    try {
      if (_lastNameController == null ||
          !_isControllerValid(_lastNameController)) {
        _lastNameController?.dispose();
        _lastNameController = TextEditingController();
      }
      return _lastNameController!;
    } catch (e) {
      // If anything fails, create a new controller
      _lastNameController?.dispose();
      _lastNameController = TextEditingController();
      return _lastNameController!;
    }
  }

  TextEditingController get emailController {
    try {
      if (_emailController == null || !_isControllerValid(_emailController)) {
        _emailController?.dispose();
        _emailController = TextEditingController();
      }
      return _emailController!;
    } catch (e) {
      // If anything fails, create a new controller
      _emailController?.dispose();
      _emailController = TextEditingController();
      return _emailController!;
    }
  }

  TextEditingController get phoneController {
    try {
      if (_phoneController == null || !_isControllerValid(_phoneController)) {
        _phoneController?.dispose();
        _phoneController = TextEditingController();
      }
      return _phoneController!;
    } catch (e) {
      // If anything fails, create a new controller
      _phoneController?.dispose();
      _phoneController = TextEditingController();
      return _phoneController!;
    }
  }

  TextEditingController get passwordController {
    try {
      if (_passwordController == null ||
          !_isControllerValid(_passwordController)) {
        _passwordController?.dispose();
        _passwordController = TextEditingController();
      }
      return _passwordController!;
    } catch (e) {
      // If anything fails, create a new controller
      _passwordController?.dispose();
      _passwordController = TextEditingController();
      return _passwordController!;
    }
  }

  bool _isControllerValid(TextEditingController? controller) {
    if (controller == null) return false;
    try {
      // Try to access controller properties to check if it's disposed
      // Accessing text or selection on a disposed controller will throw
      final _ = controller.text;
      final _ = controller.selection;
      return true;
    } catch (e) {
      // Controller is disposed or invalid
      return false;
    }
  }

  final RxBool _isLoading = RxBool(false);
  final RxnString _error = RxnString();

  final isPedagang = false.obs;
  final isPasswordVisible = false.obs;

  final List<Map<String, String>> countries = const [
    {
      'code': '+62',
      'name': 'Indonesia',
      'flag_top': '#CE1126',
      'flag_bottom': 'white',
    },
    {
      'code': '+1',
      'name': 'United States',
      'flag_top': '#002868',
      'flag_bottom': 'white',
    },
    {
      'code': '+44',
      'name': 'United Kingdom',
      'flag_top': '#012169',
      'flag_bottom': 'white',
    },
    {
      'code': '+81',
      'name': 'Japan',
      'flag_top': 'white',
      'flag_bottom': 'white',
    },
    {
      'code': '+86',
      'name': 'China',
      'flag_top': '#DE2910',
      'flag_bottom': '#DE2910',
    },
    {
      'code': '+60',
      'name': 'Malaysia',
      'flag_top': '#007A5E',
      'flag_bottom': '#FFFFFF',
    },
  ];

  final RxMap<String, String> selectedCountry = <String, String>{}.obs;

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  AuthUserEntity? get currentUser => _currentUser.value;

  AuthControllers(this._authUsecase);

  @override
  void onInit() {
    super.onInit();
    // Ensure controllers are initialized (lazy initialization via getters)
    // Access them to trigger initialization
    _ensureControllersInitialized();
    selectedCountry.assignAll(countries.first);
    loadCurrentUser();
  }

  @override
  void onReady() {
    super.onReady();
    // Reinitialize controllers when page becomes ready (e.g., after navigation)
    // This ensures controllers are valid after navigating between auth pages
    _ensureControllersInitialized();
  }

  void _ensureControllersInitialized() {
    // Force initialization of all controllers by accessing them
    // Getters will recreate them if they were disposed
    try {
      firstNameController;
      lastNameController;
      emailController;
      phoneController;
      passwordController;
    } catch (e) {
      // If any controller fails, recreate all of them
      _recreateAllControllers();
    }
  }

  void _recreateAllControllers() {
    _firstNameController?.dispose();
    _lastNameController?.dispose();
    _emailController?.dispose();
    _phoneController?.dispose();
    _passwordController?.dispose();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<void> loadCurrentUser() async {
    final result = await _authUsecase.getCurrentUser();
    result.fold(
      (failure) => throw failure,
      (user) => _currentUser.value = user,
    );
  }

  Future<void> vendorSignInWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading.value = true;
    _error.value = null;
    final result = await _authUsecase.vendorSignInWithEmail(
      email: email,
      password: password,
    );
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
        // Dispose auth controller when successfully logging in (navigating to main)
        // Since controller is permanent, we need to manually dispose it
        Future.microtask(() {
          if (Get.isRegistered<AuthControllers>()) {
            Get.delete<AuthControllers>();
          }
        });
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
    final result = await _authUsecase.customerSignInWithEmail(
      email: email,
      password: password,
    );
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
        // Dispose auth controller when successfully logging in (navigating to main)
        // Since controller is permanent, we need to manually dispose it
        Future.microtask(() {
          if (Get.isRegistered<AuthControllers>()) {
            Get.delete<AuthControllers>();
          }
        });
        return;
      },
    );
  }

  Future<void> registerWithEmail() async {
    final fullName =
        '${firstNameController.text.trim()} ${lastNameController.text.trim()}'
            .trim();
    final phone =
        '${selectedCountry['code'] ?? ''}${phoneController.text.trim()}';
    if (isPedagang.value) {
      await vendorSignUpWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
        fullName: fullName,
        phone: phone,
      );
      // Only navigate if no error (successful registration)
      if (_error.value == null || _error.value!.isEmpty) {
        // Clear credentials before navigation
        _clearCredentials();
        // move to login page (using offNamed to keep controller alive)
        Get.offNamed(Routes.authLogin);
      }
    } else {
      await customerSignUpWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
        fullName: fullName,
        phone: phone,
      );
      // Only navigate if no error (successful registration)
      if (_error.value == null || _error.value!.isEmpty) {
        // Clear credentials before navigation
        _clearCredentials();
        // move to login page (using offNamed to keep controller alive)
        Get.offNamed(Routes.authLogin);
      } else {
        _error.value = 'Registration failed';
      }
    }
  }

  void togglePedagang(bool value) => isPedagang.value = value;

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  void pickCountry(Map<String, String> country) =>
      selectedCountry.assignAll(country);

  void _clearCredentials() {
    try {
      // Use getters to ensure controllers are valid before clearing
      // Getters will recreate controllers if they were disposed
      final email = emailController;
      final password = passwordController;
      final firstName = firstNameController;
      final lastName = lastNameController;
      final phone = phoneController;

      // Clear only if controllers are valid
      if (_isControllerValid(email)) email.clear();
      if (_isControllerValid(password)) password.clear();
      if (_isControllerValid(firstName)) firstName.clear();
      if (_isControllerValid(lastName)) lastName.clear();
      if (_isControllerValid(phone)) phone.clear();

      isPedagang.value = false;
      isPasswordVisible.value = false;
      selectedCountry.assignAll(countries.first);
      _error.value = null;
    } catch (e) {
      // Controllers might be disposed, ignore and let getters recreate them
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
    final result = await _authUsecase.vendorSignUpWithEmail(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
    );
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
    final result = await _authUsecase.customerSignUpWithEmail(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
    );
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
    // Don't dispose TextEditingControllers here because:
    // 1. Controller is shared between login and register pages
    // 2. They will be automatically cleaned up when controller is permanently disposed
    // 3. Disposing them causes "used after disposed" errors when navigating between auth pages
    // Only dispose when controller is permanently removed (handled by GetX)
    super.onClose();
  }
}
