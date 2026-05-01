import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A classic hourglass loader animation.
///
/// This loader displays an hourglass shape that flips periodically,
/// simulating the classic "waiting" hourglass icon.
class HourglassLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Creates a [HourglassLoader] with the given options.
  const HourglassLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
  });

  @override
  State<HourglassLoader> createState() => _HourglassLoaderState();
}

class _HourglassLoaderState extends State<HourglassLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _sandAnimation;
  late LoaderController _loaderController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    // Rotation: 0 -> pi (flip 180°) with a pause at start/end
    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30, // pause at top
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: math.pi)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40, // flip
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: math.pi, end: math.pi)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30, // pause at bottom
      ),
    ]).animate(_animationController);

    // Sand falling: simulates the fill level in the bottom bulb
    _sandAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30, // sand drains before flip
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 40, // mid-flip
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30, // after flip; next cycle refills
      ),
    ]).animate(_animationController);

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
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationZ(_rotationAnimation.value),
            child: CustomPaint(
              painter: _HourglassPainter(
                color: widget.options.color,
                secondaryColor:
                    widget.options.secondaryColor ??
                    widget.options.color.withValues(alpha: 0.3),
                sandLevel: _sandAnimation.value,
                strokeWidth: widget.options.strokeWidth,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HourglassPainter extends CustomPainter {
  final Color color;
  final Color secondaryColor;
  final double sandLevel;
  final double strokeWidth;

  _HourglassPainter({
    required this.color,
    required this.secondaryColor,
    required this.sandLevel,
    this.strokeWidth = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // ── Key geometry ──────────────────────────────────────────
    // Top rim, bottom rim
    final topY = h * 0.06;
    final botY = h * 0.94;
    // Half-width of the wide rims
    final rimHW = w * 0.38;
    // Half-width of the narrow waist
    final waistHW = w * 0.06;
    final waistY = h * 0.5;

    // Control-point "pull" amount – drives the curve depth
    final cpPull = h * 0.18;

    // ── Build smooth hourglass path (left side then right side) ──
    final path = Path();

    // Start at top-left corner (with a small rounded cap)
    path.moveTo(cx - rimHW, topY);

    // Top arc across the rim (subtle curve inward)
    path.quadraticBezierTo(cx, topY - h * 0.02, cx + rimHW, topY);

    // Right side: top rim → waist (cubic inward curve)
    path.cubicTo(
      cx + rimHW, topY + cpPull, // cp1: stays wide near top
      cx + waistHW, waistY - cpPull * 0.3, // cp2: tightens near waist
      cx + waistHW, waistY, // waist right
    );

    // Right side: waist → bottom rim
    path.cubicTo(
      cx + waistHW, waistY + cpPull * 0.3, // cp1: leaves waist
      cx + rimHW, botY - cpPull, // cp2: spreads near bottom
      cx + rimHW, botY, // bottom-right corner
    );

    // Bottom arc across the rim
    path.quadraticBezierTo(cx, botY + h * 0.02, cx - rimHW, botY);

    // Left side: bottom rim → waist
    path.cubicTo(
      cx - rimHW, botY - cpPull,
      cx - waistHW, waistY + cpPull * 0.3,
      cx - waistHW, waistY,
    );

    // Left side: waist → top rim
    path.cubicTo(
      cx - waistHW, waistY - cpPull * 0.3,
      cx - rimHW, topY + cpPull,
      cx - rimHW, topY,
    );

    path.close();

    // ── Clip canvas to hourglass shape ────────────────────────
    canvas.save();
    canvas.clipPath(path);

    // ── Background fill ───────────────────────────────────────
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.07)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, bgPaint);

    // ── Sand in top bulb (draining downward) ─────────────────
    if (sandLevel > 0.0) {
      // The top bulb spans topY → waistY.
      // We fill from the bottom of the top bulb upward by sandLevel.
      final fillTop = topY + (waistY - topY) * (1.0 - sandLevel);

      final sandPath = Path()
        ..moveTo(0, fillTop)
        ..lineTo(w, fillTop)
        ..lineTo(w, waistY)
        ..lineTo(0, waistY)
        ..close();

      canvas.drawPath(
        sandPath,
        Paint()
          ..color = secondaryColor
          ..style = PaintingStyle.fill,
      );
    }

    // ── Sand in bottom bulb (filling upward) ─────────────────
    final bottomFill = 1.0 - sandLevel;
    if (bottomFill > 0.0) {
      final fillTop = botY - (botY - waistY) * bottomFill;

      final sandPath = Path()
        ..moveTo(0, fillTop)
        ..lineTo(w, fillTop)
        ..lineTo(w, botY)
        ..lineTo(0, botY)
        ..close();

      canvas.drawPath(
        sandPath,
        Paint()
          ..color = secondaryColor
          ..style = PaintingStyle.fill,
      );
    }

    canvas.restore();

    // ── Outline on top (drawn after clip restore) ─────────────
    final outlinePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, outlinePaint);

    // ── Sand stream at the waist ──────────────────────────────
    if (sandLevel > 0.04) {
      final streamPaint = Paint()
        ..color = color.withValues(alpha: 0.55)
        ..strokeWidth = strokeWidth * 0.7
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(cx, waistY - 4),
        Offset(cx, waistY + h * 0.06),
        streamPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_HourglassPainter oldDelegate) {
    return oldDelegate.sandLevel != sandLevel ||
        oldDelegate.color != color ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

