import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_manga_sync/features/manga/presentation/providers/manga_providers.dart';
import 'package:flutter_manga_sync/features/manga/presentation/screens/manga_detail_screen.dart';

class MangaFavoritesScreen extends ConsumerWidget {
  const MangaFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites (Offline)')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorite manga saved yet.'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final manga = favorites[index];
                return ListTile(
                  leading: manga.coverUrl.isNotEmpty
                      ? Image.network(
                          manga.coverUrl,
                          width: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.book),
                  title: Text(manga.title),
                  subtitle: Text(
                    manga.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MangaDetailScreen(manga: manga),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
