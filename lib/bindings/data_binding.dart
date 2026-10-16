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

class DataBinding extends Bindings {
  @override
  void dependencies() {
    final firestore = FirebaseFirestore.instance;

    Get.put<AuthRepository>(
      AuthRepositoryImpl(AuthRemoteDataSourceImpl(FirebaseAuth.instance)),
      permanent: true,
    );
    Get.put<UserProfileRepository>(
      UserProfileRepositoryImpl(FirestoreRemoteDataSourceImpl(firestore)),
      permanent: true,
    );
    Get.put<ActivityRepository>(
      ActivityRepositoryImpl(ActivityRemoteDataSourceImpl(firestore)),
      permanent: true,
    );
    Get.put<QuestRepository>(
      QuestRepositoryImpl(QuestRemoteDataSourceImpl(firestore)),
      permanent: true,
    );
    Get.put<RoomRepository>(
      RoomRepositoryImpl(
        RealtimeDBRemoteDataSourceImpl(
          FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL:
                'https://studyquest-firebase-default-rtdb.asia-southeast1.firebasedatabase.app',
          ),
        ),
      ),
      permanent: true,
    );
  }
}
