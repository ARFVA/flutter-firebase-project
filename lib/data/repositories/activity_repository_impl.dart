import 'package:studyquest/core/errors/failures.dart';
import 'package:studyquest/core/errors/exceptions.dart';
import 'package:studyquest/data/datasources/activity_datasource.dart';
import 'package:studyquest/data/models/activity_model.dart';
import 'package:dartz/dartz.dart';

abstract class ActivityRepository {
  Future<Either<Failure, String>> createActivity(ActivityModel activity);
  Future<Either<Failure, List<ActivityModel>>> getUserActivities(String userId);
  Future<Either<Failure, List<ActivityModel>>> getTodayActivities(String userId);
  Future<Either<Failure, int>> getTodayXp(String userId);
}

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSource remoteDataSource;

  ActivityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> createActivity(ActivityModel activity) async {
    try {
      final activityId = await remoteDataSource.createActivity(activity);
      return Right(activityId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityModel>>> getUserActivities(String userId) async {
    try {
      final activities = await remoteDataSource.getUserActivities(userId);
      return Right(activities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityModel>>> getTodayActivities(String userId) async {
    try {
      final activities = await remoteDataSource.getTodayActivities(userId);
      return Right(activities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTodayXp(String userId) async {
    try {
      final xp = await remoteDataSource.getTodayXp(userId);
      return Right(xp);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
