import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/match_remote_datasource.dart';
import '../../data/repositories/match_repository_impl.dart';
import '../../domain/entities/match_entity.dart';

final matchRepositoryProvider = Provider((ref) {
  return MatchRepositoryImpl(MatchRemoteDatasource());
});

// Stream semua open match
final openMatchesProvider = StreamProvider<List<MatchEntity>>((ref) {
  return ref.watch(matchRepositoryProvider).getOpenMatches();
});

// Stream match milik user
final myMatchesProvider = StreamProvider<List<MatchEntity>>((ref) {
  return ref.watch(matchRepositoryProvider).getMyMatches();
});

// Notifier untuk aksi CRUD
class MatchNotifier extends StateNotifier<AsyncValue<void>> {
  final MatchRepositoryImpl _repo;
  MatchNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> createMatch(MatchEntity match) async {
    state = const AsyncValue.loading();
    final result = await _repo.createMatch(match);
    result.fold(
          (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
          (_) => state = const AsyncValue.data(null),
    );
  }

  Future<void> joinMatch(String matchId) async {
    state = const AsyncValue.loading();
    final result = await _repo.joinMatch(matchId);
    result.fold(
          (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
          (_) => state = const AsyncValue.data(null),
    );
  }

  Future<void> leaveMatch(String matchId) async {
    final result = await _repo.leaveMatch(matchId);
    result.fold(
          (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
          (_) => state = const AsyncValue.data(null),
    );
  }

  Future<void> deleteMatch(String matchId) async {
    final result = await _repo.deleteMatch(matchId);
    result.fold(
          (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
          (_) => state = const AsyncValue.data(null),
    );
  }
}

final matchNotifierProvider =
StateNotifierProvider<MatchNotifier, AsyncValue<void>>((ref) {
  return MatchNotifier(ref.watch(matchRepositoryProvider));
});