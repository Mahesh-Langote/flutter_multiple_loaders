import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A heartbeat loader animation.
///
/// This loader displays a pulsing heart shape that simulates a heartbeat pattern,
/// with customizable beat speed and heart color.
class HeartbeatLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// The intensity of the heartbeat pulse (0.1 to 1.0).
  final double pulseIntensity;

  /// Creates a [HeartbeatLoader] with the given options.
  const HeartbeatLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
    this.pulseIntensity = 0.3,
  });

  @override
  State<HeartbeatLoader> createState() => _HeartbeatLoaderState();
}

class _HeartbeatLoaderState extends State<HeartbeatLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late LoaderController _loaderController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    _initializeAnimations();

    _loaderController = widget.controller ?? LoaderController();
    _loaderController.initialize(_animationController);

    if (widget.options.loop) {
      _animationController.repeat();
    } else {
      _animationController.forward();
    }
  }

  void _initializeAnimations() {
    // Create a heartbeat pattern: quick double beat followed by pause
    _scaleAnimation = TweenSequence<double>([
      // First beat
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.0 + widget.pulseIntensity,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0 + widget.pulseIntensity,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      // Short pause
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 5),
      // Second beat (slightly smaller)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.0 + widget.pulseIntensity * 0.7,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0 + widget.pulseIntensity * 0.7,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      // Long pause
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 45),
    ]).animate(_animationController);

    // Opacity animation to enhance the heartbeat effect
    _opacityAnimation = TweenSequence<double>([
      // First beat glow
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      // Short pause
      TweenSequenceItem(tween: ConstantTween<double>(0.8), weight: 5),
      // Second beat glow
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.8,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.95,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      // Long pause
      TweenSequenceItem(tween: ConstantTween<double>(0.8), weight: 45),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.stop();
    if (widget.controller == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(HeartbeatLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.options.durationMs != widget.options.durationMs) {
      _animationController.duration = Duration(
        milliseconds: widget.options.durationMs,
      );
    }

    if (oldWidget.options.loop != widget.options.loop) {
      if (widget.options.loop) {
        _animationController.repeat();
      } else {
        _animationController.forward();
      }
    }

    if (oldWidget.pulseIntensity != widget.pulseIntensity) {
      _initializeAnimations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.options.size.value;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: CustomPaint(
                  size: Size(size * 0.8, size * 0.8),
                  painter: _HeartPainter(
                    color: widget.options.color,
                    strokeWidth: widget.options.strokeWidth,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Custom painter to draw a heart shape
class _HeartPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _HeartPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill
          ..strokeWidth = strokeWidth;

    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create heart shape using parametric equations
    // Heart shape: x = 16sin³(t), y = 13cos(t) - 5cos(2t) - 2cos(3t) - cos(4t)
    final centerX = width / 2;
    final centerY = height / 2;
    final scale = math.min(width, height) / 40;

    for (double t = 0; t <= 2 * math.pi; t += 0.1) {
      final x = centerX + scale * 16 * math.pow(math.sin(t), 3);
      final y =
          centerY -
          scale *
              (13 * math.cos(t) -
                  5 * math.cos(2 * t) -
                  2 * math.cos(3 * t) -
                  math.cos(4 * t));

      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);

    // Add a subtle glow effect
    if (strokeWidth > 0) {
      final glowPaint =
          Paint()
            ..color = color.withValues(alpha: 0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth * 2
            ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3);

      canvas.drawPath(path, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _HeartPainter ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
