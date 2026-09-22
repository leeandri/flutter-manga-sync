import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';

abstract class MangaRepository {
  Future<Result<List<Manga>>> getMangaList();
}
