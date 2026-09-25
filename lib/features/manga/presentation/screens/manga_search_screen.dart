import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/manga_providers.dart';

class MangaSearchScreen extends ConsumerStatefulWidget {
  const MangaSearchScreen({super.key});

  @override
  ConsumerState<MangaSearchScreen> createState() => _MangaSearchScreenState();
}

class _MangaSearchScreenState extends ConsumerState<MangaSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(
      mangaSearchProvider(_searchController.text),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Rechercher un Manga (REST API)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Titre du manga...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {});
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: searchResults.when(
              data: (mangas) {
                if (mangas.isEmpty) {
                  return const Center(child: Text('Aucun résultat trouvé.'));
                }
                return ListView.builder(
                  itemCount: mangas.length,
                  itemBuilder: (context, index) {
                    final manga = mangas[index];
                    return ListTile(
                      leading: manga.imageUrl != null
                          ? Image.network(
                              manga.imageUrl!,
                              width: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.book),
                      title: Text(manga.title),
                      subtitle: Text(
                        manga.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erreur : $err')),
            ),
          ),
        ],
      ),
    );
  }
}
