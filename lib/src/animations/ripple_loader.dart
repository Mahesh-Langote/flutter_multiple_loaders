import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A ripple loader animation.
///
/// This loader displays concentric circles that expand outward like ripples on water.
class RippleLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Number of ripple circles.
  final int rippleCount;

  /// Creates a [RippleLoader] with the given options.
  const RippleLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
    this.rippleCount = 3,
  });

  @override
  State<RippleLoader> createState() => _RippleLoaderState();
}

class _RippleLoaderState extends State<RippleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _opacityAnimations;
  late LoaderController _loaderController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    _initializeAnimations();

    _loaderController = widget.controller ?? LoaderController();
    _loaderController.initialize(_animationController);

    if (widget.options.loop) {
      _animationController.repeat();
    } else {
      _animationController.forward();
    }
  }

  void _initializeAnimations() {
    _scaleAnimations = [];
    _opacityAnimations = [];

    for (int i = 0; i < widget.rippleCount; i++) {
      final double delay = i / widget.rippleCount;

      // Scale animation: starts small and grows to full size
      final scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, 1.0, curve: Curves.easeOut),
        ),
      );
      _scaleAnimations.add(scaleAnimation);

      // Opacity animation: starts opaque and fades out
      final opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, 1.0, curve: Curves.easeOut),
        ),
      );
      _opacityAnimations.add(opacityAnimation);
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
  void didUpdateWidget(RippleLoader oldWidget) {
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
        _animationController.forward();
      }
    }

    // If ripple count changed, reinitialize animations
    if (oldWidget.rippleCount != widget.rippleCount) {
      _initializeAnimations();
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
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(widget.rippleCount, (index) {
              return Transform.scale(
                scale: _scaleAnimations[index].value,
                child: Opacity(
                  opacity: _opacityAnimations[index].value,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.options.color,
                        width: widget.options.strokeWidth,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
