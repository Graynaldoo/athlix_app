import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepositoryImpl(AuthRemoteDatasource());
});

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final AuthRepositoryImpl _repo;
  AuthNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _repo.login(email, password);
    result.fold(
          (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
          (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    final result = await _repo.register(email, password, name);
    result.fold(
          (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
          (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider =
StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});