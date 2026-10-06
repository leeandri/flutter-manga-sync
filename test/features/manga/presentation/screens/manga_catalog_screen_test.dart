import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_manga_sync/features/manga/domain/entities/manga.dart';
import 'package:flutter_manga_sync/features/manga/presentation/providers/manga_providers.dart';
import 'package:flutter_manga_sync/features/manga/presentation/screens/manga_catalog_screen.dart';

void main() {
  testWidgets('Should render MangaCatalogScreen without network calls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override default async list with empty list to prevent network requests
          mangaListProvider.overrideWith((ref) async => <Manga>[]),
        ],
        child: const MaterialApp(home: MangaCatalogScreen()),
      ),
    );

    await tester.pump();

    expect(find.byType(MangaCatalogScreen), findsOneWidget);
  });
}
