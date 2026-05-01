import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A classic analog clock loader animation.
///
/// This loader displays a clock face with rotating hour and minute hands,
/// creating a "time-lapse" effect that indicates loading progress.
class ClockLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Creates a [ClockLoader] with the given options.
  const ClockLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
  });

  @override
  State<ClockLoader> createState() => _ClockLoaderState();
}

class _ClockLoaderState extends State<ClockLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late LoaderController _loaderController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
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
  Widget build(BuildContext context) {
    final size = widget.options.size.value;

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          // Minute hand completes 12 full rotations per cycle
          final minuteAngle = _animationController.value * 2 * math.pi * 12;
          // Hour hand completes 1 full rotation per cycle
          final hourAngle = _animationController.value * 2 * math.pi;

          return CustomPaint(
            painter: _ClockPainter(
              color: widget.options.color,
              secondaryColor:
                  widget.options.secondaryColor ??
                  widget.options.color.withValues(alpha: 0.5),
              minuteAngle: minuteAngle,
              hourAngle: hourAngle,
              strokeWidth: widget.options.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final Color color;
  final Color secondaryColor;
  final double minuteAngle;
  final double hourAngle;
  final double strokeWidth;

  _ClockPainter({
    required this.color,
    required this.secondaryColor,
    required this.minuteAngle,
    required this.hourAngle,
    this.strokeWidth = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;

    // Clock face
    final facePaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, facePaint);

    // Clock border
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, borderPaint);

    // Tick marks (12 major ticks)
    final tickPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = strokeWidth * 0.6
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * math.pi - math.pi / 2;
      final outerPoint = Offset(
        center.dx + radius * 0.9 * math.cos(angle),
        center.dy + radius * 0.9 * math.sin(angle),
      );
      final innerPoint = Offset(
        center.dx + radius * 0.75 * math.cos(angle),
        center.dy + radius * 0.75 * math.sin(angle),
      );
      canvas.drawLine(innerPoint, outerPoint, tickPaint);
    }

    // Hour hand (shorter, thicker)
    final hourHandLength = radius * 0.5;
    final hourPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth * 1.8
      ..strokeCap = StrokeCap.round;

    final hourEnd = Offset(
      center.dx + hourHandLength * math.cos(hourAngle - math.pi / 2),
      center.dy + hourHandLength * math.sin(hourAngle - math.pi / 2),
    );
    canvas.drawLine(center, hourEnd, hourPaint);

    // Minute hand (longer, thinner)
    final minuteHandLength = radius * 0.72;
    final minutePaint = Paint()
      ..color = secondaryColor
      ..strokeWidth = strokeWidth * 1.2
      ..strokeCap = StrokeCap.round;

    final minuteEnd = Offset(
      center.dx + minuteHandLength * math.cos(minuteAngle - math.pi / 2),
      center.dy + minuteHandLength * math.sin(minuteAngle - math.pi / 2),
    );
    canvas.drawLine(center, minuteEnd, minutePaint);

    // Center dot
    final centerDotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, strokeWidth * 1.5, centerDotPaint);
  }

  @override
  bool shouldRepaint(_ClockPainter oldDelegate) {
    return oldDelegate.minuteAngle != minuteAngle ||
        oldDelegate.hourAngle != hourAngle ||
        oldDelegate.color != color ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
