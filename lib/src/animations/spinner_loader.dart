import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A spinning loader animation.
///
/// This loader displays a spinning circle that rotates continuously.
class SpinnerLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Creates a [SpinnerLoader] with the given options.
  const SpinnerLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
  });

  @override
  State<SpinnerLoader> createState() => _SpinnerLoaderState();
}

class _SpinnerLoaderState extends State<SpinnerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late LoaderController _loaderController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
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
    // Stop the animation before disposing
    _animationController.stop();
    // Only dispose the controller if we created it internally
    if (widget.controller == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(SpinnerLoader oldWidget) {
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
        _animationController.repeat();
      } else if (_animationController.isAnimating) {
        // Only forward if animating, otherwise keep current state
        _animationController.forward();
      }
    }

    // If we switched from non-loop to loop and animation completed, restart it
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
            painter: _SpinnerPainter(
              animation: _rotationAnimation.value,
              color: widget.options.color,
              strokeWidth: widget.options.strokeWidth,
              backgroundColor: widget.options.backgroundColor,
            ),
          ),
        );
      },
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final double animation;
  final Color color;
  final double strokeWidth;
  final Color? backgroundColor;

  _SpinnerPainter({
    required this.animation,
    required this.color,
    required this.strokeWidth,
    this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint =
        Paint()
          ..color = backgroundColor ?? Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    final Paint foregroundPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final double center = size.width / 2;
    final double radius = (size.width - strokeWidth) / 2;

    // Draw background circle if specified
    if (backgroundColor != null) {
      canvas.drawCircle(Offset(center, center), radius, backgroundPaint);
    }

    // Draw the spinning arc
    final rect = Rect.fromCircle(
      center: Offset(center, center),
      radius: radius,
    );

    // Rotate the canvas
    canvas.save();
    canvas.translate(center, center);
    canvas.rotate(animation);
    canvas.translate(-center, -center);

    // Draw the arc
    canvas.drawArc(rect, 0, math.pi, false, foregroundPaint);

    // Restore the canvas
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.backgroundColor != backgroundColor;
}
