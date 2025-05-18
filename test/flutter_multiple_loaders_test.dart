import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';

void main() {
  test('LoaderOptions defaults are set correctly', () {
    const options = LoaderOptions();
    expect(options.color, Colors.blue);
    expect(options.size, LoaderSize.medium);
    expect(options.durationMs, 1500);
    expect(options.loop, true);
    expect(options.strokeWidth, 4.0);
  });

  test('LoaderOptions copyWith creates a new instance with updated values', () {
    const options = LoaderOptions(color: Colors.blue);
    final newOptions = options.copyWith(color: Colors.red);

    expect(newOptions.color, Colors.red);
    expect(options.color, Colors.blue); // Original unchanged
  });

  test('LoaderSize enum values are correct', () {
    expect(LoaderSize.small.value, 24.0);
    expect(LoaderSize.medium.value, 32.0);
    expect(LoaderSize.large.value, 48.0);
  });
}
