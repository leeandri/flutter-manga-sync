import 'package:flutter_manga_sync/core/errors/failures.dart'; // ou là où ton classe Result/Success/Error est définie
import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';
import 'package:flutter_manga_sync/features/manga/domain/repositories/manga_repository.dart';

class GetMangaListUseCase {
  final MangaRepository repository;

  GetMangaListUseCase(this.repository);

  Future<Result<List<Manga>>> call() async {
    return await repository.getMangaList();
  }
}
