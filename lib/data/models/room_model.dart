class RoomModel {
  final String roomId;
  final String roomName;
  final String createdBy;
  final DateTime createdAt;

  RoomModel({
    required this.roomId,
    required this.roomName,
    required this.createdBy,
    required this.createdAt,
  });

  factory RoomModel.create({
    required String roomId,
    required String roomName,
    required String createdBy,
  }) {
    return RoomModel(
      roomId: roomId,
      roomName: roomName,
      createdBy: createdBy,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomId: map['roomId'] ?? '',
      roomName: map['roomName'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class ParticipantModel {
  final String userId;
  final String displayName;
  final String status; // 'studying', 'break', 'offline'
  final DateTime lastSeen;

  ParticipantModel({
    required this.userId,
    required this.displayName,
    required this.status,
    required this.lastSeen,
  });

  factory ParticipantModel.create({
    required String userId,
    required String displayName,
    String status = 'studying',
  }) {
    return ParticipantModel(
      userId: userId,
      displayName: displayName,
      status: status,
      lastSeen: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'displayName': displayName,
      'status': status,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }

  factory ParticipantModel.fromMap(Map<String, dynamic> map) {
    return ParticipantModel(
      userId: map['userId'] ?? '',
      displayName: map['displayName'] ?? '',
      status: map['status'] ?? 'offline',
      lastSeen: DateTime.parse(map['lastSeen'] ?? DateTime.now().toIso8601String()),
    );
  }

  ParticipantModel copyWith({
    String? userId,
    String? displayName,
    String? status,
    DateTime? lastSeen,
  }) {
    return ParticipantModel(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
