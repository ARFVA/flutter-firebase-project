import 'package:studyquest/core/errors/failures.dart';
import 'package:studyquest/core/errors/exceptions.dart';
import 'package:studyquest/data/datasources/realtime_db_datasource.dart';
import 'package:studyquest/data/models/room_model.dart';
import 'package:dartz/dartz.dart';

abstract class RoomRepository {
  Future<Either<Failure, String>> createRoom(RoomModel room);
  Future<Either<Failure, void>> joinRoom(String roomId, String userId, ParticipantModel participant);
  Future<Either<Failure, void>> leaveRoom(String roomId, String userId);
  Future<Either<Failure, void>> updateStatus(String roomId, String userId, String status);
  Stream<Map<String, ParticipantModel>> getParticipants(String roomId);
  Future<Either<Failure, void>> deleteRoom(String roomId);
}

class RoomRepositoryImpl implements RoomRepository {
  final RealtimeDBRemoteDataSource remoteDataSource;

  RoomRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> createRoom(RoomModel room) async {
    try {
      final roomId = await remoteDataSource.createRoom(room);
      return Right(roomId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinRoom(String roomId, String userId, ParticipantModel participant) async {
    try {
      await remoteDataSource.joinRoom(roomId, userId, participant);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveRoom(String roomId, String userId) async {
    try {
      await remoteDataSource.leaveRoom(roomId, userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateStatus(String roomId, String userId, String status) async {
    try {
      await remoteDataSource.updateStatus(roomId, userId, status);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Map<String, ParticipantModel>> getParticipants(String roomId) {
    return remoteDataSource.getParticipants(roomId);
  }

  @override
  Future<Either<Failure, void>> deleteRoom(String roomId) async {
    try {
      await remoteDataSource.deleteRoom(roomId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
