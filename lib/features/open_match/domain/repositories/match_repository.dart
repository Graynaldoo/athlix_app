import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/match_entity.dart';

abstract class MatchRepository {
  Stream<List<MatchEntity>> getOpenMatches();
  Stream<List<MatchEntity>> getMyMatches();
  Future<Either<Failure, void>> createMatch(MatchEntity match);
  Future<Either<Failure, void>> joinMatch(String matchId);
  Future<Either<Failure, void>> leaveMatch(String matchId);
  Future<Either<Failure, void>> deleteMatch(String matchId);
  Future<Either<Failure, void>> updateMatch(String matchId, Map<String, dynamic> data);
}