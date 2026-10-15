import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'core/constants/app_constants.dart';
import 'core/services/fcm_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'data/datasources/auth_datasource.dart';
import 'data/datasources/firestore_datasource.dart';
import 'data/datasources/quest_datasource.dart';
import 'data/datasources/realtime_db_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/user_profile_repository_impl.dart';
import 'data/repositories/quest_repository_impl.dart';
import 'data/repositories/room_repository_impl.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/quests/controllers/quest_controller.dart';
import 'features/profile/controllers/profile_controller.dart';
import 'features/study_room/controllers/room_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // App Check: protects Firestore/RTDB/Storage/Functions from abuse.
    // Debug provider in debug builds; Play Integrity (Android) / DeviceCheck (Apple) in release.
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: kDebugMode
            ? AndroidProvider.debug
            : AndroidProvider.playIntegrity,
        appleProvider:
            kDebugMode ? AppleProvider.debug : AppleProvider.deviceCheck,
      );
      await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
      debugPrint('App Check activated');
    } catch (e) {
      debugPrint('App Check not initialized: $e');
    }

    // FCM: permission, foreground/background display, topics, token lifecycle.
    if (!kIsWeb) {
      try {
        await FCMService.instance.initialize();
      } catch (e) {
        debugPrint('FCM initialization failed: $e');
      }
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  // Initialize dependencies (manual DI kept explicit for readability).
  final authRemoteDataSource = AuthRemoteDataSourceImpl(FirebaseAuth.instance);
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);

  final firestoreRemoteDataSource =
      FirestoreRemoteDataSourceImpl(FirebaseFirestore.instance);
  final userProfileRepository =
      UserProfileRepositoryImpl(firestoreRemoteDataSource);

  final questRemoteDataSource =
      QuestRemoteDataSourceImpl(FirebaseFirestore.instance);
  final questRepository = QuestRepositoryImpl(questRemoteDataSource);

  final realtimeDBRemoteDataSource = RealtimeDBRemoteDataSourceImpl(
    FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://studyquest-firebase-default-rtdb.asia-southeast1.firebasedatabase.app',
    ),
  );
  final roomRepository = RoomRepositoryImpl(realtimeDBRemoteDataSource);

  final authController = AuthController(authRepository, userProfileRepository);
  final profileController =
      ProfileController(userProfileRepository, authController);
  final questController = QuestController(
    questRepository,
    authController,
    userProfileRepository,
    profileController,
  );
  final roomController = RoomController(roomRepository, authController);

  runApp(StudyQuestApp(
    authController: authController,
    profileController: profileController,
    questController: questController,
    roomController: roomController,
  ));
}

class StudyQuestApp extends StatelessWidget {
  final AuthController authController;
  final ProfileController profileController;
  final QuestController questController;
  final RoomController roomController;

  const StudyQuestApp({
    super.key,
    required this.authController,
    required this.profileController,
    required this.questController,
    required this.roomController,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(authController);
        Get.put(profileController);
        Get.put(questController);
        Get.put(roomController);
      }),
    );
  }
}
