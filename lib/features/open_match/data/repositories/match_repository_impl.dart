import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/match_remote_datasource.dart';
import '../models/match_model.dart';

class MatchRepositoryImpl implements MatchRepository {
  final MatchRemoteDatasource _datasource;
  MatchRepositoryImpl(this._datasource);

  @override
  Stream<List<MatchEntity>> getOpenMatches() {
    return _datasource.getOpenMatches();
  }

  @override
  Stream<List<MatchEntity>> getMyMatches() {
    return _datasource.getMyMatches();
  }

  @override
  Future<Either<Failure, void>> createMatch(MatchEntity match) async {
    try {
      final model = MatchModel(
        id: match.id,
        hostId: match.hostId,
        hostName: match.hostName,
        hostReliabilityScore: match.hostReliabilityScore,
        sportType: match.sportType,
        skillLevel: match.skillLevel,
        location: match.location,
        matchDate: match.matchDate,
        timeSlot: match.timeSlot,
        maxPlayers: match.maxPlayers,
        joinedPlayerIds: match.joinedPlayerIds,
        status: match.status,
        notes: match.notes,
        createdAt: match.createdAt,
      );
      await _datasource.createMatch(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinMatch(String matchId) async {
    try {
      await _datasource.joinMatch(matchId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveMatch(String matchId) async {
    try {
      await _datasource.leaveMatch(matchId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMatch(String matchId) async {
    try {
      await _datasource.deleteMatch(matchId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateMatch(
      String matchId, Map<String, dynamic> data) async {
    try {
      await _datasource.updateMatch(matchId, data);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}