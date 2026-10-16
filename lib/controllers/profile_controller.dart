import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/data/models/user_model.dart';
import 'package:studyquest/data/models/user_profile_model.dart';
import 'package:studyquest/data/repositories/activity_repository_impl.dart';
import 'package:studyquest/data/repositories/user_profile_repository_impl.dart';
import 'package:studyquest/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final UserProfileRepository repository;
  final ActivityRepository activityRepository;
  final AuthController authController;

  ProfileController(
    this.repository,
    this.activityRepository,
    this.authController,
  );

  final Rx<UserProfileModel?> _profile = Rx<UserProfileModel?>(null);
  UserProfileModel? get profile => _profile.value;

  final RxInt _todayXp = 0.obs;
  int get todayXp => _todayXp.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Allow direct access to the observable for reactive updates
  Rx<UserProfileModel?> get profileObservable => _profile;

  StreamSubscription<UserProfileModel?>? _profileSubscription;
  StreamSubscription<UserModel?>? _authSubscription;

  @override
  void onInit() {
    super.onInit();
    loadProfile();

    // React to auth state: loadProfile() above can no-op when the current user
    // isn't available yet (race on cold start / first sign-in). Re-run whenever
    // Firebase Auth emits a user so XP/level/name always render, and clear on
    // sign-out.
    _authSubscription =
        authController.repository.authStateChanges().listen((user) {
      if (user != null) {
        loadProfile();
      } else {
        _profileSubscription?.cancel();
        _profile.value = null;
        _todayXp.value = 0;
      }
    });
  }

  @override
  void onClose() {
    _profileSubscription?.cancel();
    _authSubscription?.cancel();
    super.onClose();
  }

  Future<void> loadProfile() async {
    final user = authController.currentUser;
    if (user == null) return;

    _isLoading.value = true;

    final result = await repository.getUserProfile(user.uid);

    result.fold(
      (failure) {
        _isLoading.value = false;
        Get.snackbar(
          'Profile unavailable',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      },
      (profile) {
        _profile.value =
            profile ??
            UserProfileModel.create(
              uid: user.uid,
              displayName:
                  user.displayName ?? user.email?.split('@')[0] ?? 'User',
              email: user.email ?? '',
              photoURL: user.photoURL,
              phoneNumber: user.phoneNumber,
            );
        _isLoading.value = false;
        _watchProfile(user.uid);
      },
    );

    await loadTodayXp();
  }

  Future<void> loadTodayXp() async {
    final user = authController.currentUser;
    if (user == null) {
      _todayXp.value = 0;
      return;
    }

    final result = await activityRepository.getTodayXp(user.uid);
    result.fold(
      (failure) => debugPrint('Failed to load today XP: ${failure.message}'),
      (xp) => _todayXp.value = xp,
    );
  }

  /// Subscribes to profile snapshots so server-side XP/level/streak updates
  /// (awarded by Cloud Functions) appear in the UI without manual refresh.
  void _watchProfile(String uid) {
    _profileSubscription?.cancel();
    _profileSubscription = repository.watchUserProfile(uid).listen(
      (profile) {
        if (profile != null) {
          final xpChanged = _profile.value?.xp != profile.xp;
          _profile.value = profile;
          if (xpChanged) {
            loadTodayXp();
          }
        }
      },
      onError: (Object e) {
        debugPrint('Profile watch error: $e');
      },
    );
  }

  Future<void> updateDailyTarget(int newTarget) async {
    final user = authController.currentUser;
    if (user == null || _profile.value == null) return;

    // Validate input (client-side guard; server re-validates on write)
    if (newTarget < 50 || newTarget > 10000) {
      Get.snackbar(
        'Invalid',
        'Daily target must be between 50 and 10,000 XP',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _isLoading.value = true;

    final updatedProfile = _profile.value!.copyWith(
      dailyTargetXp: newTarget,
      updatedAt: DateTime.now(),
    );

    final result = await repository.updateUserProfile(updatedProfile);

    result.fold(
      (failure) {
        _isLoading.value = false;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      },
      (_) {
        _profile.value = updatedProfile;
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Daily target updated!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> updateUserProfile(UserProfileModel profile) async {
    _isLoading.value = true;

    final result = await repository.updateUserProfile(profile);

    result.fold(
      (failure) {
        _isLoading.value = false;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      },
      (_) {
        _profile.value = profile;
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Profile updated!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
        );
      },
    );
  }

  void updateProfileState(UserProfileModel profile) {
    _profile.value = profile;
  }

  // Force refresh profile from Firestore
  Future<void> forceRefresh() async {
    await loadProfile();
  }
}
