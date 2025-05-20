import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A rotating square loader animation.
///
/// This loader displays a square that rotates on its center axis.
class RotatingSquareLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Creates a [RotatingSquareLoader] with the given options.
  const RotatingSquareLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
  });

  @override
  State<RotatingSquareLoader> createState() => _RotatingSquareLoaderState();
}

class _RotatingSquareLoaderState extends State<RotatingSquareLoader>
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
    // Stop the animation before disposing
    _animationController.stop();
    // Only dispose the controller if we created it internally
    if (widget.controller == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(RotatingSquareLoader oldWidget) {
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
          child: Center(
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width:
                    size * 0.7, // Square is slightly smaller than the container
                height: size * 0.7,
                decoration: BoxDecoration(
                  color: widget.options.color,
                  border:
                      widget.options.strokeWidth > 0
                          ? Border.all(
                            color:
                                widget.options.backgroundColor ??
                                Colors.transparent,
                            width: widget.options.strokeWidth,
                          )
                          : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
