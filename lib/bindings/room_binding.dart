import 'package:get/get.dart';
import 'package:studyquest/controllers/auth_controller.dart';
import 'package:studyquest/controllers/room_controller.dart';
import 'package:studyquest/data/repositories/room_repository_impl.dart';

class RoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      RoomController(
        Get.find<RoomRepository>(),
        Get.find<AuthController>(),
      ),
      permanent: true,
    );
  }
}
