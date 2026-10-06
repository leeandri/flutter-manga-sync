import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_manga_sync/features/manga/presentation/providers/manga_providers.dart';
import 'package:flutter_manga_sync/l10n/app_localizations.dart';
import 'package:flutter_manga_sync/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_manga_sync/core/theme/app_theme.dart';
import 'package:flutter_manga_sync/features/manga/data/datasources/manga_local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox(MangaLocalDataSourceImpl.cacheBoxName);
  await Hive.openBox(MangaLocalDataSourceImpl.favoritesBoxName);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    return MaterialApp(
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fr')],
      title: 'Manga Sync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.japaneseDarkTheme,
      home: const LoginScreen(), // ➔ Démarre sur la connexion
    );
  }
}
