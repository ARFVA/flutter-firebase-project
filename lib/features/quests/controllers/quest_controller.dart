import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/data/models/quest_model.dart';
import 'package:studyquest/data/models/activity_model.dart';
import 'package:studyquest/data/repositories/quest_repository_impl.dart';
import 'package:studyquest/data/repositories/user_profile_repository_impl.dart';
import 'package:studyquest/data/repositories/activity_repository_impl.dart';
import 'package:studyquest/features/auth/controllers/auth_controller.dart';
import 'package:studyquest/features/quests/views/quest_list_screen.dart';
import 'package:studyquest/features/profile/controllers/profile_controller.dart';
import 'package:studyquest/core/utils/gamification_utils.dart';
import 'package:uuid/uuid.dart';

class QuestController extends GetxController {
  final QuestRepository repository;
  final AuthController authController;
  final UserProfileRepository userProfileRepository;
  final ActivityRepository activityRepository;
  final ProfileController profileController;

  QuestController(
    this.repository,
    this.authController,
    this.userProfileRepository,
    this.activityRepository,
    this.profileController,
  );

  // Quest state
  final RxList<QuestModel> _quests = <QuestModel>[].obs;
  List<QuestModel> get quests => _quests;

  final RxList<QuestModel> _activeQuests = <QuestModel>[].obs;
  List<QuestModel> get activeQuests => _activeQuests;

  final RxList<QuestModel> _completedQuests = <QuestModel>[].obs;
  List<QuestModel> get completedQuests => _completedQuests;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    loadQuests();
  }

  Future<void> loadQuests() async {
    final user = authController.currentUser;
    if (user == null) return;

    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await repository.getUserQuests(user.uid);

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
      (quests) {
        _quests.value = quests;
        _activeQuests.value = quests.where((q) => !q.isCompleted).toList();
        _completedQuests.value = quests.where((q) => q.isCompleted).toList();
        _isLoading.value = false;
      },
    );
  }

  Future<void> createQuest({
    required String title,
    required String description,
    required String type,
    required int xp,
    int? durationMinutes,
  }) async {
    final user = authController.currentUser;
    if (user == null) {
      Get.snackbar(
        'Error',
        'User not logged in',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    final questId = const Uuid().v4();
    final quest = QuestModel.create(
      id: questId,
      userId: user.uid,
      title: title,
      description: description,
      type: type,
      xp: xp,
      durationMinutes: durationMinutes,
    );

    final result = await repository.createQuest(quest);

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
      (_) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Quest created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
        );
        Get.off(() => const QuestListScreen()); // Navigate to quest list
        loadQuests();
      },
    );
  }

  Future<void> updateQuest(QuestModel quest) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await repository.updateQuest(quest);

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
      (_) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Quest updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
        );
        loadQuests();
      },
    );
  }

  Future<void> deleteQuest(String questId) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await repository.deleteQuest(questId);

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
      (_) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Quest deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
        );
        loadQuests();
      },
    );
  }

  Future<void> completeQuest(String questId) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final user = authController.currentUser;
    if (user == null) {
      _isLoading.value = false;
      return;
    }

    // Get quest details
    final questResult = await repository.getQuest(questId);
    
    questResult.fold(
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
      (quest) async {
        if (quest == null || quest.isCompleted) {
          _isLoading.value = false;
          return;
        }

        // Complete the quest
        final completeResult = await repository.completeQuest(questId);

        completeResult.fold(
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
          (_) async {
            // Get user profile
            final profileResult = await userProfileRepository.getUserProfile(user.uid);
            
            profileResult.fold(
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
              (profile) async {
                if (profile == null) {
                  _isLoading.value = false;
                  return;
                }

                // Calculate new XP and level
                final newXP = profile.xp + quest.xp;
                final newLevel = GamificationUtils.calculateLevel(newXP);
                final leveledUp = newLevel > profile.level;

                // Update user profile
                final updatedProfile = profile.copyWith(
                  xp: newXP,
                  level: newLevel,
                  updatedAt: DateTime.now(),
                );

                await userProfileRepository.updateUserProfile(updatedProfile);

                // Create activity record
                final activityId = const Uuid().v4();
                final activity = ActivityModel.create(
                  id: activityId,
                  userId: user.uid,
                  type: 'quest_complete',
                  description: 'Completed "${quest.title}"',
                  xpGained: quest.xp,
                );

                await activityRepository.createActivity(activity);

                // Check daily target and update streak
                final todayXpResult = await activityRepository.getTodayXp(user.uid);
                todayXpResult.fold(
                  (failure) {},
                  (todayXp) async {
                    if (GamificationUtils.isDailyTargetMet(todayXp, profile.dailyTargetXp)) {
                      // Update streak (simplified - in production this should be server-side)
                      final updatedStreakProfile = updatedProfile.copyWith(
                        streak: profile.streak + 1,
                        updatedAt: DateTime.now(),
                      );
                      await userProfileRepository.updateUserProfile(updatedStreakProfile);
                    }
                  },
                );

                _isLoading.value = false;
                
                // Refresh profile to update XP on home screen
                profileController.loadProfile();
                
                String message = 'Quest completed! +${quest.xp} XP';
                if (leveledUp) {
                  message += '\n🎉 Level Up! You are now level $newLevel';
                }
                
                Get.snackbar(
                  'Success',
                  message,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green.shade700,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
                loadQuests();
              },
            );
          },
        );
      },
    );
  }

  void clearError() {
    _errorMessage.value = '';
  }
}
