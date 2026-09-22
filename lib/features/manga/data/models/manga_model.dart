import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';

class MangaModel extends Manga {
  const MangaModel({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.description,
  });

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>? ?? {};
    final posterImage =
        attributes['posterImage'] as Map<String, dynamic>? ?? {};

    return MangaModel(
      id: json['id']?.toString() ?? '',
      title:
          attributes['canonicalTitle'] ??
          attributes['titles']?['en'] ??
          'Untitled',
      coverUrl: posterImage['small'] ?? posterImage['original'] ?? '',
      description: attributes['synopsis'] ?? 'No description available.',
    );
  }
}
