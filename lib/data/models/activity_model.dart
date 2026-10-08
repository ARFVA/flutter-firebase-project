class ActivityModel {
  final String id;
  final String userId;
  final String type; // 'quest_complete', 'level_up', 'streak_increase'
  final String description;
  final int xpGained;
  final DateTime createdAt;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    required this.xpGained,
    required this.createdAt,
  });

  factory ActivityModel.create({
    required String id,
    required String userId,
    required String type,
    required String description,
    required int xpGained,
  }) {
    return ActivityModel(
      id: id,
      userId: userId,
      type: type,
      description: description,
      xpGained: xpGained,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'description': description,
      'xpGained': xpGained,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      xpGained: map['xpGained'] ?? 0,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
