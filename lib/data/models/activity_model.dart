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

  /// Parses date values that may be ISO-8601 [String] (client writes) or a
  /// Firestore [Timestamp] (server/Cloud Functions writes).
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return DateTime.now();
    }
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      xpGained: map['xpGained'] ?? 0,
      createdAt: _parseDate(map['createdAt']),
    );
  }
}
