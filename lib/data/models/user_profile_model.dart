class UserProfileModel {
  final String uid;
  final String displayName;
  final String email;
  final String? photoURL;
  final String? phoneNumber;
  final int level;
  final int xp;
  final int dailyTargetXp;
  final int streak;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfileModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoURL,
    this.phoneNumber,
    this.level = 1,
    this.xp = 0,
    this.dailyTargetXp = 500,
    this.streak = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.create({
    required String uid,
    required String displayName,
    required String email,
    String? photoURL,
    String? phoneNumber,
  }) {
    final now = DateTime.now();
    return UserProfileModel(
      uid: uid,
      displayName: displayName,
      email: email,
      photoURL: photoURL,
      phoneNumber: phoneNumber,
      level: 1,
      xp: 0,
      dailyTargetXp: 500,
      streak: 0,
      createdAt: now,
      updatedAt: now,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'level': level,
      'xp': xp,
      'dailyTargetXp': dailyTargetXp,
      'streak': streak,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
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

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      photoURL: map['photoURL'],
      phoneNumber: map['phoneNumber'],
      level: map['level'] ?? 1,
      xp: map['xp'] ?? 0,
      dailyTargetXp: map['dailyTargetXp'] ?? 500,
      streak: map['streak'] ?? 0,
      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  UserProfileModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoURL,
    String? phoneNumber,
    int? level,
    int? xp,
    int? dailyTargetXp,
    int? streak,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      dailyTargetXp: dailyTargetXp ?? this.dailyTargetXp,
      streak: streak ?? this.streak,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
