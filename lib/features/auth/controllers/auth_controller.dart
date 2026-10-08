import 'package:get/get.dart';
import 'package:studyquest/data/models/user_model.dart';
import 'package:studyquest/data/repositories/auth_repository_impl.dart';

class AuthController extends GetxController {
  final AuthRepository repository;

  AuthController(this.repository);

  // Auth state
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  UserModel? get currentUser => _currentUser.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _initAuthListener();
  }

  void _initAuthListener() {
    repository.authStateChanges().listen((user) {
      _currentUser.value = user;
    });
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await repository.registerWithEmailPassword(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        _isLoading.value = false;
        Get.snackbar(
          'Registration Failed',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (user) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Registration successful!',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await repository.loginWithEmailPassword(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        _isLoading.value = false;
        Get.snackbar(
          'Login Failed',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (user) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> logout() async {
    _isLoading.value = true;

    final result = await repository.logout();

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        _isLoading.value = false;
        Get.snackbar(
          'Logout Failed',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Logged out successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> resetPassword(String email) async {
    _isLoading.value = true;

    final result = await repository.sendPasswordResetEmail(email);

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        _isLoading.value = false;
        Get.snackbar(
          'Reset Failed',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Password reset email sent',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  void clearError() {
    _errorMessage.value = '';
  }
}
