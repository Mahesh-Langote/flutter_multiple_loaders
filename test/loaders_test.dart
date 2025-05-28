import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';

void main() {
  testWidgets('SpinnerLoader creates and displays correctly', (
    WidgetTester tester,
  ) async {
    // Build our widget
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Center(child: SpinnerLoader()))),
    ); // Verify that the SpinnerLoader is rendered
    expect(find.byType(SpinnerLoader), findsOneWidget);

    // Verify that at least one AnimatedBuilder is present
    expect(find.byType(AnimatedBuilder), findsWidgets);
  });

  testWidgets('PulseLoader respects custom options', (
    WidgetTester tester,
  ) async {
    // Build widget with custom options
    const customOptions = LoaderOptions(
      color: Colors.red,
      size: LoaderSize.large,
      durationMs: 1000,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: PulseLoader(options: customOptions)),
        ),
      ),
    );

    // Verify the PulseLoader is rendered
    expect(find.byType(PulseLoader), findsOneWidget);
  });

  testWidgets('BounceLoader creates with custom dot count', (
    WidgetTester tester,
  ) async {
    // Build widget with custom dot count
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: BounceLoader(dotCount: 5))),
      ),
    ); // Verify the BounceLoader is rendered
    expect(find.byType(BounceLoader), findsOneWidget);
  });

  testWidgets('HeartbeatLoader creates and displays correctly', (
    WidgetTester tester,
  ) async {
    // Build our widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: HeartbeatLoader(
              options: LoaderOptions(
                color: Colors.red,
                size: LoaderSize.medium,
                durationMs: 2500,
              ),
              pulseIntensity: 0.3,
            ),
          ),
        ),
      ),
    ); // Verify that the HeartbeatLoader is rendered
    expect(find.byType(HeartbeatLoader), findsOneWidget);

    // Verify that AnimatedBuilder is present
    expect(find.byType(AnimatedBuilder), findsWidgets);

    // Verify that CustomPaint is present (for the heart shape)
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
