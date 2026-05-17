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
      (failure) => state = AsyncValue.error(
        _friendlyMessage(failure.message),
        StackTrace.current,
      ),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    final result = await _repo.register(email, password, name);
    result.fold(
      (failure) => state = AsyncValue.error(
        _friendlyMessage(failure.message),
        StackTrace.current,
      ),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(null);
  }

  /// Convert Firebase error codes to user-friendly Indonesian messages
  String _friendlyMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
    } else if (error.contains('wrong-password') ||
        error.contains('invalid-credential')) {
      return 'Email atau password salah. Silakan coba lagi.';
    } else if (error.contains('email-already-in-use')) {
      return 'Email sudah terdaftar. Silakan login.';
    } else if (error.contains('weak-password')) {
      return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
    } else if (error.contains('invalid-email')) {
      return 'Format email tidak valid.';
    } else if (error.contains('too-many-requests')) {
      return 'Terlalu banyak percobaan. Coba lagi nanti.';
    } else if (error.contains('network-request-failed')) {
      return 'Koneksi internet bermasalah. Periksa jaringan Anda.';
    }
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});