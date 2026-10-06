import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_manga_sync/core/widgets/language_selector.dart';

void main() {
  group('Widget Tests - UI Components', () {
    testWidgets('1. LanguageSelector renders language icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: LanguageSelector())),
        ),
      );
      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('2. CircularProgressIndicator displays correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('3. Custom ElevatedButton displays text correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(onPressed: () {}, child: const Text('Login')),
          ),
        ),
      );
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('4. TextField displays label text correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TextField(decoration: InputDecoration(labelText: 'Email')),
          ),
        ),
      );
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('5. Custom Card displays title and subtitle', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                title: Text('Manga Title'),
                subtitle: Text('Action / Adventure'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Manga Title'), findsOneWidget);
      expect(find.text('Action / Adventure'), findsOneWidget);
    });
  });
}
