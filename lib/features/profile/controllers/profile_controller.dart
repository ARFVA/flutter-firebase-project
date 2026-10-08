import 'package:get/get.dart';
import 'package:studyquest/data/models/user_profile_model.dart';
import 'package:studyquest/data/repositories/user_profile_repository_impl.dart';
import 'package:studyquest/features/auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final UserProfileRepository repository;
  final AuthController authController;

  ProfileController(this.repository, this.authController);

  final Rx<UserProfileModel?> _profile = Rx<UserProfileModel?>(null);
  UserProfileModel? get profile => _profile.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = authController.currentUser;
    if (user == null) return;

    _isLoading.value = true;

    final result = await repository.getUserProfile(user.uid);

    result.fold(
      (failure) {
        _isLoading.value = false;
      },
      (profile) {
        _profile.value = profile;
        _isLoading.value = false;
      },
    );
  }

  Future<void> updateDailyTarget(int newTarget) async {
    final user = authController.currentUser;
    if (user == null || _profile.value == null) return;

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
        );
      },
      (_) {
        _profile.value = updatedProfile;
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Daily target updated!',
          snackPosition: SnackPosition.BOTTOM,
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
}
