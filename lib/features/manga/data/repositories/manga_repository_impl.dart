import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/constants/api_constants.dart';
import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/features/manga/data/datasources/manga_local_datasource.dart';
import 'package:flutter_manga_sync/features/manga/data/models/manga_model.dart';
import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';
import 'package:flutter_manga_sync/features/manga/domain/repositories/manga_repository.dart';

class MangaRepositoryImpl implements MangaRepository {
  final Dio _dio;
  final MangaLocalDataSource _localDataSource;

  MangaRepositoryImpl(this._dio, this._localDataSource);

  @override
  Future<Result<List<Manga>>> getMangaList() async {
    try {
      // 1. Tenter la requête réseau (API Kitsu)
      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.mangaListEndpoint}',
      );

      final List dataList = response.data['data'] as List;

      // 2. Sauvegarder dans Hive en tâche de fond (Cache)
      final rawList = List<Map<String, dynamic>>.from(dataList);
      await _localDataSource.cacheMangas(rawList);

      // 3. Convertir et retourner les données fraîches
      final mangas = dataList
          .map((json) => MangaModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Success(mangas);
    } catch (e) {
      // 4. Fallback Mode Hors-ligne : Si le réseau échoue, lire le cache local
      final cachedJsonList = _localDataSource.getCachedMangas();

      if (cachedJsonList.isNotEmpty) {
        final cachedMangas = cachedJsonList
            .map((json) => MangaModel.fromJson(json))
            .toList();
        return Success(cachedMangas);
      }

      // 5. Si pas de réseau ET pas de cache : renvoyer l'erreur
      return Error(
        ServerFailure('Failed to fetch manga list: ${e.toString()}'),
      );
    }
  }
}
