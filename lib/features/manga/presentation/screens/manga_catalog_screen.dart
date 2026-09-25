import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_manga_sync/features/manga/presentation/providers/manga_providers.dart';
import 'package:flutter_manga_sync/features/manga/presentation/screens/manga_detail_screen.dart';
import 'package:flutter_manga_sync/features/manga/presentation/screens/manga_favorites_screen.dart';
import 'package:flutter_manga_sync/features/auth/presentation/screens/login_screen.dart';

class MangaCatalogScreen extends ConsumerWidget {
  const MangaCatalogScreen({super.key});

  Widget _buildOfflineBanner() {
    return Container(
      color: Colors.amber.shade800,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'Mode hors ligne : affichage des données en cache',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaListAsync = ref.watch(mangaListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MangaSync Catalog'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.collections_bookmark, color: Colors.amber),
            tooltip: 'My Offline Favorites',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MangaFavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.redAccent),
            tooltip: 'Sign Out',
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: mangaListAsync.when(
        data: (mangas) {
          if (mangas.isEmpty) {
            return const Center(child: Text('No manga found.'));
          }
          return Column(
            children: [
              _buildOfflineBanner(),
              Expanded(
                child: ListView.builder(
                  itemCount: mangas.length,
                  itemBuilder: (context, index) {
                    final manga = mangas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MangaDetailScreen(manga: manga),
                            ),
                          );
                        },
                        leading:
                            (manga.imageUrl != null &&
                                manga.imageUrl!.isNotEmpty)
                            ? Image.network(
                                manga.imageUrl!,
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
                          manga.description ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    );
                  },
                ),
              ),
            ],
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
                  'Error: ${err.toString().replaceAll('Exception: ', '')}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(mangaListProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
