import 'package:studyquest/core/errors/failures.dart';
import 'package:studyquest/core/errors/exceptions.dart';
import 'package:studyquest/data/datasources/quest_datasource.dart';
import 'package:studyquest/data/models/quest_model.dart';
import 'package:dartz/dartz.dart';

abstract class QuestRepository {
  Future<Either<Failure, String>> createQuest(QuestModel quest);
  Future<Either<Failure, List<QuestModel>>> getUserQuests(String userId);
  Future<Either<Failure, QuestModel?>> getQuest(String questId);
  Future<Either<Failure, void>> updateQuest(QuestModel quest);
  Future<Either<Failure, void>> deleteQuest(String questId);
  Future<Either<Failure, void>> completeQuest(String questId);
  Future<Either<Failure, List<QuestModel>>> getActiveQuests(String userId);
  Future<Either<Failure, List<QuestModel>>> getCompletedQuests(String userId);
}

class QuestRepositoryImpl implements QuestRepository {
  final QuestRemoteDataSource remoteDataSource;

  QuestRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> createQuest(QuestModel quest) async {
    try {
      final questId = await remoteDataSource.createQuest(quest);
      return Right(questId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QuestModel>>> getUserQuests(String userId) async {
    try {
      final quests = await remoteDataSource.getUserQuests(userId);
      return Right(quests);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuestModel?>> getQuest(String questId) async {
    try {
      final quest = await remoteDataSource.getQuest(questId);
      return Right(quest);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuest(QuestModel quest) async {
    try {
      await remoteDataSource.updateQuest(quest);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuest(String questId) async {
    try {
      await remoteDataSource.deleteQuest(questId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeQuest(String questId) async {
    try {
      await remoteDataSource.completeQuest(questId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QuestModel>>> getActiveQuests(String userId) async {
    try {
      final quests = await remoteDataSource.getActiveQuests(userId);
      return Right(quests);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QuestModel>>> getCompletedQuests(String userId) async {
    try {
      final quests = await remoteDataSource.getCompletedQuests(userId);
      return Right(quests);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
