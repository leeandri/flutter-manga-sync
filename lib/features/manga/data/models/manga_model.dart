import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';

class MangaModel extends Manga {
  const MangaModel({
    required super.id,
    required super.title,
    required super.description,
    required super.coverUrl,
  });

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    // 1. Conversion sécurisée de la map d'attributs
    final attributesRaw = json['attributes'];
    final Map<String, dynamic> attributes = attributesRaw is Map
        ? Map<String, dynamic>.from(
            attributesRaw.map((k, v) => MapEntry(k.toString(), v)),
          )
        : {};

    // 2. Conversion sécurisée de la map d'images
    final posterImageRaw = attributes['posterImage'];
    final Map<String, dynamic> posterImage = posterImageRaw is Map
        ? Map<String, dynamic>.from(
            posterImageRaw.map((k, v) => MapEntry(k.toString(), v)),
          )
        : {};

    return MangaModel(
      id: json['id']?.toString() ?? '',
      title: attributes['canonicalTitle']?.toString() ?? 'Sans titre',
      description: attributes['synopsis']?.toString() ?? '',
      coverUrl: posterImage['small']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': {
        'canonicalTitle': title,
        'synopsis': description,
        'posterImage': {'small': coverUrl},
      },
    };
  }
}
