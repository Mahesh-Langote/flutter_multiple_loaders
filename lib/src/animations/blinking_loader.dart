import 'dart:math';

import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A blinking loader animation.
///
/// This loader displays a shape that blinks at regular intervals,
/// fading in and out completely.
class BlinkingLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// The shape of the blinking element.
  final BlinkingShape shape;

  /// Creates a [BlinkingLoader] with the given options.
  const BlinkingLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
    this.shape = BlinkingShape.circle,
  });

  @override
  State<BlinkingLoader> createState() => _BlinkingLoaderState();
}

/// The different shapes available for the blinking loader.
enum BlinkingShape {
  /// A circle shape.
  circle,

  /// A square shape.
  square,

  /// A triangle shape.
  triangle,

  /// A star shape.
  star,
}

class _BlinkingLoaderState extends State<BlinkingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late LoaderController _loaderController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.2), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.2, end: 1.0), weight: 1),
    ]).animate(
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
  void didUpdateWidget(BlinkingLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options.durationMs != oldWidget.options.durationMs) {
      _animationController.duration = Duration(
        milliseconds: widget.options.durationMs,
      );
    }

    if (widget.options.loop != oldWidget.options.loop) {
      if (widget.options.loop) {
        _animationController.repeat();
      } else {
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    // Always stop the animation before disposing to prevent ticker leaks
    _animationController.stop();
    // Only dispose the controller if it's internally created
    if (widget.controller == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.options.size.value;

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: SizedBox(
            width: size,
            height: size,
            child: _buildShapeWidget(),
          ),
        );
      },
    );
  }

  Widget _buildShapeWidget() {
    final double size = widget.options.size.value;
    final color = widget.options.color;

    switch (widget.shape) {
      case BlinkingShape.circle:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        );
      case BlinkingShape.square:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(size * 0.1),
          ),
        );
      case BlinkingShape.triangle:
        return CustomPaint(
          size: Size(size, size),
          painter: _TrianglePainter(color: color),
        );
      case BlinkingShape.star:
        return CustomPaint(
          size: Size(size, size),
          painter: _StarPainter(color: color),
        );
    }
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) =>
      color != oldDelegate.color;
}

class _StarPainter extends CustomPainter {
  final Color color;

  _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    final Path path = Path();
    const int numPoints = 5;
    const double innerRadiusRatio = 0.4;

    for (int i = 0; i < numPoints * 2; i++) {
      final double currentRadius =
          i.isEven ? radius : radius * innerRadiusRatio;
      final double angle = (i * 2 * 3.14159) / (numPoints * 2) - 3.14159 / 2;
      final double x = centerX + currentRadius * cos(angle);
      final double y = centerY + currentRadius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) => color != oldDelegate.color;
}
