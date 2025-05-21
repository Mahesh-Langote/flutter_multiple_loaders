import 'package:flutter/material.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';

/// A widget that provides controls to manipulate loader properties
class LoaderControlPanel extends StatelessWidget {
  /// The loader controller to manage animation state
  final LoaderController controller;

  /// Whether the loader is currently animating
  final bool isAnimating;

  /// The currently selected loader size
  final LoaderSize selectedSize;

  /// The currently selected primary color
  final Color primaryColor;

  /// The currently selected secondary color
  final Color? secondaryColor;

  /// The currently selected tertiary color
  final Color? tertiaryColor;

  /// The animation duration in milliseconds
  final int durationMs;

  /// The stroke width for loaders that use strokes
  final double? strokeWidth;

  /// Whether stroke width control should be shown
  final bool showStrokeWidth;

  /// Callback when the animation state changes
  final void Function(bool isAnimating) onAnimatingChanged;

  /// Callback when the size changes
  final void Function(LoaderSize size) onSizeChanged;

  /// Callback when the primary color changes
  final void Function(Color color) onPrimaryColorChanged;

  /// Callback when the secondary color changes
  final void Function(Color color) onSecondaryColorChanged;

  /// Callback when the tertiary color changes
  final void Function(Color color) onTertiaryColorChanged;

  /// Callback when the duration changes
  final void Function(int duration) onDurationChanged;

  /// Callback when the stroke width changes
  final void Function(double width)? onStrokeWidthChanged;

  /// Creates a loader control panel
  const LoaderControlPanel({
    super.key,
    required this.controller,
    required this.isAnimating,
    required this.selectedSize,
    required this.primaryColor,
    required this.durationMs,
    required this.onAnimatingChanged,
    required this.onSizeChanged,
    required this.onPrimaryColorChanged,
    required this.onDurationChanged,
    this.secondaryColor,
    this.tertiaryColor,
    this.strokeWidth,
    this.showStrokeWidth = false,
    required this.onSecondaryColorChanged,
    required this.onTertiaryColorChanged,
    this.onStrokeWidthChanged,
  });
  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive adjustments
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    final bool isLandscape = screenSize.width > screenSize.height;
    final bool isWideScreen = screenSize.width >= 900;

    // Determine if we're in a side-by-side layout
    final bool useSideBySideLayout = isLandscape && isWideScreen;

    // Return the container with all contents
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius:
            useSideBySideLayout
                ? const BorderRadius.all(Radius.circular(16))
                : const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            if (useSideBySideLayout)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Control Panel',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final newState = !isAnimating;
                        onAnimatingChanged(newState);
                        if (newState) {
                          controller.start();
                        } else {
                          controller.stop();
                        }
                      },
                      icon: Icon(isAnimating ? Icons.pause : Icons.play_arrow),
                      label: Text(isAnimating ? 'Pause' : 'Play'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        onAnimatingChanged(true);
                        controller.reset();
                        controller.start();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Size control
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Size:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: DropdownButton<LoaderSize>(
                      value: selectedSize,
                      isExpanded: true,
                      items:
                          LoaderSize.values
                              .where((size) => size != LoaderSize.custom)
                              .map(
                                (size) => DropdownMenuItem(
                                  value: size,
                                  child: Text(size.name),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          onSizeChanged(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Color controls
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Primary Color:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                  Expanded(flex: 3, child: _buildPrimaryColorDropdown()),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Secondary Color:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                  Expanded(flex: 3, child: _buildSecondaryColorDropdown()),
                ],
              ),
            ),

            if (tertiaryColor != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Tertiary Color:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                    ),
                    Expanded(flex: 3, child: _buildTertiaryColorDropdown()),
                  ],
                ),
              ),

            // Slider controls
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Duration:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                      Text(
                        '${durationMs}ms',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8.0,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16.0,
                      ),
                    ),
                    child: Slider(
                      value: durationMs.toDouble(),
                      min: 500,
                      max: 6000,
                      divisions: 11,
                      label: '${durationMs}ms',
                      onChanged: (value) {
                        onDurationChanged(value.toInt());
                      },
                    ),
                  ),
                ],
              ),
            ),

            if (showStrokeWidth &&
                strokeWidth != null &&
                onStrokeWidthChanged != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stroke Width:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                        Text(
                          '${strokeWidth!.toStringAsFixed(1)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8.0,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 16.0,
                        ),
                      ),
                      child: Slider(
                        value: strokeWidth!,
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        label: strokeWidth!.toStringAsFixed(1),
                        onChanged: onStrokeWidthChanged!,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // We separate the dropdown builders to provide better type safety
  // and avoid duplicate color values
  Widget _buildPrimaryColorDropdown() {
    // Define primary colors with unique values
    final Map<String, Color> primaryColors = {
      'Blue': Colors.blue,
      'Red': Colors.red,
      'Green': Colors.green,
      'Purple': Colors.purple,
      'Orange': Colors.orange,
      'Teal': Colors.teal,
      'Deep Purple': Colors.deepPurple,
      'Deep Orange': Colors.deepOrange,
    };

    // Find the key for the current color
    String currentColorKey = 'Blue';
    for (var entry in primaryColors.entries) {
      if (entry.value == primaryColor) {
        currentColorKey = entry.key;
        break;
      }
    }

    return DropdownButton<String>(
      value: currentColorKey,
      items:
          primaryColors.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.key),
                ),
              )
              .toList(),
      onChanged: (value) {
        if (value != null && primaryColors.containsKey(value)) {
          onPrimaryColorChanged(primaryColors[value]!);
        }
      },
    );
  }

  Widget _buildSecondaryColorDropdown() {
    // Define secondary colors with unique values
    final Map<String, Color> secondaryColors = {
      'Pink': Colors.pinkAccent,
      'Amber': Colors.amber,
      'Cyan': Colors.cyanAccent,
      'Light Green': Colors.lightGreenAccent,
      'Purple': Colors.purpleAccent,
      'Orange': Colors.orangeAccent,
      'Blue': Colors.blue,
    };

    // Find the key for the current color or use default
    String currentColorKey = 'Pink';
    if (secondaryColor != null) {
      for (var entry in secondaryColors.entries) {
        if (entry.value == secondaryColor) {
          currentColorKey = entry.key;
          break;
        }
      }
    }

    return DropdownButton<String>(
      value: currentColorKey,
      items:
          secondaryColors.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.key),
                ),
              )
              .toList(),
      onChanged: (value) {
        if (value != null && secondaryColors.containsKey(value)) {
          onSecondaryColorChanged(secondaryColors[value]!);
        }
      },
    );
  }

  Widget _buildTertiaryColorDropdown() {
    // Define tertiary colors with unique values
    final Map<String, Color> tertiaryColors = {
      'White': Colors.white,
      'Yellow': Colors.yellow,
      'Red': Colors.redAccent,
      'Deep Orange': Colors.deepOrange,
      'Light Blue': Colors.lightBlueAccent,
    };

    // Find the key for the current color or use default
    String currentColorKey = 'White';
    if (tertiaryColor != null) {
      for (var entry in tertiaryColors.entries) {
        if (entry.value == tertiaryColor) {
          currentColorKey = entry.key;
          break;
        }
      }
    }

    return DropdownButton<String>(
      value: currentColorKey,
      items:
          tertiaryColors.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.key),
                ),
              )
              .toList(),
      onChanged: (value) {
        if (value != null && tertiaryColors.containsKey(value)) {
          onTertiaryColorChanged(tertiaryColors[value]!);
        }
      },
    );
  }
}
