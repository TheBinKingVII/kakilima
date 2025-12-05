import 'package:get/get.dart';
import 'package:kakilima/features/auth/domain/entities/auth_user_entity.dart';
import 'package:kakilima/features/auth/domain/usecases/auth_usecase.dart';
class AuthControllers  extends GetxController{
  final AuthUsecase _authUsecase;
  final Rx<AuthUserEntity?> _currentUser = Rx<AuthUserEntity?>(null);

  final RxBool _isLoading = RxBool(false);
  final RxnString _error = RxnString();

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  AuthUserEntity? get currentUser => _currentUser.value;

  AuthControllers(this._authUsecase);

  @override
  void onInit() {
    super.onInit();
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
        _isLoading.value = false;
        return;
      },
    );
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
}