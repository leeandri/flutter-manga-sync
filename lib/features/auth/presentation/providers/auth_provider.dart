import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_manga_sync/core/network/dio_client.dart';
import 'package:flutter_manga_sync/core/storage/secure_storage_service.dart';
import 'package:flutter_manga_sync/features/auth/data/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(const FlutterSecureStorage());
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(dio, storage);
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(authRepositoryProvider);
      return AuthNotifier(repository);
    });

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.login(email, password));
  }

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.register(email, password));
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.logout());
  }
}
