import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyquest/core/errors/exceptions.dart';
import 'package:studyquest/core/constants/firebase_constants.dart';
import 'package:studyquest/data/models/quest_completion_result.dart';
import 'package:studyquest/data/models/quest_model.dart';

abstract class QuestRemoteDataSource {
  Future<String> createQuest(QuestModel quest);
  Future<List<QuestModel>> getUserQuests(String userId);
  Future<QuestModel?> getQuest(String questId);
  Future<void> updateQuest(QuestModel quest);
  Future<void> deleteQuest(String questId);
  Future<QuestCompletionResult> completeQuest(String questId, String userId);
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
  Future<QuestCompletionResult> completeQuest(
    String questId,
    String userId,
  ) async {
    try {
      final questRef = firestore
          .collection(FirebaseConstants.questsCollection)
          .doc(questId);
      return await firestore.runTransaction((transaction) async {
        final questSnapshot = await transaction.get(questRef);
        if (!questSnapshot.exists) {
          throw StateError('Quest not found.');
        }

        final quest = questSnapshot.data()!;
        final ownerId = quest['userId'] as String?;
        if (ownerId == null || ownerId.isEmpty) {
          throw StateError('Quest has no owner.');
        }
        if (ownerId != userId) {
          throw StateError('You do not own this quest.');
        }

        final profileRef = firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(ownerId);
        final activityRef = firestore
            .collection(FirebaseConstants.activitiesCollection)
            .doc('quest_$questId');
        final profileSnapshot = await transaction.get(profileRef);
        final activitySnapshot = await transaction.get(activityRef);

        if (!profileSnapshot.exists) {
          throw StateError('User profile not found.');
        }

        final profile = profileSnapshot.data()!;
        final previousXp = profile['xp'] as int? ?? 0;
        final existingActivity = activitySnapshot.exists;
        final alreadyAwarded =
            quest['xpAwarded'] == true || existingActivity;

        if (alreadyAwarded) {
          return QuestCompletionResult(
            xpAwarded: 0,
            totalXp: previousXp,
          );
        }

        final xp = quest['xp'] as int?;
        if (xp == null || xp <= 0 || xp > 10000) {
          throw StateError('Quest XP reward is invalid.');
        }

        final newXp = previousXp + xp;
        final newLevel = _calculateLevel(newXp);
        final now = FieldValue.serverTimestamp();

        transaction.update(profileRef, {
          'xp': newXp,
          'level': newLevel,
          'lastXpQuestId': questId,
          'updatedAt': now,
        });
        transaction.update(questRef, {
          'isCompleted': true,
          'completedAt': quest['completedAt'] ?? now,
          'updatedAt': now,
          'xpAwarded': true,
        });
        transaction.set(activityRef, {
          'id': 'quest_$questId',
          'questId': questId,
          'userId': ownerId,
          'type': 'quest_complete',
          'description': 'Completed "${quest['title'] ?? 'quest'}"',
          'xpGained': xp,
          'createdAt': now,
        });

        return QuestCompletionResult(xpAwarded: xp, totalXp: newXp);
      });

    } on FirebaseException catch (e) {
      throw ServerException('Quest completion failed: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  int _calculateLevel(int xp) {
    var level = 1;
    while (xp >= level * level * 100) {
      level++;
    }
    return level;
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
