import 'package:get/get.dart';
import 'package:studyquest/data/models/quest_model.dart';
import 'package:studyquest/data/repositories/quest_repository_impl.dart';
import 'package:studyquest/features/auth/controllers/auth_controller.dart';
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
    if (user == null) return;

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
        );
      },
      (_) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Quest created successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
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
        );
      },
      (_) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Quest updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
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
        );
      },
      (_) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Quest deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        loadQuests();
      },
    );
  }

  Future<void> completeQuest(String questId) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    final result = await repository.completeQuest(questId);

    result.fold(
      (failure) {
        _errorMessage.value = failure.message;
        _isLoading.value = false;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (_) {
        _isLoading.value = false;
        Get.snackbar(
          'Success',
          'Quest completed! +XP',
          snackPosition: SnackPosition.BOTTOM,
        );
        loadQuests();
      },
    );
  }

  void clearError() {
    _errorMessage.value = '';
  }
}
