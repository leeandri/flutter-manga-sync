import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_manga_sync/features/manga/presentation/screens/manga_search_screen.dart';

void main() {
  testWidgets('Should render MangaSearchScreen and display search input', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: MangaSearchScreen())),
    );

    await tester.pump();

    // Verify search screen rendering and search bar presence
    expect(find.byType(MangaSearchScreen), findsOneWidget);
    expect(find.byType(TextField), findsAtLeastNWidgets(1));
  });
}
