import '../../../../core/errors/failures.dart';
import '../entities/manga.dart';

abstract class MangaRepository {
  Future<Result<List<Manga>>> getMangaList();
  Future<Result<List<Manga>>> searchManga(String query);
}
