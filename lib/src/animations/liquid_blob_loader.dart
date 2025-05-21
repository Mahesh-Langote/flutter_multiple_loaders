import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A liquid blob loader animation.
///
/// This loader displays an animated morphing liquid blob with a fluid-like motion
/// that creates a mesmerizing organic effect.
class LiquidBlobLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Creates a [LiquidBlobLoader] with the given options.
  const LiquidBlobLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
  });

  @override
  State<LiquidBlobLoader> createState() => _LiquidBlobLoaderState();
}

class _LiquidBlobLoaderState extends State<LiquidBlobLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late LoaderController _loaderController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    _animation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _loaderController = widget.controller ?? LoaderController();
    _loaderController.initialize(_animationController);

    if (widget.options.loop) {
      _animationController.repeat();
    } else {
      _animationController.forward();
    }
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
  void didUpdateWidget(LiquidBlobLoader oldWidget) {
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

    if (widget.controller != oldWidget.controller) {
      _loaderController = widget.controller ?? LoaderController();
      _loaderController.initialize(_animationController);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.options.size.value;

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _LiquidBlobPainter(
              progress: _animationController.value,
              primaryColor: widget.options.color,
              secondaryColor:
                  widget.options.secondaryColor ??
                  HSLColor.fromColor(widget.options.color)
                      .withLightness(
                        (HSLColor.fromColor(widget.options.color).lightness +
                                0.2)
                            .clamp(0.0, 1.0),
                      )
                      .toColor(),
            ),
            size: Size.square(size),
          );
        },
      ),
    );
  }
}

class _LiquidBlobPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  final int pointCount = 8; // Number of control points for the blob

  _LiquidBlobPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Create a gradient for the blob
    final gradient = RadialGradient(
      center: const Alignment(0.2, -0.2), // Light source position
      radius: 0.9,
      colors: [secondaryColor.withOpacity(0.9), primaryColor.withOpacity(0.9)],
      stops: const [0.4, 1.0],
    );

    // Create paint for the blob
    final blobPaint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromCircle(center: center, radius: radius * 1.2),
          )
          ..style = PaintingStyle.fill;

    // Add a slight shadow for depth
    canvas.drawShadow(
      _createBlobPath(center, radius, progress),
      Colors.black26,
      5.0,
      true,
    );

    // Draw the main blob
    canvas.drawPath(_createBlobPath(center, radius, progress), blobPaint);

    // Add highlight reflections with varying opacity
    final highlightPaint1 =
        Paint()
          ..color = Colors.white.withOpacity(0.25)
          ..style = PaintingStyle.fill;

    final highlightPaint2 =
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..style = PaintingStyle.fill;

    // Draw two small highlight blobs that move across the surface
    final highlightOffset1 = Offset(
      math.sin(progress * 2.1) * radius * 0.4,
      math.cos(progress * 1.9) * radius * 0.4,
    );

    final highlightOffset2 = Offset(
      math.sin(progress * 2.7 + 2) * radius * 0.3,
      math.cos(progress * 2.3 + 1) * radius * 0.3,
    );

    // Draw highlight reflections
    canvas.drawCircle(
      center.translate(highlightOffset1.dx, highlightOffset1.dy),
      radius * 0.15,
      highlightPaint1,
    );

    canvas.drawCircle(
      center.translate(highlightOffset2.dx, highlightOffset2.dy),
      radius * 0.08,
      highlightPaint2,
    );
  }

  Path _createBlobPath(Offset center, double radius, double progress) {
    final path = Path();

    // Generate points for the blob shape
    final points = <Offset>[];

    for (int i = 0; i < pointCount; i++) {
      // Base angle for this control point
      final angle = 2 * math.pi * i / pointCount;

      // Calculate a dynamic radius that changes based on time
      // This creates the pulsating, morphing effect
      final dynamicRadius =
          radius *
          (1.0 +
              0.2 * math.sin(progress * 2.0 + angle * 2.0) +
              0.1 * math.cos(progress * 3.0 + angle * 4.0) +
              0.05 * math.sin(progress * 5.0 + angle));

      // Calculate the point position
      final x = center.dx + dynamicRadius * math.cos(angle);
      final y = center.dy + dynamicRadius * math.sin(angle);

      points.add(Offset(x, y));
    }

    // Start the path at the first point
    path.moveTo(points[0].dx, points[0].dy);

    // Draw a smooth curve through all points, closing the shape
    for (int i = 0; i < pointCount; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % pointCount];

      // Calculate control points for a smooth curve
      final controlPoint1 = Offset(
        p1.dx + (p2.dx - points[(i - 1 + pointCount) % pointCount].dx) / 4,
        p1.dy + (p2.dy - points[(i - 1 + pointCount) % pointCount].dy) / 4,
      );

      final controlPoint2 = Offset(
        p2.dx - (points[(i + 2) % pointCount].dx - p1.dx) / 4,
        p2.dy - (points[(i + 2) % pointCount].dy - p1.dy) / 4,
      );

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p2.dx,
        p2.dy,
      );
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_LiquidBlobPainter oldPainter) {
    return progress != oldPainter.progress ||
        primaryColor != oldPainter.primaryColor ||
        secondaryColor != oldPainter.secondaryColor;
  }
}
