import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/features/manga/data/datasources/manga_local_datasource.dart';
import 'package:flutter_manga_sync/features/manga/data/repositories/manga_repository_impl.dart';
import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'manga_repository_test.mocks.dart';

@GenerateMocks([Dio, MangaLocalDataSource])
void main() {
  late MangaRepositoryImpl repository;
  late MockDio mockDio;
  late MockMangaLocalDataSource mockLocalDataSource;

  setUp(() {
    mockDio = MockDio();
    mockLocalDataSource = MockMangaLocalDataSource();
    repository = MangaRepositoryImpl(mockDio, mockLocalDataSource);
  });

  group('getMangaList', () {
    final tMangaListJson = [
      {
        'id': '1',
        'attributes': {
          'canonicalTitle': 'One Piece',
          'synopsis': 'Pirates adventure',
          'posterImage': {'small': 'https://example.com/onepiece.jpg'},
        },
      },
    ];

    test(
      'should return remote manga list when API call is successful',
      () async {
        when(mockDio.get(any)).thenAnswer(
          (_) async => Response(
            data: {'data': tMangaListJson},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/manga'),
          ),
        );

        final result = await repository.getMangaList();

        expect(result, isA<Success<List<Manga>>>());
        final data = (result as Success<List<Manga>>).data;
        expect(data.length, 1);
        expect(data.first.id, '1');
        expect(data.first.title, 'One Piece');
        verify(mockLocalDataSource.cacheMangas(any)).called(1);
      },
    );

    test('should return cached manga when network request fails', () async {
      when(mockDio.get(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/manga'),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      when(mockLocalDataSource.getCachedMangas()).thenReturn(tMangaListJson);

      final result = await repository.getMangaList();

      expect(result, isA<Success<List<Manga>>>());
      final data = (result as Success<List<Manga>>).data;
      expect(data.length, 1);
      expect(data.first.title, 'One Piece');
      verify(mockLocalDataSource.getCachedMangas()).called(1);
    });

    test(
      'should return ServerFailure when API fails and cache is empty',
      () async {
        when(mockDio.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/manga'),
            type: DioExceptionType.badResponse,
          ),
        );
        when(mockLocalDataSource.getCachedMangas()).thenReturn([]);

        final result = await repository.getMangaList();

        expect(result, isA<Error<List<Manga>>>());
        final failure = (result as Error<List<Manga>>).failure;
        expect(failure, isA<ServerFailure>());
      },
    );
  });
}
