import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';

class MangaModel extends Manga {
  const MangaModel({
    required super.id,
    required super.title,
    super.description,
    super.imageUrl,
  });

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    final attributesRaw = json['attributes'];
    final Map<String, dynamic> attributes = attributesRaw is Map
        ? Map<String, dynamic>.from(
            attributesRaw.map((k, v) => MapEntry(k.toString(), v)),
          )
        : {};

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
      imageUrl:
          posterImage['small']?.toString() ??
          posterImage['original']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': {
        'canonicalTitle': title,
        'synopsis': description,
        'posterImage': {'small': imageUrl},
      },
    };
  }
}
