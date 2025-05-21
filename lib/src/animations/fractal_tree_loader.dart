import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A fractal tree loader animation.
///
/// This loader displays an animated fractal tree that grows and branches,
/// creating a beautiful organic pattern inspired by nature.
class FractalTreeLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Creates a [FractalTreeLoader] with the given options.
  const FractalTreeLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
  });

  @override
  State<FractalTreeLoader> createState() => _FractalTreeLoaderState();
}

class _FractalTreeLoaderState extends State<FractalTreeLoader>
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
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
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
    _animationController.stop();
    if (widget.controller == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(FractalTreeLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.options.durationMs != widget.options.durationMs) {
      _animationController.duration = Duration(
        milliseconds: widget.options.durationMs,
      );
    }

    if (oldWidget.options.loop != widget.options.loop) {
      if (widget.options.loop) {
        _animationController.repeat(reverse: true);
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
            painter: _FractalTreePainter(
              progress: _animation.value,
              primaryColor: widget.options.color,
              secondaryColor:
                  widget.options.secondaryColor ??
                  widget.options.color.withOpacity(0.7),
              strokeWidth: widget.options.strokeWidth,
            ),
            size: Size.square(size),
          );
        },
      ),
    );
  }
}

class _FractalTreePainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  final double strokeWidth;
  final int maxDepth = 9;

  _FractalTreePainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Set up initial trunk position at the bottom center of the canvas
    final startX = size.width / 2;
    final startY = size.height * 0.9;
    final initialLength = size.height * 0.4;

    // Calculate maximum progress based on depth to animate the tree growth
    final effectiveDepth = (maxDepth * progress).round();
    final remainderProgress = (maxDepth * progress) - effectiveDepth;

    // Draw the trunk and branches recursively
    _drawBranch(
      canvas,
      Offset(startX, startY),
      -math.pi / 2, // Start growing upward
      initialLength,
      effectiveDepth,
      remainderProgress,
      0, // Current depth
      strokeWidth,
    );

    // Draw a subtle ground/shadow effect
    final groundPaint =
        Paint()
          ..color = primaryColor.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.9 + 5),
        width: initialLength * 0.4,
        height: initialLength * 0.1,
      ),
      groundPaint,
    );
  }

  void _drawBranch(
    Canvas canvas,
    Offset start,
    double angle,
    double length,
    int effectiveDepth,
    double remainderProgress,
    int currentDepth,
    double branchWidth,
  ) {
    // Exit if we've reached our animation's depth limit
    if (currentDepth > effectiveDepth) {
      return;
    }

    // Calculate end point of this branch
    final endX = start.dx + length * math.cos(angle);
    final endY = start.dy + length * math.sin(angle);
    final end = Offset(endX, endY);

    // Interpolate color between primary and secondary based on depth
    final branchProgress = currentDepth / maxDepth;
    final color = Color.lerp(primaryColor, secondaryColor, branchProgress)!;

    // Make branches thinner as they get higher in the tree
    final actualBranchWidth = branchWidth * (1 - branchProgress * 0.7);

    // Create a paint with the appropriate color and width
    final branchPaint =
        Paint()
          ..color = color
          ..strokeWidth = actualBranchWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    // Draw this branch
    if (currentDepth == effectiveDepth) {
      // For the currently growing branches, apply partial growth
      final partialEnd = Offset(
        start.dx + (end.dx - start.dx) * remainderProgress,
        start.dy + (end.dy - start.dy) * remainderProgress,
      );
      canvas.drawLine(start, partialEnd, branchPaint);
    } else {
      canvas.drawLine(start, end, branchPaint);
    }

    // If we've reached our depth limit for this iteration, stop recursion
    if (currentDepth >= effectiveDepth) {
      return;
    }

    // Recursive calls for branches with reduced length and modified angles
    // Left branch (adjust angle by a random factor for organic look)
    _drawBranch(
      canvas,
      end,
      angle - math.pi / 4 - (math.sin(currentDepth * 0.8) * 0.2),
      length * 0.7,
      effectiveDepth,
      remainderProgress,
      currentDepth + 1,
      actualBranchWidth,
    );

    // Right branch
    _drawBranch(
      canvas,
      end,
      angle + math.pi / 4 + (math.sin(currentDepth * 0.9) * 0.2),
      length * 0.7,
      effectiveDepth,
      remainderProgress,
      currentDepth + 1,
      actualBranchWidth,
    );

    // Sometimes add a middle branch for more complexity
    if (currentDepth < 3 || currentDepth.isEven) {
      _drawBranch(
        canvas,
        end,
        angle + (math.sin(currentDepth * 1.2) * 0.2),
        length * 0.7,
        effectiveDepth,
        remainderProgress,
        currentDepth + 1,
        actualBranchWidth,
      );
    }

    // Draw leaf-like decorations at branch tips
    if (currentDepth > maxDepth * 0.5 && currentDepth < effectiveDepth) {
      final leafPaint =
          Paint()
            ..color = color.withOpacity(0.7)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        end,
        actualBranchWidth * 1.5 * (0.7 + math.sin(currentDepth * 3) * 0.3),
        leafPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_FractalTreePainter oldPainter) {
    return progress != oldPainter.progress ||
        primaryColor != oldPainter.primaryColor ||
        secondaryColor != oldPainter.secondaryColor ||
        strokeWidth != oldPainter.strokeWidth;
  }
}
