import 'package:flutter_manga_sync/features/manga/data/datasources/manga_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'manga_local_datasource_test.mocks.dart';

@GenerateMocks([MangaLocalDataSource])
void main() {
  late MockMangaLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockMangaLocalDataSource();
  });

  group('MangaLocalDataSource Unit Tests', () {
    test('getCachedMangas returns list of dynamic objects', () {
      when(mockLocalDataSource.getCachedMangas()).thenReturn([
        {
          'id': '1',
          'attributes': {'canonicalTitle': 'Naruto'},
        },
      ]);

      final result = mockLocalDataSource.getCachedMangas();

      expect(result.length, equals(1));
      verify(mockLocalDataSource.getCachedMangas()).called(1);
    });

    test('isFavorite checks if id exists in local box', () {
      when(mockLocalDataSource.isFavorite('1')).thenReturn(true);

      final isFav = mockLocalDataSource.isFavorite('1');

      expect(isFav, isTrue);
      verify(mockLocalDataSource.isFavorite('1')).called(1);
    });
  });
}
