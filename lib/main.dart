import 'package:flutter/material.dart';
import 'package:flutter_manga_sync/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_manga_sync/core/theme/app_theme.dart';
import 'package:flutter_manga_sync/features/manga/data/datasources/manga_local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox(MangaLocalDataSourceImpl.boxName);
  await Hive.openBox(MangaLocalDataSourceImpl.favoritesBoxName);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga Sync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.japaneseDarkTheme,
      home: const LoginScreen(), // ➔ Démarre sur la connexion
    );
  }
}
