import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/features/manga/data/datasources/manga_local_datasource.dart';
import 'package:flutter_manga_sync/features/manga/data/repositories/manga_repository_impl.dart';
import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../manga_repository_test.mocks.dart';

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

  group('MangaRepositoryImpl Tests', () {
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
      '1. getMangaList returns remote manga list when API call succeeds',
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

    test('2. getMangaList falls back to cached data when network fails (Offline mode)', () async {
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

    test('3. searchManga returns NetworkFailure when query request fails without network', () async {
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/manga'),
              type: DioExceptionType.connectionError,
            ),
          );

      final result = await repository.searchManga('naruto');

      expect(result, isA<Error<List<Manga>>>());
      final failure = (result as Error<List<Manga>>).failure;
      expect(failure, isA<NetworkFailure>());
    });
  });
}
