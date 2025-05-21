import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A glowing loader animation.
///
/// This loader displays a circle with a pulsing glow effect and
/// optional gradient colors for a more dynamic visual effect.
class GlowingLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Creates a [GlowingLoader] with the given options.
  const GlowingLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
  });

  @override
  State<GlowingLoader> createState() => _GlowingLoaderState();
}

class _GlowingLoaderState extends State<GlowingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late LoaderController _loaderController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 2.0, end: 15.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loaderController = widget.controller ?? LoaderController();
    _loaderController.initialize(_animationController);

    if (widget.options.loop) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    // Stop the animation before disposing
    _animationController.stop();
    // Only dispose the controller if we created it internally
    if (widget.controller == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(GlowingLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animation duration if it changed
    if (oldWidget.options.durationMs != widget.options.durationMs) {
      _animationController.duration = Duration(
        milliseconds: widget.options.durationMs,
      );
    }

    // Handle loop state changes
    if (oldWidget.options.loop != widget.options.loop) {
      if (widget.options.loop) {
        _animationController.repeat(reverse: true);
      } else if (_animationController.isAnimating) {
        // Only forward if animating, otherwise keep current state
        _animationController.forward();
      }
    }

    // If we switched from non-loop to loop and animation completed, restart it
    if (widget.options.loop &&
        !oldWidget.options.loop &&
        _animationController.status == AnimationStatus.completed) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.options.size.value;
    final secondaryColor =
        widget.options.secondaryColor ??
        widget.options.color.withValues(alpha: 0.7);
    final tertiaryColor =
        widget.options.tertiaryColor ??
        widget.options.color.withValues(alpha: 0.3);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Transform.scale(
              scale: _pulseAnimation.value,
              child: CustomPaint(
                painter: _GlowingPainter(
                  color: widget.options.color,
                  secondaryColor: secondaryColor,
                  tertiaryColor: tertiaryColor,
                  glowRadius: _glowAnimation.value,
                  backgroundColor: widget.options.backgroundColor,
                ),
                size: Size(size * 0.8, size * 0.8),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GlowingPainter extends CustomPainter {
  final Color color;
  final Color secondaryColor;
  final Color tertiaryColor;
  final double glowRadius;
  final Color? backgroundColor;

  _GlowingPainter({
    required this.color,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.glowRadius,
    this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the outer glow
    final outerGlowPaint =
        Paint()
          ..color = tertiaryColor
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);
    canvas.drawCircle(center, radius, outerGlowPaint);

    // Draw the inner glow
    final innerGlowPaint =
        Paint()
          ..color = secondaryColor
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius / 2);
    canvas.drawCircle(center, radius * 0.85, innerGlowPaint);

    // Draw the main circle with gradient
    final mainCirclePaint =
        Paint()
          ..shader = RadialGradient(
            colors: [color, secondaryColor],
            stops: const [0.5, 1.0],
            center: Alignment.center,
            radius: 0.8,
          ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius * 0.7, mainCirclePaint);

    // Draw background circle if specified
    if (backgroundColor != null) {
      final backgroundPaint =
          Paint()
            ..color = backgroundColor!
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, backgroundPaint);
    }
  }

  @override
  bool shouldRepaint(_GlowingPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.tertiaryColor != tertiaryColor ||
      oldDelegate.glowRadius != glowRadius ||
      oldDelegate.backgroundColor != backgroundColor;
}
