import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';
import 'package:flutter_manga_sync/features/manga/presentation/providers/manga_providers.dart';

class MangaDetailScreen extends ConsumerWidget {
  final Manga manga;

  const MangaDetailScreen({super.key, required this.manga});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final favoritesList = ref.watch(favoritesProvider);
    final isFavorite = favoritesList.any((m) => m.id == manga.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(manga.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
              size: 28,
            ),
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            onPressed: () {
              final rawJson = {
                'id': manga.id,
                'attributes': {
                  'canonicalTitle': manga.title,
                  'synopsis': manga.description,
                  'posterImage': {'small': manga.imageUrl},
                },
              };
              favoritesNotifier.toggleFavorite(manga, rawJson);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite
                        ? 'Removed from favorites'
                        : 'Added to favorites',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (manga.imageUrl != null && manga.imageUrl!.isNotEmpty)
              Image.network(
                manga.imageUrl!,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga.title,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Synopsis',
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (manga.description != null && manga.description!.isNotEmpty)
                        ? manga.description!
                        : 'No synopsis available.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
