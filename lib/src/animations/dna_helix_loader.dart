import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A DNA helix animation loader.
///
/// This loader displays two intertwining sine waves that rotate to create
/// a 3D DNA helix effect with connecting "rungs" between the strands.
class DnaHelixLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Creates a [DnaHelixLoader] with the given options.
  const DnaHelixLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
  });

  @override
  State<DnaHelixLoader> createState() => _DnaHelixLoaderState();
}

class _DnaHelixLoaderState extends State<DnaHelixLoader>
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
  void didUpdateWidget(DnaHelixLoader oldWidget) {
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
            painter: _DnaHelixPainter(
              animation: _animation.value,
              primaryColor: widget.options.color,
              secondaryColor:
                  widget.options.secondaryColor ??
                  widget.options.color.withValues(alpha: 0.7),
              strokeWidth: widget.options.strokeWidth,
              backgroundColor: widget.options.backgroundColor,
            ),
          ),
        );
      },
    );
  }
}

class _DnaHelixPainter extends CustomPainter {
  final double animation;
  final Color primaryColor;
  final Color secondaryColor;
  final double strokeWidth;
  final Color? backgroundColor;

  // Number of base pairs (rungs) to draw
  final int basePairs = 8;

  _DnaHelixPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
    required this.strokeWidth,
    this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double centerX = width / 2;

    // Draw background if specified
    if (backgroundColor != null) {
      final Paint backgroundPaint =
          Paint()
            ..color = backgroundColor!
            ..style = PaintingStyle.fill;

      canvas.drawRect(Rect.fromLTWH(0, 0, width, height), backgroundPaint);
    }

    // Paints for the strands
    final Paint strand1Paint =
        Paint()
          ..color = primaryColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final Paint strand2Paint =
        Paint()
          ..color = secondaryColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    // Paint for the base pairs (rungs)
    final Paint rungPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * 0.5
          ..strokeCap = StrokeCap.round;

    // Calculate amplitude and period
    final double amplitude = width * 0.2;
    final double verticalSpacing = height / (basePairs + 1);

    // Draw the connecting rungs and DNA strands
    for (int i = 1; i <= basePairs; i++) {
      final double y = i * verticalSpacing;
      final double phaseShift = animation + (i / basePairs * math.pi);

      // Calculate x positions for the two strands at this y position
      final double x1 = centerX + amplitude * math.sin(phaseShift);
      final double x2 = centerX + amplitude * math.sin(phaseShift + math.pi);

      // Draw the connecting rung (base pair)
      canvas.drawLine(Offset(x1, y), Offset(x2, y), rungPaint);

      // Draw segments of the strands
      if (i > 1) {
        final double prevY = (i - 1) * verticalSpacing;
        final double prevPhaseShift =
            animation + ((i - 1) / basePairs * math.pi);

        final double prevX1 = centerX + amplitude * math.sin(prevPhaseShift);
        final double prevX2 =
            centerX + amplitude * math.sin(prevPhaseShift + math.pi);

        // Draw strand segments
        canvas.drawLine(Offset(prevX1, prevY), Offset(x1, y), strand1Paint);

        canvas.drawLine(Offset(prevX2, prevY), Offset(x2, y), strand2Paint);
      }

      // For the first and last points, add caps to the strands
      if (i == 1 || i == basePairs) {
        final double radius = strokeWidth * 0.8;

        if (i == 1) {
          canvas.drawCircle(Offset(x1, y), radius, strand1Paint);
          canvas.drawCircle(Offset(x2, y), radius, strand2Paint);
        }

        if (i == basePairs) {
          canvas.drawCircle(Offset(x1, y), radius, strand1Paint);
          canvas.drawCircle(Offset(x2, y), radius, strand2Paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_DnaHelixPainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.backgroundColor != backgroundColor;
}
