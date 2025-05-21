import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A galaxy spiral loader animation.
///
/// This loader displays an animated spiral galaxy with particles rotating
/// around a central point with a glowing core effect.
class GalaxySpiralLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Creates a [GalaxySpiralLoader] with the given options.
  const GalaxySpiralLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
  });

  @override
  State<GalaxySpiralLoader> createState() => _GalaxySpiralLoaderState();
}

class _GalaxySpiralLoaderState extends State<GalaxySpiralLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late LoaderController _loaderController;

  // For generating random star positions
  final math.Random _random = math.Random();
  late List<_StarParticle> _stars;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _loaderController = widget.controller ?? LoaderController();
    _loaderController.initialize(_animationController);

    // Generate random stars
    _initializeStars();

    if (widget.options.loop) {
      _animationController.repeat();
    } else {
      _animationController.forward();
    }
  }

  void _initializeStars() {
    // Create a collection of star particles with random attributes
    _stars = List<_StarParticle>.generate(
      100, // Number of stars
      (_) => _StarParticle(
        distance:
            0.1 +
            _random.nextDouble() * 0.9, // Distance from center (0.1 to 1.0)
        angle: _random.nextDouble() * 2 * math.pi, // Initial angle
        brightness: 0.3 + _random.nextDouble() * 0.7, // Star brightness
        size: 1.0 + _random.nextDouble() * 3.0, // Star size
        angularVelocity:
            0.2 + _random.nextDouble() * 0.8, // How fast the star rotates
        armOffset:
            _random.nextDouble() *
            2 *
            math.pi /
            3, // Offset to create spiral arms
      ),
    );
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
  void didUpdateWidget(GalaxySpiralLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.options.durationMs != widget.options.durationMs) {
      _animationController.duration = Duration(
        milliseconds: widget.options.durationMs,
      );
    }

    if (oldWidget.options.loop != widget.options.loop) {
      if (widget.options.loop) {
        _animationController.repeat();
      } else if (_animationController.isAnimating) {
        _animationController.forward();
      }
    }

    if (widget.options.loop &&
        !oldWidget.options.loop &&
        _animationController.status == AnimationStatus.completed) {
      _animationController.repeat();
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
          child: CustomPaint(
            painter: _GalaxySpiralPainter(
              animation: _animation.value,
              primaryColor: widget.options.color,
              secondaryColor:
                  widget.options.secondaryColor ??
                  widget.options.color.withOpacity(0.6),
              tertiaryColor: widget.options.tertiaryColor,
              backgroundColor: widget.options.backgroundColor,
              stars: _stars,
            ),
          ),
        );
      },
    );
  }
}

/// A data class representing a star particle in the galaxy animation
class _StarParticle {
  /// Distance from the center (0.0 to 1.0)
  final double distance;

  /// Initial angle in radians
  final double angle;

  /// Star brightness (0.0 to 1.0)
  final double brightness;

  /// Star size in pixels
  final double size;

  /// How fast the star rotates (angular velocity multiplier)
  final double angularVelocity;

  /// Offset for the spiral arm effect
  final double armOffset;

  _StarParticle({
    required this.distance,
    required this.angle,
    required this.brightness,
    required this.size,
    required this.angularVelocity,
    required this.armOffset,
  });
}

class _GalaxySpiralPainter extends CustomPainter {
  final double animation;
  final Color primaryColor;
  final Color secondaryColor;
  final Color? tertiaryColor;
  final Color? backgroundColor;
  final List<_StarParticle> stars;

  _GalaxySpiralPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
    this.tertiaryColor,
    this.backgroundColor,
    required this.stars,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double centerX = width / 2;
    final double centerY = height / 2;
    final double radius = math.min(width, height) / 2;

    // Draw background if specified
    if (backgroundColor != null) {
      final Paint backgroundPaint =
          Paint()
            ..color = backgroundColor!
            ..style = PaintingStyle.fill;

      canvas.drawRect(Rect.fromLTWH(0, 0, width, height), backgroundPaint);
    }

    // Draw the glowing central core
    final double coreSize = radius * 0.2;
    final double pulseScale =
        0.8 + 0.2 * math.sin(animation * math.pi * 4); // Pulsing effect

    // Draw outer glow
    final Paint glowPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..shader = RadialGradient(
            colors: [
              tertiaryColor ?? primaryColor.withOpacity(0.8 * pulseScale),
              primaryColor.withOpacity(0.0),
            ],
            stops: const [0.0, 1.0],
          ).createShader(
            Rect.fromCircle(
              center: Offset(centerX, centerY),
              radius: coreSize * 3.0,
            ),
          );

    canvas.drawCircle(Offset(centerX, centerY), coreSize * 3.0, glowPaint);

    // Draw bright core
    final Paint corePaint =
        Paint()
          ..color = (tertiaryColor ?? primaryColor).withOpacity(
            0.9 * pulseScale,
          )
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    canvas.drawCircle(
      Offset(centerX, centerY),
      coreSize * pulseScale,
      corePaint,
    );

    // Draw inner bright core
    final Paint innerCorePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.9 * pulseScale)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX, centerY),
      coreSize * 0.5 * pulseScale,
      innerCorePaint,
    );

    // Draw spiral arms and stars
    final double baseRotation =
        animation * 2 * math.pi / 8; // Base rotation speed

    for (final star in stars) {
      // Calculate spiral arm effect
      // The further from center, the more the star gets pulled into the spiral
      final double spiralFactor =
          2.0 * math.pi * star.distance * star.distance; // Quadratic spiral
      final double spiralOffset = spiralFactor + star.armOffset;

      // Calculate current angle with rotation
      final double currentAngle =
          star.angle + baseRotation * star.angularVelocity + spiralOffset;

      // Calculate position
      final double adjustedDistance = star.distance * radius;
      final double x = centerX + adjustedDistance * math.cos(currentAngle);
      final double y = centerY + adjustedDistance * math.sin(currentAngle);

      // Calculate star opacity based on distance and angle to create spiral arm effect
      final double opacity =
          star.brightness *
          (0.2 +
              0.8 *
                  math.pow(
                    math.sin(currentAngle * 2 + star.armOffset).abs(),
                    0.3,
                  ));

      // Star color changes from center to edge
      final Color starColor = Color.lerp(
        primaryColor,
        secondaryColor,
        star.distance,
      )!.withOpacity(opacity);

      // Draw star with glow
      final Paint starPaint =
          Paint()
            ..color = starColor
            ..style = PaintingStyle.fill
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.size * 0.5);

      canvas.drawCircle(
        Offset(x, y),
        star.size * (0.5 + 0.5 * opacity),
        starPaint,
      );

      // Draw bright center of the star
      final Paint starCenterPaint =
          Paint()
            ..color = Colors.white.withOpacity(opacity * 0.8)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        star.size * 0.3 * opacity,
        starCenterPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GalaxySpiralPainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.tertiaryColor != tertiaryColor ||
      oldDelegate.backgroundColor != backgroundColor;
}
