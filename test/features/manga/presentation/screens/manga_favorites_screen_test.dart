import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_manga_sync/features/manga/data/datasources/manga_local_datasource.dart';
import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';
import 'package:flutter_manga_sync/features/manga/presentation/providers/manga_providers.dart';
import 'package:flutter_manga_sync/features/manga/presentation/screens/manga_favorites_screen.dart';

class FakeMangaLocalDataSource implements MangaLocalDataSource {
  final List<Manga> initialFavorites;
  FakeMangaLocalDataSource([this.initialFavorites = const []]);

  @override
  List<Manga> getFavorites() => initialFavorites;

  @override
  Future<void> saveFavorite(Map<String, dynamic> mangaMap) async {}

  @override
  Future<void> removeFavorite(String id) async {
    initialFavorites.removeWhere((item) => item.id == id);
  }

  @override
  bool isFavorite(String id) {
    return initialFavorites.any((item) => item.id == id);
  }

  @override
  Future<void> cacheMangas(List<dynamic> mangas) async {}

  @override
  List<Manga> getCachedMangas() => [];
}

class TestFavoritesNotifier extends FavoritesNotifier {
  TestFavoritesNotifier(
    List<Manga> initialValue,
    MangaLocalDataSource dataSource,
  ) : super(dataSource) {
    state = initialValue;
  }
}

void main() {
  testWidgets('Affiche le message si aucun favori', (
    WidgetTester tester,
  ) async {
    final fakeDs = FakeMangaLocalDataSource([]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mangaLocalDataSourceProvider.overrideWithValue(fakeDs),
          favoritesProvider.overrideWith(
            (ref) => TestFavoritesNotifier([], fakeDs),
          ),
        ],
        child: const MaterialApp(home: MangaFavoritesScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MangaFavoritesScreen), findsOneWidget);
    expect(find.text('No favorite manga saved yet.'), findsOneWidget);
  });

  testWidgets('Affiche la liste quand des favoris existent', (
    WidgetTester tester,
  ) async {
    const fakeManga = Manga(
      id: '1',
      title: 'One Piece',
      description: 'Aventura de piratas',
      imageUrl: '',
    );
    final fakeDs = FakeMangaLocalDataSource([fakeManga]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mangaLocalDataSourceProvider.overrideWithValue(fakeDs),
          favoritesProvider.overrideWith(
            (ref) => TestFavoritesNotifier([fakeManga], fakeDs),
          ),
        ],
        child: const MaterialApp(home: MangaFavoritesScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text('Aventura de piratas'), findsOneWidget);
  });
}
