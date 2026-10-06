import 'package:hive/hive.dart';

abstract class MangaLocalDataSource {
  Future<void> cacheMangas(List<dynamic> mangasJson);
  List<dynamic> getCachedMangas();
  List<dynamic> getFavorites();
  bool isFavorite(String id);
  Future<void> saveFavorite(Map<String, dynamic> mangaMap);
  Future<void> removeFavorite(String id);
}

class MangaLocalDataSourceImpl implements MangaLocalDataSource {
  static const String cacheBoxName = 'manga_cache_box';
  static const String favoritesBoxName = 'manga_favorites_box';
  static const String cacheKey = 'cached_manga_list';

  Map<String, dynamic> _normalizeMap(dynamic input) {
    if (input is Map) {
      return Map<String, dynamic>.from(
        input.map(
          (key, value) => MapEntry(key.toString(), _normalizeValue(value)),
        ),
      );
    }
    return <String, dynamic>{};
  }

  dynamic _normalizeValue(dynamic value) {
    if (value is Map) {
      return _normalizeMap(value);
    } else if (value is List) {
      return value.map(_normalizeValue).toList();
    }
    return value;
  }

  @override
  Future<void> cacheMangas(List<dynamic> mangasJson) async {
    final box = Hive.box(cacheBoxName);
    await box.put(cacheKey, mangasJson);
  }

  @override
  List<dynamic> getCachedMangas() {
    final box = Hive.box(cacheBoxName);
    final data = box.get(cacheKey, defaultValue: <dynamic>[]);
    if (data is List) {
      return data.map((item) => _normalizeValue(item)).toList();
    }
    return <dynamic>[];
  }

  @override
  List<dynamic> getFavorites() {
    final box = Hive.box(favoritesBoxName);
    return box.values.map((item) => _normalizeValue(item)).toList();
  }

  @override
  bool isFavorite(String id) {
    final box = Hive.box(favoritesBoxName);
    return box.containsKey(id);
  }

  @override
  Future<void> saveFavorite(Map<String, dynamic> mangaMap) async {
    final box = Hive.box(favoritesBoxName);
    await box.put(mangaMap['id'], mangaMap);
  }

  @override
  Future<void> removeFavorite(String id) async {
    final box = Hive.box(favoritesBoxName);
    await box.delete(id);
  }
}
