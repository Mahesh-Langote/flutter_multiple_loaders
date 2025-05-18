import 'package:flutter/material.dart';
import '../utils/loader_size.dart';

/// Options class for configuring loaders.
///
/// This class defines common configuration options that can be applied
/// to all loader animations in this package.
class LoaderOptions {
  /// The primary color of the loader.
  final Color color;

  /// The size of the loader.
  final LoaderSize size;

  /// The animation duration in milliseconds.
  final int durationMs;

  /// Whether the animation should run in a loop.
  final bool loop;

  /// The background color of the loader (if applicable).
  final Color? backgroundColor;

  /// Secondary color for loaders that support multiple colors.
  final Color? secondaryColor;

  /// Tertiary color for loaders that support multiple colors.
  final Color? tertiaryColor;

  /// The stroke width for loaders that use strokes (like circle loaders).
  final double strokeWidth;

  /// Constructor for [LoaderOptions].
  const LoaderOptions({
    this.color = Colors.blue,
    this.size = LoaderSize.medium,
    this.durationMs = 1500,
    this.loop = true,
    this.backgroundColor,
    this.secondaryColor,
    this.tertiaryColor,
    this.strokeWidth = 4.0,
  });

  /// Creates a copy of this [LoaderOptions] with the given fields replaced by new values.
  LoaderOptions copyWith({
    Color? color,
    LoaderSize? size,
    int? durationMs,
    bool? loop,
    Color? backgroundColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    double? strokeWidth,
  }) {
    return LoaderOptions(
      color: color ?? this.color,
      size: size ?? this.size,
      durationMs: durationMs ?? this.durationMs,
      loop: loop ?? this.loop,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}
