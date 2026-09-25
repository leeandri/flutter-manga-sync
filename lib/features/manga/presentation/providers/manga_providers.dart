import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/network/auth_interceptor.dart';
import 'package:flutter_manga_sync/core/storage/secure_storage_service.dart';
import 'package:flutter_manga_sync/features/manga/data/models/manga_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_manga_sync/core/constants/api_constants.dart';
import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/features/manga/data/datasources/manga_local_datasource.dart';
import 'package:flutter_manga_sync/features/manga/data/repositories/manga_repository_impl.dart';

import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';

import 'package:flutter_manga_sync/features/manga/domain/repositories/manga_repository.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(const FlutterSecureStorage());
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final secureStorage = ref.watch(secureStorageServiceProvider);
  dio.interceptors.add(AuthInterceptor(secureStorage));
  return dio;
});

final mangaLocalDataSourceProvider = Provider<MangaLocalDataSource>((ref) {
  return MangaLocalDataSourceImpl();
});

final mangaRepositoryProvider = Provider<MangaRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final localDataSource = ref.watch(mangaLocalDataSourceProvider);

  return MangaRepositoryImpl(dio, localDataSource);
});

final mangaListProvider = FutureProvider<List<Manga>>((ref) async {
  final repository = ref.watch(mangaRepositoryProvider);
  final result = await repository.getMangaList();

  return switch (result) {
    Success(:final data) => data,
    Error(:final failure) => throw Exception(failure.message),
  };
});

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Manga>>(
  (ref) {
    final localDataSource = ref.watch(mangaLocalDataSourceProvider);
    return FavoritesNotifier(localDataSource);
  },
);

class FavoritesNotifier extends StateNotifier<List<Manga>> {
  final MangaLocalDataSource _localDataSource;

  FavoritesNotifier(this._localDataSource) : super([]) {
    loadFavorites();
  }

  void loadFavorites() {
    final favJson = _localDataSource.getFavorites();
    state = favJson.map((json) => MangaModel.fromJson(json)).toList();
  }

  Future<void> toggleFavorite(Manga manga, Map<String, dynamic> rawJson) async {
    if (_localDataSource.isFavorite(manga.id)) {
      await _localDataSource.removeFavorite(manga.id);
    } else {
      await _localDataSource.saveFavorite(rawJson);
    }
    loadFavorites();
  }

  bool isFav(String mangaId) {
    return _localDataSource.isFavorite(mangaId);
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>((ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  return AuthStateNotifier(storage);
});

class AuthStateNotifier extends StateNotifier<bool> {
  final SecureStorageService _storage;

  AuthStateNotifier(this._storage) : super(false) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final token = await _storage.getToken();
    state = token != null && token.isNotEmpty;
  }

  Future<void> login(String token) async {
    await _storage.saveToken(token);
    state = true;
  }

  Future<void> logout() async {
    await _storage.deleteToken();
    state = false;
  }
}
