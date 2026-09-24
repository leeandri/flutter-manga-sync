import 'package:hive_flutter/hive_flutter.dart';

abstract class MangaLocalDataSource {
  Future<void> cacheMangas(List<Map<String, dynamic>> mangasJson);
  List<Map<String, dynamic>> getCachedMangas();

  Future<void> saveFavorite(Map<String, dynamic> mangaJson);
  Future<void> removeFavorite(String mangaId);
  List<Map<String, dynamic>> getFavorites();
  bool isFavorite(String mangaId);
}

class MangaLocalDataSourceImpl implements MangaLocalDataSource {
  static const String boxName = 'manga_cache_box';
  static const String cacheKey = 'popular_mangas';
  static const String favoritesBoxName = 'manga_favorites_box';

  final Box _box;

  MangaLocalDataSourceImpl(this._box);

  @override
  Future<void> cacheMangas(List<Map<String, dynamic>> mangasJson) async {
    // On sauvegarde la liste sous forme de JSON brut dans Hive
    await _box.put(cacheKey, mangasJson);
  }

  @override
  List<Map<String, dynamic>> getCachedMangas() {
    final rawData = _box.get(cacheKey);
    if (rawData != null) {
      final List rawList = rawData as List;
      return rawList
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> saveFavorite(Map<String, dynamic> mangaJson) async {
    final favBox = Hive.box(favoritesBoxName);
    await favBox.put(mangaJson['id'], mangaJson);
  }

  @override
  Future<void> removeFavorite(String mangaId) async {
    final favBox = Hive.box(favoritesBoxName);
    await favBox.delete(mangaId);
  }

  @override
  List<Map<String, dynamic>> getFavorites() {
    final favBox = Hive.box(favoritesBoxName);
    return favBox.values
        .cast<Map<dynamic, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  @override
  bool isFavorite(String mangaId) {
    final favBox = Hive.box(favoritesBoxName);
    return favBox.containsKey(mangaId);
  }
}
