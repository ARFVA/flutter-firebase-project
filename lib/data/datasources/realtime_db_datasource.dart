import 'package:firebase_database/firebase_database.dart';
import 'package:studyquest/core/errors/exceptions.dart';
import 'package:studyquest/data/models/room_model.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class RealtimeDBRemoteDataSource {
  Future<String> createRoom(RoomModel room);
  Future<void> joinRoom(String roomId, String userId, ParticipantModel participant);
  Future<void> leaveRoom(String roomId, String userId);
  Future<void> updateStatus(String roomId, String userId, String status);
  Stream<Map<String, ParticipantModel>> getParticipants(String roomId);
  Future<void> deleteRoom(String roomId);
}

class RealtimeDBRemoteDataSourceImpl implements RealtimeDBRemoteDataSource {
  final FirebaseDatabase database;

  RealtimeDBRemoteDataSourceImpl(this.database);

  @override
  Future<String> createRoom(RoomModel room) async {
    try {
      final roomRef = database.ref('rooms/${room.roomId}');
      await roomRef.set(room.toMap());
      return room.roomId;
    } on FirebaseException catch (e) {
      throw ServerException('Realtime DB error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> joinRoom(String roomId, String userId, ParticipantModel participant) async {
    try {
      final participantRef = database.ref('rooms/$roomId/participants/$userId');
      await participantRef.set({
        ...participant.toMap(),
        'online': true,
      });

      // Presence: when this client disconnects (crash, network loss, kill),
      // the server marks the participant offline instead of leaving them
      // appearing active forever.
      await participantRef.onDisconnect().update({
        'online': false,
        'status': 'offline',
        'lastSeen': ServerValue.timestamp,
      });
    } on FirebaseException catch (e) {
      throw ServerException('Realtime DB error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> leaveRoom(String roomId, String userId) async {
    try {
      final participantRef = database.ref('rooms/$roomId/participants/$userId');
      // Cancel the pending onDisconnect handler before explicit removal.
      await participantRef.onDisconnect().cancel();
      await participantRef.remove();
    } on FirebaseException catch (e) {
      throw ServerException('Realtime DB error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateStatus(String roomId, String userId, String status) async {
    try {
      final participantRef = database.ref('rooms/$roomId/participants/$userId');
      await participantRef.update({
        'status': status,
        'lastSeen': ServerValue.timestamp,
      });
    } on FirebaseException catch (e) {
      throw ServerException('Realtime DB error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<Map<String, ParticipantModel>> getParticipants(String roomId) {
    try {
      final participantsRef = database.ref('rooms/$roomId/participants');
      
      return participantsRef.onValue.map((event) {
        final Map<String, ParticipantModel> participants = {};
        
        if (event.snapshot.value != null) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          data.forEach((key, value) {
            if (value is Map) {
              participants[key] = ParticipantModel.fromMap(Map<String, dynamic>.from(value));
            }
          });
        }
        
        return participants;
      }). handleError((error) {
        throw ServerException(error.toString());
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteRoom(String roomId) async {
    try {
      final roomRef = database.ref('rooms/$roomId');
      await roomRef.remove();
    } on FirebaseException catch (e) {
      throw ServerException('Realtime DB error: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
