import 'package:get/get.dart';
import 'package:studyquest/controllers/auth_controller.dart';
import 'package:studyquest/data/repositories/auth_repository_impl.dart';
import 'package:studyquest/data/repositories/user_profile_repository_impl.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      AuthController(
        Get.find<AuthRepository>(),
        Get.find<UserProfileRepository>(),
      ),
      permanent: true,
    );
  }
}
