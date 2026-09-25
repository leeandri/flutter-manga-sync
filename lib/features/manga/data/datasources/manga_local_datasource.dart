import 'package:hive/hive.dart';

abstract class MangaLocalDataSource {
  String get boxName;
  Future<void> cacheMangas(List<Map<String, dynamic>> mangas);
  List<Map<String, dynamic>> getCachedMangas();
  Future<void> saveFavorite(Map<String, dynamic> manga);
  Future<void> removeFavorite(String id);
  List<Map<String, dynamic>> getFavorites();
  bool isFavorite(String id);
}

class MangaLocalDataSourceImpl implements MangaLocalDataSource {
  static const String cacheBoxName = 'manga_cache_box';
  static const String favoritesBoxName = 'manga_favorites_box';

  final String _boxName;

  MangaLocalDataSourceImpl([String? boxName])
    : _boxName = boxName ?? cacheBoxName;

  @override
  String get boxName => _boxName;

  @override
  Future<void> cacheMangas(List<Map<String, dynamic>> mangas) async {
    final box = Hive.box(_boxName);
    await box.clear();
    await box.addAll(mangas);
  }

  @override
  List<Map<String, dynamic>> getCachedMangas() {
    final box = Hive.box(_boxName);
    return box.values.map((e) {
      if (e is Map) {
        return Map<String, dynamic>.from(
          e.map((k, v) => MapEntry(k.toString(), v)),
        );
      }
      return <String, dynamic>{};
    }).toList();
  }

  @override
  Future<void> saveFavorite(Map<String, dynamic> manga) async {
    final box = Hive.box(favoritesBoxName);
    final id = manga['id']?.toString() ?? '';
    if (id.isNotEmpty) {
      await box.put(id, manga);
    }
  }

  @override
  Future<void> removeFavorite(String id) async {
    final box = Hive.box(favoritesBoxName);
    await box.delete(id);
  }

  @override
  List<Map<String, dynamic>> getFavorites() {
    final box = Hive.box(favoritesBoxName);
    return box.values.map((e) {
      if (e is Map) {
        return Map<String, dynamic>.from(
          e.map((k, v) => MapEntry(k.toString(), v)),
        );
      }
      return <String, dynamic>{};
    }).toList();
  }

  @override
  bool isFavorite(String id) {
    final box = Hive.box(favoritesBoxName);
    return box.containsKey(id);
  }
}
