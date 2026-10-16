import 'package:get/get.dart';
import 'package:studyquest/controllers/auth_controller.dart';
import 'package:studyquest/controllers/quest_controller.dart';
import 'package:studyquest/data/repositories/quest_repository_impl.dart';

class QuestBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      QuestController(
        Get.find<QuestRepository>(),
        Get.find<AuthController>(),
      ),
      permanent: true,
    );
  }
}
