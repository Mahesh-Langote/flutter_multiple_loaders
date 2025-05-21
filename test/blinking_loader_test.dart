import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';

void main() {
  testWidgets('BlinkingLoader creates and displays correctly', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Center(child: BlinkingLoader()))),
    );

    // Verify that the BlinkingLoader is rendered correctly
    expect(find.byType(BlinkingLoader), findsOneWidget);
    expect(find.byType(AnimatedBuilder), findsOneWidget);
    expect(find.byType(Opacity), findsOneWidget);
  });

  testWidgets('BlinkingLoader changes shape correctly', (
    WidgetTester tester,
  ) async {
    // Test with square shape
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: BlinkingLoader(shape: BlinkingShape.square)),
        ),
      ),
    );

    // Verify that the BlinkingLoader renders with square shape
    expect(find.byType(BlinkingLoader), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);

    // Test with triangle shape
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: BlinkingLoader(shape: BlinkingShape.triangle)),
        ),
      ),
    );

    // Verify that the BlinkingLoader renders with triangle shape
    expect(find.byType(BlinkingLoader), findsOneWidget);
    expect(find.byType(CustomPaint), findsOneWidget);

    // Test with star shape
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: BlinkingLoader(shape: BlinkingShape.star)),
        ),
      ),
    );

    // Verify that the BlinkingLoader renders with star shape
    expect(find.byType(BlinkingLoader), findsOneWidget);
    expect(find.byType(CustomPaint), findsOneWidget);
  });

  testWidgets('BlinkingLoader respects LoaderOptions', (
    WidgetTester tester,
  ) async {
    const customColor = Colors.red;
    const customSize = LoaderSize.large;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: BlinkingLoader(
              options: LoaderOptions(
                color: customColor,
                size: customSize,
                durationMs: 2000,
                loop: false,
              ),
            ),
          ),
        ),
      ),
    );

    // Verify that the BlinkingLoader is rendered with the custom options
    expect(find.byType(BlinkingLoader), findsOneWidget);

    // Verify that the animation updates correctly after some time
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify widget is still there after animation
    expect(find.byType(BlinkingLoader), findsOneWidget);
  });
}
