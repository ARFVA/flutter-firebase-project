import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyquest/core/errors/exceptions.dart';
import 'package:studyquest/core/constants/firebase_constants.dart';
import 'package:studyquest/data/models/activity_model.dart';

abstract class ActivityRemoteDataSource {
  Future<String> createActivity(ActivityModel activity);
  Future<List<ActivityModel>> getUserActivities(String userId);
  Future<List<ActivityModel>> getTodayActivities(String userId);
  Future<int> getTodayXp(String userId);
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  final FirebaseFirestore firestore;

  ActivityRemoteDataSourceImpl(this.firestore);

  @override
  Future<String> createActivity(ActivityModel activity) async {
    try {
      final docRef = firestore
          .collection(FirebaseConstants.activitiesCollection)
          .doc(activity.id);
      
      await docRef.set(activity.toMap());
      return activity.id;
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ActivityModel>> getUserActivities(String userId) async {
    try {
      final snapshot = await firestore
          .collection(FirebaseConstants.activitiesCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => ActivityModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ActivityModel>> getTodayActivities(String userId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await firestore
          .collection(FirebaseConstants.activitiesCollection)
          .where('userId', isEqualTo: userId)
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('createdAt', isLessThan: endOfDay.toIso8601String())
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ActivityModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<int> getTodayXp(String userId) async {
    try {
      final activities = await getTodayActivities(userId);
      return activities.fold<int>(0, (total, activity) => total + activity.xpGained);
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
