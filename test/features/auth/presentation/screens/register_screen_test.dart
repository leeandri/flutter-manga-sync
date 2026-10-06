import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_manga_sync/features/auth/presentation/screens/register_screen.dart';

void main() {
  testWidgets('Should display registration fields and button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: RegisterScreen())),
    );

    await tester.pumpAndSettle();

    // Verify presence of input fields and submit button
    expect(find.byType(TextField), findsAtLeastNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
