import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyquest/core/errors/exceptions.dart';
import 'package:studyquest/core/constants/firebase_constants.dart';
import 'package:studyquest/data/models/user_profile_model.dart';

abstract class FirestoreRemoteDataSource {
  Future<void> createUserProfile(UserProfileModel profile);
  Future<UserProfileModel?> getUserProfile(String uid);
  Stream<UserProfileModel?> watchUserProfile(String uid);
  Future<void> updateUserProfile(UserProfileModel profile);
  Future<void> deleteUserProfile(String uid);
}

class FirestoreRemoteDataSourceImpl implements FirestoreRemoteDataSource {
  final FirebaseFirestore firestore;

  FirestoreRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createUserProfile(UserProfileModel profile) async {
    try {
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(profile.uid)
          .set(profile.toMap());
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserProfileModel?> getUserProfile(String uid) async {
    try {
      final doc = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists) {
        return null;
      }

      return UserProfileModel.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<UserProfileModel?> watchUserProfile(String uid) {
    return firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .where((doc) => doc.exists)
        .map((doc) => UserProfileModel.fromMap(doc.data()!));
  }

  @override
  Future<void> updateUserProfile(UserProfileModel profile) async {
    try {
      // Only client-editable fields are sent. XP/level/streak are owned by
      // Cloud Functions (server-authoritative) and blocked by security rules.
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(profile.uid)
          .update({
        'displayName': profile.displayName,
        'email': profile.email,
        'photoURL': profile.photoURL,
        'phoneNumber': profile.phoneNumber,
        'dailyTargetXp': profile.dailyTargetXp,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteUserProfile(String uid) async {
    try {
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .delete();
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
