import 'package:get/get.dart';
import 'package:studyquest/controllers/auth_controller.dart';
import 'package:studyquest/controllers/profile_controller.dart';
import 'package:studyquest/data/repositories/activity_repository_impl.dart';
import 'package:studyquest/data/repositories/user_profile_repository_impl.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ProfileController(
        Get.find<UserProfileRepository>(),
        Get.find<ActivityRepository>(),
        Get.find<AuthController>(),
      ),
      permanent: true,
    );
  }
}
