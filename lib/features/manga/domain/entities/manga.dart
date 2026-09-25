class Manga {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;

  const Manga({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
  });

  factory Manga.fromKitsuJson(Map<dynamic, dynamic> json) {
    // Conversion sécurisée des Maps brutes (Hive / JSON)
    final attributesRaw = json['attributes'];
    final Map<String, dynamic> attributes = attributesRaw is Map
        ? attributesRaw.map((k, v) => MapEntry(k.toString(), v))
        : {};

    final posterImageRaw = attributes['posterImage'];
    final Map<String, dynamic> posterImage = posterImageRaw is Map
        ? posterImageRaw.map((k, v) => MapEntry(k.toString(), v))
        : {};

    return Manga(
      id: json['id']?.toString() ?? '',
      title:
          attributes['canonicalTitle']?.toString() ??
          attributes['title']?.toString() ??
          'Titre inconnu',
      description: attributes['synopsis']?.toString(),
      imageUrl:
          posterImage['small']?.toString() ??
          posterImage['original']?.toString(),
    );
  }
}
