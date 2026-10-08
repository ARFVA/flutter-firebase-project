import 'package:studyquest/core/errors/failures.dart';
import 'package:studyquest/core/errors/exceptions.dart';
import 'package:studyquest/data/datasources/storage_datasource.dart';
import 'package:dartz/dartz.dart';

abstract class StorageRepository {
  Future<Either<Failure, String>> uploadFile(String path, dynamic file);
  Future<Either<Failure, String>> getDownloadUrl(String path);
  Future<Either<Failure, void>> deleteFile(String path);
}

class StorageRepositoryImpl implements StorageRepository {
  final StorageRemoteDataSource remoteDataSource;

  StorageRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> uploadFile(String path, dynamic file) async {
    try {
      final filePath = await remoteDataSource.uploadFile(path, file);
      return Right(filePath);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getDownloadUrl(String path) async {
    try {
      final url = await remoteDataSource.getDownloadUrl(path);
      return Right(url);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFile(String path) async {
    try {
      await remoteDataSource.deleteFile(path);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
