import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/network/auth_interceptor.dart';
import 'package:flutter_manga_sync/core/storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_manga_sync/core/constants/api_constants.dart';
import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/features/manga/data/datasources/manga_local_datasource.dart';
import 'package:flutter_manga_sync/features/manga/data/repositories/manga_repository_impl.dart';

import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';
import 'package:flutter_manga_sync/features/manga/domain/repositories/manga_repository.dart';
import 'package:flutter_manga_sync/features/manga/domain/usecases/get_manga_list.dart';

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

final getMangaListUseCaseProvider = Provider<GetMangaListUseCase>((ref) {
  final repository = ref.watch(mangaRepositoryProvider);
  return GetMangaListUseCase(repository);
});

final mangaListProvider = FutureProvider<List<Manga>>((ref) async {
  final getMangaListUseCase = ref.watch(getMangaListUseCaseProvider);
  final Result<List<Manga>> result = await getMangaListUseCase();

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
    final rawList = _localDataSource.getFavorites();

    final mangaList = rawList
        .map((e) {
          if (e is Map) {
            final Map<String, dynamic> safeMap = Map<String, dynamic>.from(
              e.map((k, v) => MapEntry(k.toString(), v)),
            );
            return Manga.fromKitsuJson(safeMap);
          }
          return null;
        })
        .whereType<Manga>()
        .toList();

    state = mangaList;
  }

  Future<void> toggleFavorite(Manga manga, Map<String, dynamic> rawJson) async {
    final isFav = _localDataSource.isFavorite(manga.id);
    if (isFav) {
      await _localDataSource.removeFavorite(manga.id);
    } else {
      await _localDataSource.saveFavorite(rawJson);
    }
    loadFavorites();
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

final mangaSearchProvider = FutureProvider.family<List<Manga>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) return [];
  final repo = ref.watch(mangaRepositoryProvider);
  final result = await repo.searchManga(query);

  if (result is Success<List<Manga>>) {
    return result.data;
  } else if (result is Error<List<Manga>>) {
    throw Exception(result.failure.message);
  }
  return [];
});
