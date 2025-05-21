import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A morphing shape loader animation.
///
/// This loader displays an animated shape that smoothly transitions between
/// different geometric forms (circle, square, triangle, pentagon, etc.).
class MorphingShapeLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Creates a [MorphingShapeLoader] with the given options.
  const MorphingShapeLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
  });

  @override
  State<MorphingShapeLoader> createState() => _MorphingShapeLoaderState();
}

class _MorphingShapeLoaderState extends State<MorphingShapeLoader>
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

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
  void didUpdateWidget(MorphingShapeLoader oldWidget) {
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
            painter: _MorphingShapePainter(
              animation: _animation.value,
              color: widget.options.color,
              secondaryColor: widget.options.secondaryColor,
              tertiaryColor: widget.options.tertiaryColor,
              strokeWidth: widget.options.strokeWidth,
              backgroundColor: widget.options.backgroundColor,
            ),
          ),
        );
      },
    );
  }
}

class _MorphingShapePainter extends CustomPainter {
  final double animation;
  final Color color;
  final Color? secondaryColor;
  final Color? tertiaryColor;
  final double strokeWidth;
  final Color? backgroundColor;

  _MorphingShapePainter({
    required this.animation,
    required this.color,
    this.secondaryColor,
    this.tertiaryColor,
    required this.strokeWidth,
    this.backgroundColor,
  });

  // Define the shapes to morph between
  // The values in the list represent the number of sides
  // (3 = triangle, 4 = square, 5 = pentagon, etc. with 0 representing a circle)
  final List<int> _shapes = [
    0,
    4,
    3,
    5,
    6,
  ]; // Circle, Square, Triangle, Pentagon, Hexagon

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double centerX = width / 2;
    final double centerY = height / 2;
    final double radius = (width / 2) - strokeWidth;

    // Determine which two shapes we're morphing between
    final int totalShapes = _shapes.length;
    final double animationStep = 1 / totalShapes;
    final int currentShapeIndex =
        (animation / animationStep).floor() % totalShapes;
    final int nextShapeIndex = (currentShapeIndex + 1) % totalShapes;

    // Calculate the morphing progress between the two shapes
    final double morphProgress = (animation % animationStep) / animationStep;

    // Get the current and next shape sides count
    final int currentShapeSides = _shapes[currentShapeIndex];
    final int nextShapeSides =
        _shapes[nextShapeIndex]; // Calculate the current effective number of sides (can be fractional during animation)
    int effectiveSides;

    // Special case for morphing to/from circle
    if (currentShapeSides == 0 || nextShapeSides == 0) {
      // When morphing to a circle, we keep the number of sides but make them increasingly curved
      effectiveSides =
          currentShapeSides == 0 ? nextShapeSides : currentShapeSides;
    } else {
      // Linear interpolation between the number of sides
      effectiveSides =
          (currentShapeSides +
                  (nextShapeSides - currentShapeSides) * morphProgress)
              .round();
    }

    // Create shader for gradient if secondary color is specified
    Paint paint =
        Paint()
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    if (secondaryColor != null) {
      // Create a rotating gradient
      final double gradientAngle = animation * 2 * math.pi;
      final Offset gradientStart = Offset(
        centerX + radius * 0.7 * math.cos(gradientAngle),
        centerY + radius * 0.7 * math.sin(gradientAngle),
      );
      final Offset gradientEnd = Offset(
        centerX + radius * 0.7 * math.cos(gradientAngle + math.pi),
        centerY + radius * 0.7 * math.sin(gradientAngle + math.pi),
      );

      paint.shader = LinearGradient(
        colors: [color, secondaryColor ?? color, tertiaryColor ?? color],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromPoints(gradientStart, gradientEnd));
    } else {
      paint.color = color;
    }

    // Draw background if specified
    if (backgroundColor != null) {
      final Paint bgPaint =
          Paint()
            ..color = backgroundColor!
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(centerX, centerY),
        radius + strokeWidth / 2,
        bgPaint,
      );
    }

    // Draw the morphing shape
    final Path path = Path();

    if (currentShapeSides == 0 || nextShapeSides == 0) {
      // Handle morphing to/from circle - use control points to adjust curvature

      // Circle shape with rounded corners
      final int sides =
          effectiveSides.round() == 0 ? 24 : effectiveSides.round();
      final double circleInterpolation =
          currentShapeSides == 0 ? 1.0 - morphProgress : morphProgress;

      final double angleStep = 2 * math.pi / sides;

      for (int i = 0; i < sides; i++) {
        final double angle = i * angleStep - math.pi / sides;
        final double nextAngle = (i + 1) * angleStep - math.pi / sides;

        final double x = centerX + radius * math.cos(angle);
        final double y = centerY + radius * math.sin(angle);

        final double nextX = centerX + radius * math.cos(nextAngle);
        final double nextY = centerY + radius * math.sin(nextAngle);

        // Calculate control points for cubic curve
        // The closer circleInterpolation is to 1, the more circular the shape
        final double controlDistance =
            radius * 0.552284749831 * circleInterpolation;

        final double ctrl1X = x - controlDistance * math.sin(angle);
        final double ctrl1Y = y + controlDistance * math.cos(angle);

        final double ctrl2X = nextX + controlDistance * math.sin(nextAngle);
        final double ctrl2Y = nextY - controlDistance * math.cos(nextAngle);

        if (i == 0) {
          path.moveTo(x, y);
        }

        path.cubicTo(ctrl1X, ctrl1Y, ctrl2X, ctrl2Y, nextX, nextY);
      }
    } else {
      // Regular polygon morphing
      final int sides = math.max(3, effectiveSides); // Minimum 3 sides
      final double startAngle = animation * 2 * math.pi; // Rotation effect
      final double angleStep = 2 * math.pi / sides;

      for (int i = 0; i < sides; i++) {
        final double angle = startAngle + i * angleStep;
        final double x = centerX + radius * math.cos(angle);
        final double y = centerY + radius * math.sin(angle);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
    }

    // Apply a rotation for more dynamic animation
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(animation * math.pi);
    canvas.translate(-centerX, -centerY);

    // Draw the shape
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_MorphingShapePainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.color != color ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.tertiaryColor != tertiaryColor ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.backgroundColor != backgroundColor;
}
