import 'package:flutter/material.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';

class LoaderControlPanel extends StatelessWidget {
  final LoaderController controller;
  final bool isAnimating;
  final LoaderSize selectedSize;
  final Color primaryColor;
  final Color? secondaryColor;
  final Color? tertiaryColor;
  final Color? quaternaryColor;
  final int durationMs;
  final double? strokeWidth;
  final bool showStrokeWidth;
  final void Function(bool isAnimating) onAnimatingChanged;
  final void Function(LoaderSize size) onSizeChanged;
  final void Function(Color color) onPrimaryColorChanged;
  final void Function(Color color) onSecondaryColorChanged;
  final void Function(Color color) onTertiaryColorChanged;
  final void Function(Color color) onQuaternaryColorChanged;
  final void Function(int duration) onDurationChanged;
  final void Function(double width)? onStrokeWidthChanged;

  final bool isBottomSheet;

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
    this.quaternaryColor,
    this.strokeWidth,
    this.showStrokeWidth = false,
    required this.onSecondaryColorChanged,
    required this.onTertiaryColorChanged,
    required this.onQuaternaryColorChanged,
    this.onStrokeWidthChanged,
    this.isBottomSheet = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    final bool isWideScreen = screenSize.width >= 900;
    final bool useSideBySideLayout = isLandscape && isWideScreen;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: isBottomSheet 
            ? null 
            : (useSideBySideLayout
                ? const BorderRadius.all(Radius.circular(32))
                : const BorderRadius.vertical(top: Radius.circular(32))),
        boxShadow: isBottomSheet 
            ? null 
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.tune_rounded, color: colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Configuration',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton.filledTonal(
                  onPressed: () {
                    onAnimatingChanged(true);
                    controller.reset();
                    controller.start();
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  tooltip: 'Reset Animation',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Main Toggle
            _buildControlSection(
              context,
              'Playback',
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: true,
                          label: Text('Play'),
                          icon: Icon(Icons.play_arrow_rounded),
                        ),
                        ButtonSegment(
                          value: false,
                          label: Text('Pause'),
                          icon: Icon(Icons.pause_rounded),
                        ),
                      ],
                      selected: {isAnimating},
                      onSelectionChanged: (Set<bool> newSelection) {
                        final newState = newSelection.first;
                        onAnimatingChanged(newState);
                        if (newState) {
                          controller.start();
                        } else {
                          controller.stop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Size Selection
            _buildControlSection(
              context,
              'Dimensions',
              Wrap(
                spacing: 8,
                children: LoaderSize.values
                    .where((size) => size != LoaderSize.custom)
                    .map((size) => ChoiceChip(
                          label: Text(size.name.toUpperCase()),
                          selected: selectedSize == size,
                          onSelected: (selected) {
                            if (selected) onSizeChanged(size);
                          },
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Color Customization
            _buildControlSection(
              context,
              'Colors',
              Column(
                children: [
                  _buildColorTile(context, 'Primary', primaryColor, onPrimaryColorChanged),
                  if (secondaryColor != null)
                    _buildColorTile(context, 'Secondary', secondaryColor!, onSecondaryColorChanged),
                  if (tertiaryColor != null)
                    _buildColorTile(context, 'Tertiary', tertiaryColor!, onTertiaryColorChanged),
                  if (quaternaryColor != null)
                    _buildColorTile(context, 'Quaternary', quaternaryColor!, onQuaternaryColorChanged),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Duration Slider
            _buildControlSection(
              context,
              'Animation Timing',
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Speed', style: theme.textTheme.bodySmall),
                      Text('${durationMs}ms', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.primary)),
                    ],
                  ),
                  Slider(
                    value: durationMs.toDouble(),
                    min: 500,
                    max: 6000,
                    divisions: 11,
                    onChanged: (v) => onDurationChanged(v.toInt()),
                  ),
                ],
              ),
            ),

            if (showStrokeWidth && strokeWidth != null) ...[
              const SizedBox(height: 16),
              _buildControlSection(
                context,
                'Line Thickness',
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Weight', style: theme.textTheme.bodySmall),
                        Text(strokeWidth!.toStringAsFixed(1), style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.primary)),
                      ],
                    ),
                    Slider(
                      value: strokeWidth!,
                      min: 1.0,
                      max: 10.0,
                      divisions: 9,
                      onChanged: (v) => onStrokeWidthChanged?.call(v),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildControlSection(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.5,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildColorTile(BuildContext context, String label, Color currentColor, Function(Color) onChanged) {
    final Map<String, Color> colorMap = {
      'Blue': Colors.blue,
      'Red': Colors.red,
      'Green': Colors.green,
      'Purple': Colors.purple,
      'Orange': Colors.orange,
      'Teal': Colors.teal,
      'Amber': Colors.amber,
      'Pink': Colors.pinkAccent,
      'Cyan': Colors.cyanAccent,
      'White': Colors.white,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select $label Color', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: colorMap.entries.map((e) => GestureDetector(
                      onTap: () {
                        onChanged(e.value);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: e.value,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                          boxShadow: currentColor == e.value ? [
                            BoxShadow(color: e.value.withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 2)
                          ] : null,
                        ),
                        child: currentColor == e.value ? const Icon(Icons.check, color: Colors.white) : null,
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: currentColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                ),
              ),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, size: 20, color: Theme.of(context).colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
