import 'package:get/get.dart';
import 'package:studyquest/bindings/auth_binding.dart';
import 'package:studyquest/bindings/data_binding.dart';
import 'package:studyquest/bindings/profile_binding.dart';
import 'package:studyquest/bindings/quest_binding.dart';
import 'package:studyquest/bindings/room_binding.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    DataBinding().dependencies();
    AuthBinding().dependencies();
    ProfileBinding().dependencies();
    QuestBinding().dependencies();
    RoomBinding().dependencies();
  }
}
