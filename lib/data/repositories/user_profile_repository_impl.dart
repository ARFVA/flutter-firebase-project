import 'package:studyquest/core/errors/failures.dart';
import 'package:studyquest/core/errors/exceptions.dart';
import 'package:studyquest/data/datasources/firestore_datasource.dart';
import 'package:studyquest/data/models/user_profile_model.dart';
import 'package:dartz/dartz.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, void>> createUserProfile(UserProfileModel profile);
  Future<Either<Failure, UserProfileModel?>> getUserProfile(String uid);
  Stream<UserProfileModel?> watchUserProfile(String uid);
  Future<Either<Failure, void>> updateUserProfile(UserProfileModel profile);
  Future<Either<Failure, void>> deleteUserProfile(String uid);
}

class UserProfileRepositoryImpl implements UserProfileRepository {
  final FirestoreRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> createUserProfile(UserProfileModel profile) async {
    try {
      await remoteDataSource.createUserProfile(profile);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileModel?>> getUserProfile(String uid) async {
    try {
      final profile = await remoteDataSource.getUserProfile(uid);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<UserProfileModel?> watchUserProfile(String uid) {
    return remoteDataSource.watchUserProfile(uid);
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(UserProfileModel profile) async {
    try {
      await remoteDataSource.updateUserProfile(profile);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserProfile(String uid) async {
    try {
      await remoteDataSource.deleteUserProfile(uid);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
