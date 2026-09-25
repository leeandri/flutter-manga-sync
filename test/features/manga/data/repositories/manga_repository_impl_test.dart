import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/features/manga/data/datasources/manga_local_datasource.dart';
import 'package:flutter_manga_sync/features/manga/data/repositories/manga_repository_impl.dart';
import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'manga_repository_impl_test.mocks.dart';

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

  group('MangaRepositoryImpl Unit Tests', () {
    test('getMangaList returns Success on HTTP 200', () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'data': [
              {
                'id': '1',
                'attributes': {
                  'canonicalTitle': 'Naruto',
                  'synopsis': 'A ninja story',
                  'posterImage': {'small': 'url'},
                },
              },
            ],
          },
        ),
      );

      final result = await repository.getMangaList();

      expect(result, isA<Success<List<Manga>>>());
      if (result is Success<List<Manga>>) {
        expect(result.data.length, equals(1));
      } else {
        fail('Expected Success but got $result');
      }
    });

    test('getMangaList falls back to local cache when network fails', () async {
      when(mockDio.get(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );

      when(mockLocalDataSource.getCachedMangas()).thenReturn([
        {
          'id': '1',
          'attributes': {
            'canonicalTitle': 'Naruto Cached',
            'synopsis': 'Cached synopsis',
            'posterImage': {'small': 'cached_url'},
          },
        },
      ]);

      final result = await repository.getMangaList();

      expect(result, isA<Success<List<Manga>>>());
      if (result is Success<List<Manga>>) {
        expect(result.data.first.title, equals('Naruto Cached'));
      } else {
        fail('Expected Success but got $result');
      }
      verify(mockLocalDataSource.getCachedMangas()).called(1);
    });
  });
}
