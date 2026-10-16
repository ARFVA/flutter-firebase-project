import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyquest/data/models/quest_model.dart';

void main() {
  test('parses Firestore timestamps written during quest completion', () {
    final completedAt = DateTime.utc(2026, 10, 16, 6);
    final quest = QuestModel.fromMap({
      'id': 'quest-id',
      'userId': 'user-id',
      'title': 'Study',
      'description': 'Review notes',
      'type': 'checklist',
      'xp': 100,
      'isCompleted': true,
      'createdAt': Timestamp.fromDate(completedAt),
      'updatedAt': Timestamp.fromDate(completedAt),
      'completedAt': Timestamp.fromDate(completedAt),
    });

    expect(quest.createdAt.isAtSameMomentAs(completedAt), isTrue);
    expect(quest.updatedAt.isAtSameMomentAs(completedAt), isTrue);
    expect(quest.completedAt!.isAtSameMomentAs(completedAt), isTrue);
  });
}
