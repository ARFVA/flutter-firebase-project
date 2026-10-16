class QuestModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String type; // 'checklist' or 'timer'
  final int xp;
  final int? durationMinutes; // Required for timer quests
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  QuestModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.xp,
    this.durationMinutes,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  factory QuestModel.create({
    required String id,
    required String userId,
    required String title,
    required String description,
    required String type,
    required int xp,
    int? durationMinutes,
  }) {
    final now = DateTime.now();
    return QuestModel(
      id: id,
      userId: userId,
      title: title,
      description: description,
      type: type,
      xp: xp,
      durationMinutes: durationMinutes,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
      completedAt: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'type': type,
      'xp': xp,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

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

  factory QuestModel.fromMap(Map<String, dynamic> map) {
    return QuestModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? 'checklist',
      xp: map['xp'] ?? 0,
      durationMinutes: map['durationMinutes'],
      isCompleted: map['isCompleted'] ?? false,
      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
      completedAt: map['completedAt'] != null
          ? _parseDate(map['completedAt'])
          : null,
    );
  }

  QuestModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? type,
    int? xp,
    int? durationMinutes,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return QuestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      xp: xp ?? this.xp,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
