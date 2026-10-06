import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_manga_sync/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End App Integration Tests', () {
    testWidgets('1. App launches successfully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('2. Main layout and navigation components render correctly', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
