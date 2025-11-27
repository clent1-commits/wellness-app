import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Correct import path for main.dart
import 'package:mental_wellness_tips1/main.dart';

void main() {
  testWidgets('App loads and displays title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MentalWellnessTips()); // Use the correct class name

    // Verify that the app loads properly by checking for the title text
    expect(find.text('Mental Wellness Tips'), findsOneWidget);  // Look for the title
  });
}
