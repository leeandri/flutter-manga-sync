import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/constants/api_constants.dart';
import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/features/manga/data/models/manga_model.dart';
import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';
import 'package:flutter_manga_sync/features/manga/domain/repositories/manga_repository.dart';

class MangaRepositoryImpl implements MangaRepository {
  final Dio _dio;

  MangaRepositoryImpl(this._dio);

  @override
  Future<Result<List<Manga>>> getMangaList() async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.mangaListEndpoint}',
      );

      final List dataList = response.data['data'] as List;
      final mangas = dataList
          .map((json) => MangaModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Success(mangas);
    } catch (e) {
      return Error(
        ServerFailure('Failed to fetch manga list: ${e.toString()}'),
      );
    }
  }
}
