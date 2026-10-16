import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:studyquest/data/datasources/activity_datasource.dart';
import 'package:studyquest/data/datasources/auth_datasource.dart';
import 'package:studyquest/data/datasources/firestore_datasource.dart';
import 'package:studyquest/data/datasources/quest_datasource.dart';
import 'package:studyquest/data/datasources/realtime_db_datasource.dart';
import 'package:studyquest/data/repositories/activity_repository_impl.dart';
import 'package:studyquest/data/repositories/auth_repository_impl.dart';
import 'package:studyquest/data/repositories/quest_repository_impl.dart';
import 'package:studyquest/data/repositories/room_repository_impl.dart';
import 'package:studyquest/data/repositories/user_profile_repository_impl.dart';
import 'package:studyquest/controllers/auth_controller.dart';
import 'package:studyquest/controllers/profile_controller.dart';
import 'package:studyquest/controllers/quest_controller.dart';
import 'package:studyquest/controllers/room_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final firestore = FirebaseFirestore.instance;
    final authRepository = AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(FirebaseAuth.instance),
    );
    final userProfileRepository = UserProfileRepositoryImpl(
      FirestoreRemoteDataSourceImpl(firestore),
    );
    final activityRepository = ActivityRepositoryImpl(
      ActivityRemoteDataSourceImpl(firestore),
    );
    final questRepository = QuestRepositoryImpl(
      QuestRemoteDataSourceImpl(firestore),
    );
    final roomRepository = RoomRepositoryImpl(
      RealtimeDBRemoteDataSourceImpl(
        FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://studyquest-firebase-default-rtdb.asia-southeast1.firebasedatabase.app',
        ),
      ),
    );

    final authController = Get.put(
      AuthController(authRepository, userProfileRepository),
      permanent: true,
    );
    Get.put(
      ProfileController(
        userProfileRepository,
        activityRepository,
        authController,
      ),
      permanent: true,
    );

    Get.put(
      QuestController(questRepository, authController),
      permanent: true,
    );
    Get.put(
      RoomController(roomRepository, authController),
      permanent: true,
    );
  }
}
