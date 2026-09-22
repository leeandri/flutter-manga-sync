import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_manga_sync/features/manga/presentation/providers/manga_providers.dart';

class MangaCatalogScreen extends ConsumerWidget {
  const MangaCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaListAsync = ref.watch(mangaListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('MangaSync Catalog'), centerTitle: true),
      body: mangaListAsync.when(
        data: (mangas) {
          if (mangas.isEmpty) {
            return const Center(child: Text('Aucun manga trouvé.'));
          }
          return ListView.builder(
            itemCount: mangas.length,
            itemBuilder: (context, index) {
              final manga = mangas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: manga.coverUrl.isNotEmpty
                      ? Image.network(
                          manga.coverUrl,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        )
                      : const Icon(Icons.book),
                  title: Text(
                    manga.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    manga.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 8),
                Text(
                  'Erreur : ${err.toString().replaceAll('Exception: ', '')}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(mangaListProvider),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
