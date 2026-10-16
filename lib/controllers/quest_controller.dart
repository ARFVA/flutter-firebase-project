import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/data/models/quest_model.dart';
import 'package:studyquest/data/repositories/quest_repository_impl.dart';
import 'package:studyquest/controllers/auth_controller.dart';
import 'package:studyquest/features/quests/views/quest_list_screen.dart';
import 'package:uuid/uuid.dart';

class QuestController extends GetxController {
  final QuestRepository repository;
  final AuthController authController;

  QuestController(this.repository, this.authController);

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

  StreamSubscription? _authSub;

  @override
  void onInit() {
    super.onInit();

    // If a user is already present, load immediately; otherwise wait for auth
    if (authController.currentUser != null) {
      loadQuests();
    }

    // React to auth changes: load when a user signs in, clear when signs out.
    _authSub = authController.repository.authStateChanges().listen((user) {
      if (user != null) {
        loadQuests();
      } else {
        _quests.clear();
        _activeQuests.clear();
        _completedQuests.clear();
        _errorMessage.value = '';
        _isLoading.value = false;
      }
    });
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
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

  /// Marks a quest as completed.
  ///
  /// Server-authoritative flow: the client only flips [QuestModel.isCompleted].
  /// The `onQuestComplete` Cloud Function validates the transition, awards XP,
  /// updates level/streak, and records the activity exactly once (idempotent).
  /// The profile UI updates reactively through [ProfileController]'s snapshot
  /// subscription, so no client-side XP math is performed here.
  Future<void> completeQuest(String questId) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final user = authController.currentUser;
    if (user == null) {
      _isLoading.value = false;
      return;
    }

    // Get quest details (guard: only owner can complete, and only once).
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
        if (quest == null || quest.isCompleted || quest.userId != user.uid) {
          _isLoading.value = false;
          return;
        }

        // Only mark completion; XP is awarded server-side.
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
          (_) {
            _isLoading.value = false;
            Get.snackbar(
              'Success',
              'Quest completed! +${quest.xp} XP (verifying...)',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.shade700,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
            loadQuests();
            // XP and daily progress update when the Cloud Function writes the
            // authoritative profile and activity records.
          },
        );
      },
    );
  }

  void clearError() {
    _errorMessage.value = '';
  }
}
