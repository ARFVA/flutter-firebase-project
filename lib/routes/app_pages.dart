import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyquest/features/auth/controllers/auth_controller.dart';
import 'package:studyquest/features/auth/views/login_screen.dart';
import 'package:studyquest/features/auth/views/register_screen.dart';
import 'package:studyquest/features/auth/views/phone_auth_screen.dart';
import 'package:studyquest/features/auth/views/otp_screen.dart';
import 'package:studyquest/features/home/views/home_screen.dart';
import 'package:studyquest/features/quests/views/quest_list_screen.dart';
import 'package:studyquest/features/quests/views/create_quest_screen.dart';
import 'package:studyquest/features/study_room/views/study_room_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: Routes.PHONE_AUTH,
      page: () => const PhoneAuthScreen(),
    ),
    GetPage(
      name: Routes.OTP,
      page: () => const OtpScreen(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.QUESTS,
      page: () => const QuestListScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.CREATE_QUEST,
      page: () => const CreateQuestScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.STUDY_ROOM,
      page: () => const StudyRoomScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    if (authController.currentUser == null) {
      return const RouteSettings(name: Routes.LOGIN);
    }
    return null;
  }
}
