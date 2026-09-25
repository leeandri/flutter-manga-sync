import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/features/manga/data/datasources/manga_local_datasource.dart';
import 'package:flutter_manga_sync/features/manga/data/repositories/manga_repository_impl.dart';

class MockDio extends Mock implements Dio {}

class MockMangaLocalDataSource extends Mock implements MangaLocalDataSource {}

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
    final mockApiResponse = {
      'data': [
        {
          'id': '1',
          'attributes': {
            'canonicalTitle': 'One Piece',
            'synopsis': 'Pirates adventure',
            'posterImage': {'small': 'https://example.com/onepiece.jpg'},
          },
        },
      ],
    };

    test('should return list of mangas when API call is successful', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: mockApiResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      when(() => mockLocalDataSource.cacheMangas(any()))
          .thenAnswer((_) async {});

      final result = await repository.getMangaList();

      expect(result, isA<Success>());
      verify(() => mockLocalDataSource.cacheMangas(any())).called(1);
    });

    test(
      'should return cached mangas when API fails but Hive cache is available',
      () async {
        when(() => mockDio.get(any()))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '')));
        when(() => mockLocalDataSource.getCachedMangas()).thenReturn([
          {
            'id': '1',
            'attributes': {
              'canonicalTitle': 'One Piece Cached',
              'synopsis': 'Cached synopsis',
              'posterImage': {'small': ''},
            },
          },
        ]);

        final result = await repository.getMangaList();

        expect(result, isA<Success>());
        verify(() => mockLocalDataSource.getCachedMangas()).called(1);
      },
    );

    test(
      'should return ServerFailure when both API and Hive cache fail',
      () async {
        when(() => mockDio.get(any()))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '')));
        when(() => mockLocalDataSource.getCachedMangas()).thenReturn([]);

        final result = await repository.getMangaList();

        expect(result, isA<Error>());
      },
    );
  });
}
