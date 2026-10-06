import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_manga_sync/features/manga/presentation/providers/manga_providers.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: 'Change language',
      onSelected: (Locale locale) {
        ref.read(localeProvider.notifier).state = locale;
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        const PopupMenuItem<Locale>(
          value: Locale('en'),
          child: Text('English 🇺🇸'),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('fr'),
          child: Text('Français 🇫🇷'),
        ),
      ],
    );
  }
}
