import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_manga_sync/core/constants/api_constants.dart';
import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/features/manga/data/repositories/manga_repository_impl.dart';
import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';
import 'package:flutter_manga_sync/features/manga/domain/repositories/manga_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

final mangaRepositoryProvider = Provider<MangaRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MangaRepositoryImpl(dio);
});

final mangaListProvider = FutureProvider<List<Manga>>((ref) async {
  final repository = ref.watch(mangaRepositoryProvider);
  final result = await repository.getMangaList();

  return switch (result) {
    Success(:final data) => data,
    Error(:final failure) => throw Exception(failure.message),
  };
});
