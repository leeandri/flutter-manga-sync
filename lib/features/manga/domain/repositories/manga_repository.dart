import '../../../../core/errors/failures.dart';
import '../entities/manga.dart';

abstract class MangaRepository {
  Future<Result<List<Manga>>> getMangaList();
}
