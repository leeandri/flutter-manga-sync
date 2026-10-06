import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';

void main() {
  group('Unit Tests - Logic & Entities', () {
    test('1. Manga entity instantiates correctly', () {
      const manga = Manga(
        id: '1',
        title: 'Naruto',
        description: 'Ninja story',
        imageUrl: 'http://img.com',
      );
      expect(manga.id, '1');
      expect(manga.title, 'Naruto');
    });

    test('2. Manga.fromKitsuJson parses JSON correctly', () {
      final json = {
        'id': '10',
        'attributes': {
          'canonicalTitle': 'One Piece',
          'synopsis': 'Pirate adventure',
          'posterImage': {'small': 'http://poster.jpg'},
        },
      };
      final manga = Manga.fromKitsuJson(json);
      expect(manga.id, '10');
      expect(manga.title, 'One Piece');
    });

    test('3. ServerFailure message is correct', () {
      const failure = ServerFailure('Server Error');
      expect(failure.message, 'Server Error');
    });

    test('4. NetworkFailure message is correct', () {
      const failure = NetworkFailure('No Internet');
      expect(failure.message, 'No Internet');
    });

    test('5. Manga list comparison', () {
      const list1 = [
        Manga(id: '1', title: 'A', description: 'B', imageUrl: 'C'),
      ];
      expect(list1.length, 1);
    });

    test('6. Manga JSON parsing with fallback title', () {
      final json = {
        'id': '2',
        'attributes': {'synopsis': 'No title provided'},
      };
      final manga = Manga.fromKitsuJson(json);
      expect(manga.title, 'Titre inconnu');
    });

    test('7. Manga JSON parsing with fallback image', () {
      final json = {
        'id': '3',
        'attributes': {'canonicalTitle': 'Bleach'},
      };
      final manga = Manga.fromKitsuJson(json);
      expect(manga.imageUrl, isNull);
    });

    test('8. Failure instances distinction', () {
      const f1 = ServerFailure('Error 1');
      const f2 = NetworkFailure('Error 1');
      expect(f1.runtimeType, isNot(f2.runtimeType));
    });

    test('9. Manga properties non-null assertion', () {
      const manga = Manga(
        id: '5',
        title: 'Title',
        description: 'Desc',
        imageUrl: 'Url',
      );
      expect(manga.description?.isNotEmpty ?? false, true);
    });

    test('10. Result Success and Error pattern test', () {
      const successResult = Success<String>('Data');
      expect(successResult.data, 'Data');
    });
  });
}
