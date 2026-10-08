class UserProfileModel {
  final String uid;
  final String displayName;
  final String email;
  final String? photoURL;
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
  }) {
    final now = DateTime.now();
    return UserProfileModel(
      uid: uid,
      displayName: displayName,
      email: email,
      photoURL: photoURL,
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
      'level': level,
      'xp': xp,
      'dailyTargetXp': dailyTargetXp,
      'streak': streak,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      photoURL: map['photoURL'],
      level: map['level'] ?? 1,
      xp: map['xp'] ?? 0,
      dailyTargetXp: map['dailyTargetXp'] ?? 500,
      streak: map['streak'] ?? 0,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  UserProfileModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoURL,
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
      level: level ?? this.level,
      xp: xp ?? this.xp,
      dailyTargetXp: dailyTargetXp ?? this.dailyTargetXp,
      streak: streak ?? this.streak,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
