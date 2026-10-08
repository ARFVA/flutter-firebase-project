import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyquest/core/errors/exceptions.dart';
import 'package:studyquest/core/constants/firebase_constants.dart';
import 'package:studyquest/data/models/quest_model.dart';

abstract class QuestRemoteDataSource {
  Future<String> createQuest(QuestModel quest);
  Future<List<QuestModel>> getUserQuests(String userId);
  Future<QuestModel?> getQuest(String questId);
  Future<void> updateQuest(QuestModel quest);
  Future<void> deleteQuest(String questId);
  Future<void> completeQuest(String questId);
  Future<List<QuestModel>> getActiveQuests(String userId);
  Future<List<QuestModel>> getCompletedQuests(String userId);
}

class QuestRemoteDataSourceImpl implements QuestRemoteDataSource {
  final FirebaseFirestore firestore;

  QuestRemoteDataSourceImpl(this.firestore);

  @override
  Future<String> createQuest(QuestModel quest) async {
    try {
      final docRef = firestore
          .collection(FirebaseConstants.questsCollection)
          .doc(quest.id);
      
      await docRef.set(quest.toMap());
      return quest.id;
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<QuestModel>> getUserQuests(String userId) async {
    try {
      final snapshot = await firestore
          .collection(FirebaseConstants.questsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      final quests = snapshot.docs
          .map((doc) => QuestModel.fromMap(doc.data()))
          .toList();

      // Sort locally instead of using orderBy to avoid index requirement
      quests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return quests;
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<QuestModel?> getQuest(String questId) async {
    try {
      final doc = await firestore
          .collection(FirebaseConstants.questsCollection)
          .doc(questId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return QuestModel.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateQuest(QuestModel quest) async {
    try {
      await firestore
          .collection(FirebaseConstants.questsCollection)
          .doc(quest.id)
          .update(quest.toMap()..['updatedAt'] = DateTime.now().toIso8601String());
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteQuest(String questId) async {
    try {
      await firestore
          .collection(FirebaseConstants.questsCollection)
          .doc(questId)
          .delete();
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> completeQuest(String questId) async {
    try {
      await firestore
          .collection(FirebaseConstants.questsCollection)
          .doc(questId)
          .update({
            'isCompleted': true,
            'completedAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          });
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<QuestModel>> getActiveQuests(String userId) async {
    try {
      final snapshot = await firestore
          .collection(FirebaseConstants.questsCollection)
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: false)
          .get();

      final quests = snapshot.docs
          .map((doc) => QuestModel.fromMap(doc.data()))
          .toList();

      // Sort locally instead of using orderBy to avoid index requirement
      quests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return quests;
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<QuestModel>> getCompletedQuests(String userId) async {
    try {
      final snapshot = await firestore
          .collection(FirebaseConstants.questsCollection)
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: true)
          .get();

      final quests = snapshot.docs
          .map((doc) => QuestModel.fromMap(doc.data()))
          .toList();

      // Sort locally instead of using orderBy to avoid index requirement
      quests.sort((a, b) {
        if (a.completedAt != null && b.completedAt != null) {
          return b.completedAt!.compareTo(a.completedAt!);
        }
        return b.createdAt.compareTo(a.createdAt);
      });
      
      return quests;
    } on FirebaseException catch (e) {
      throw ServerException('Firestore error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
