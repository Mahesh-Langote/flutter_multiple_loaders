import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A futuristic neon pulse loader animation.
///
/// This loader displays multiple concentric circles with neon glow effects
/// that pulse with different phases and intensities, creating a cyberpunk-style
/// loading animation.
class NeonPulseLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Number of concentric neon rings to display.
  final int ringCount;

  /// Intensity of the neon glow effect.
  final double glowIntensity;

  /// Whether to enable the rainbow color cycling effect.
  final bool enableRainbow;

  /// Creates a [NeonPulseLoader] with the given options.
  const NeonPulseLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
    this.ringCount = 4,
    this.glowIntensity = 3.0,
    this.enableRainbow = false,
  });

  @override
  State<NeonPulseLoader> createState() => _NeonPulseLoaderState();
}

class _NeonPulseLoaderState extends State<NeonPulseLoader>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;
  late List<Animation<double>> _pulseAnimations;
  late List<Animation<double>> _opacityAnimations;
  late Animation<double> _rainbowAnimation;
  late LoaderController _loaderController;

  @override
  void initState() {
    super.initState();

    // Primary controller for the main pulse effect
    _primaryController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    // Secondary controller for color cycling
    _secondaryController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs * 2),
    );

    // Initialize pulse animations for each ring with different phases
    _pulseAnimations = List.generate(widget.ringCount, (index) {
      final phase = index / widget.ringCount;
      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _primaryController,
          curve: Interval(
            phase,
            (phase + 0.7).clamp(0.0, 1.0),
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    // Initialize opacity animations for glow effect
    _opacityAnimations = List.generate(widget.ringCount, (index) {
      final phase = index / widget.ringCount;
      return Tween<double>(begin: 0.1, end: 0.8).animate(
        CurvedAnimation(
          parent: _primaryController,
          curve: Interval(
            phase,
            (phase + 0.8).clamp(0.0, 1.0),
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    // Rainbow color cycling animation
    _rainbowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _secondaryController, curve: Curves.linear),
    );

    _loaderController = widget.controller ?? LoaderController();
    _loaderController.initialize(_primaryController);

    if (widget.options.loop) {
      _primaryController.repeat(reverse: true);
      if (widget.enableRainbow) {
        _secondaryController.repeat();
      }
    } else {
      _primaryController.forward();
    }
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    super.dispose();
  }

  Color _getRingColor(int ringIndex, double rainbowValue) {
    if (widget.enableRainbow) {
      final hue = (rainbowValue * 360 + ringIndex * 60) % 360;
      return HSVColor.fromAHSV(1.0, hue, 0.8, 1.0).toColor();
    }

    // Use gradient colors based on ring index
    final colors = [
      widget.options.color,
      widget.options.secondaryColor ??
          widget.options.color.withValues(alpha: 0.8),
      widget.options.tertiaryColor ??
          widget.options.color.withValues(alpha: 0.6),
    ];

    return colors[ringIndex % colors.length];
  }

  List<BoxShadow> _createNeonGlow(Color color, double intensity) {
    return [
      // Inner glow
      BoxShadow(
        color: color.withValues(alpha: 0.6),
        blurRadius: intensity * 2,
        spreadRadius: 0,
      ),
      // Middle glow
      BoxShadow(
        color: color.withValues(alpha: 0.4),
        blurRadius: intensity * 4,
        spreadRadius: intensity * 0.5,
      ),
      // Outer glow
      BoxShadow(
        color: color.withValues(alpha: 0.2),
        blurRadius: intensity * 8,
        spreadRadius: intensity * 1.5,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_primaryController, _secondaryController]),
      builder: (context, child) {
        return SizedBox(
          width: widget.options.size.value,
          height: widget.options.size.value,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(widget.ringCount, (index) {
              final pulseValue = _pulseAnimations[index].value;
              final opacityValue = _opacityAnimations[index].value;
              final rainbowValue = _rainbowAnimation.value;
              final ringColor = _getRingColor(index, rainbowValue);

              // Calculate ring size based on index and pulse
              final baseSize =
                  widget.options.size.value *
                  (0.2 + (index * 0.2)) *
                  pulseValue;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                width: baseSize,
                height: baseSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ringColor.withValues(alpha: opacityValue),
                    width: widget.options.strokeWidth,
                  ),
                  boxShadow:
                      widget.glowIntensity > 0
                          ? _createNeonGlow(
                            ringColor.withValues(alpha: opacityValue * 0.8),
                            widget.glowIntensity * pulseValue,
                          )
                          : null,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
