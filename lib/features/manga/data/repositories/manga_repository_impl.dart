import 'package:dio/dio.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/manga.dart';
import '../../domain/repositories/manga_repository.dart';
import '../datasources/manga_local_datasource.dart';

class MangaRepositoryImpl implements MangaRepository {
  final Dio dio;
  final MangaLocalDataSource localDataSource;

  MangaRepositoryImpl(this.dio, this.localDataSource);

  @override
  Future<Result<List<Manga>>> getMangaList() async {
    try {
      final response = await dio.get('https://kitsu.io/api/edge/manga');
      final dataList = response.data['data'] as List;

      await localDataSource.cacheMangas(dataList);

      final mangas = dataList
          .map((e) => Manga.fromKitsuJson(e as Map<String, dynamic>))
          .toList();
      return Success(mangas);
    } on DioException {
      final cached = localDataSource.getCachedMangas();
      if (cached.isNotEmpty) {
        final mangas = cached
            .map((e) => Manga.fromKitsuJson(e as Map<String, dynamic>))
            .toList();
        return Success(mangas);
      }
      return const Error(ServerFailure('Impossible de charger les données.'));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Manga>>> searchManga(String query) async {
    try {
      final response = await dio.get(
        'https://kitsu.io/api/edge/manga',
        queryParameters: {'filter[text]': query},
      );
      final dataList = response.data['data'] as List;
      final mangas = dataList
          .map((e) => Manga.fromKitsuJson(e as Map<String, dynamic>))
          .toList();
      return Success(mangas);
    } on DioException {
      return const Error(
        NetworkFailure('Connexion indisponible pour la recherche.'),
      );
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
