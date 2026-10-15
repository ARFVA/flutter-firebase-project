import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/core/services/fcm_service.dart';
import 'package:studyquest/data/models/user_model.dart';
import 'package:studyquest/data/models/user_profile_model.dart';
import 'package:studyquest/data/repositories/auth_repository_impl.dart';
import 'package:studyquest/data/repositories/user_profile_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthController extends GetxController {
  final AuthRepository repository;
  final UserProfileRepository userProfileRepository;

  AuthController(this.repository, this.userProfileRepository);

  // Auth state
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  UserModel? get currentUser => _currentUser.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  // Phone auth state
  final RxString _verificationId = ''.obs;
  String get verificationId => _verificationId.value;

  @override
  void onInit() {
    super.onInit();
    _initAuthListener();
  }

  void _initAuthListener() {
    repository.authStateChanges().listen((user) {
      _currentUser.value = user;
      if (user != null && Get.currentRoute != '/home') {
        Get.offAllNamed('/home');
        // Persist FCM token so backend can push to this device.
        FCMService.instance.saveTokenToProfile(user.uid);
        FCMService.instance.subscribeToUserTopic(user.uid);
      } else if (user == null && Get.currentRoute != '/login') {
        Get.offAllNamed('/login');
      }
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
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      },
      (user) async {
        // Create user profile in Firestore
        final profile = UserProfileModel.create(
          uid: user.uid,
          displayName: email.split('@')[0],
          email: user.email ?? email,
          photoURL: user.photoURL,
          phoneNumber: user.phoneNumber,
        );

        final profileResult = await userProfileRepository.createUserProfile(profile);

        profileResult.fold(
          (failure) {
            _errorMessage.value = failure.message;
            _isLoading.value = false;
            Get.snackbar(
              'Profile Creation Failed',
              failure.message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade700,
              colorText: Colors.white,
            );
          },
          (_) {
            _isLoading.value = false;
            Get.snackbar(
              'Success',
              'Registration successful!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.shade700,
              colorText: Colors.white,
            );
            Get.offAllNamed('/home');
          },
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
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      },
      (user) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
        );
        Get.offAllNamed('/home');
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
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      },
      (_) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Logged out successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
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
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      },
      (_) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Password reset email sent',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
        );
      },
    );
  }

  void clearError() {
    _errorMessage.value = '';
  }

  Future<void> refreshCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await firebaseUser.reload();
      _currentUser.value = UserModel.fromFirebaseUser(firebaseUser);
    }
  }

  Future<void> refreshCurrentUserWithProfile(UserProfileModel? profile) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await firebaseUser.reload();
      var userModel = UserModel.fromFirebaseUser(firebaseUser);
      // Update display name from profile if available
      if (profile != null) {
        userModel = userModel.copyWith(displayName: profile.displayName);
      }
      _currentUser.value = userModel;
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await repository.sendOtp(phoneNumber);

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        _isLoading.value = false;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      },
      (verificationId) {
        _verificationId.value = verificationId;
        _isLoading.value = false;
        Get.toNamed('/otp', arguments: {
          'phoneNumber': phoneNumber,
          'verificationId': verificationId,
        });
      },
    );
  }

  Future<void> verifyOtp(String verificationId, String otp) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await repository.verifyOtp(verificationId, otp);

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        _isLoading.value = false;
        Get.snackbar(
          'Verification Failed',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      },
      (user) async {
        // Check if user profile exists, create if not
        final profileResult = await userProfileRepository.getUserProfile(user.uid);
        
        profileResult.fold(
          (failure) async {
            // Profile doesn't exist, create it
            final displayName = user.phoneNumber ?? user.email?.split('@')[0] ?? 'User';
            final profile = UserProfileModel.create(
              uid: user.uid,
              displayName: displayName,
              email: user.email ?? '',
              photoURL: user.photoURL,
              phoneNumber: user.phoneNumber,
            );
            await userProfileRepository.createUserProfile(profile);
          },
          (profile) {
            // Profile exists, do nothing
          },
        );

        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Phone verification successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
        );
        Get.offAllNamed('/home');
      },
    );
  }

  Future<void> signInWithGoogle() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        _isLoading.value = false;
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      final result = await repository.signInWithCredential(credential);

      result.fold(
        (failure) {
          _errorMessage.value = failure.message;
          _isLoading.value = false;
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade700,
            colorText: Colors.white,
          );
        },
        (user) async {
          // Check if user profile exists, create if not
          final profileResult = await userProfileRepository.getUserProfile(user.uid);
          
          profileResult.fold(
            (failure) async {
              // Profile doesn't exist, create it
              final displayName = user.displayName ?? user.email?.split('@')[0] ?? 'User';
              final profile = UserProfileModel.create(
                uid: user.uid,
                displayName: displayName,
                email: user.email ?? '',
                photoURL: user.photoURL,
                phoneNumber: user.phoneNumber,
              );
              await userProfileRepository.createUserProfile(profile);
            },
            (profile) {
              // Profile exists, do nothing
            },
          );

          _isLoading.value = false;
          Get.snackbar(
            'Success',
            'Google sign in successful!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade700,
            colorText: Colors.white,
          );
          Get.offAllNamed('/home');
        },
      );
    } catch (e) {
      _errorMessage.value = e.toString();
      _isLoading.value = false;
      Get.snackbar(
        'Error',
        'Google sign in failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }
  }

  Future<void> requestNotificationPermission() async {
    final messaging = FirebaseMessaging.instance;
    
    // Request permission for iOS
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Get FCM token
    final token = await messaging.getToken();
    debugPrint('FCM Token: $token');
  }
}
