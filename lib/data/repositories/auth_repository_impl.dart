import 'package:studyquest/core/errors/failures.dart';
import 'package:studyquest/core/errors/exceptions.dart';
import 'package:studyquest/data/datasources/auth_datasource.dart';
import 'package:studyquest/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'dart:async';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> registerWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  Future<Either<Failure, String>> sendOtp(String phoneNumber);

  Future<Either<Failure, UserModel>> verifyOtp(String verificationId, String otp);

  Stream<UserModel?> authStateChanges();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserModel>> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.registerWithEmailPassword(
        email: email,
        password: password,
      );
      return Right(UserModel.fromFirebaseUser(user));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      return Right(UserModel.fromFirebaseUser(user));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return remoteDataSource.authStateChanges().map((user) {
      if (user != null) {
        return UserModel.fromFirebaseUser(user);
      }
      return null;
    });
  }

  @override
  Future<Either<Failure, String>> sendOtp(String phoneNumber) async {
    try {
      final completer = Completer<String>();
      
      await remoteDataSource.sendOtp(phoneNumber, (verificationId) {
        completer.complete(verificationId);
      });
      
      return Right(await completer.future);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> verifyOtp(String verificationId, String otp) async {
    try {
      final user = await remoteDataSource.verifyOtp(verificationId, otp);
      return Right(UserModel.fromFirebaseUser(user));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
