import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A typing indicator animation with animating dots.
///
/// This loader displays a sequence of dots that appear and disappear
/// to simulate a typing indicator commonly seen in chat applications.
class TypingLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Number of dots to display in the animation.
  final int dotCount;

  /// Creates a [TypingLoader] with the given options.
  const TypingLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
    this.dotCount = 3,
  });

  @override
  State<TypingLoader> createState() => _TypingLoaderState();
}

class _TypingLoaderState extends State<TypingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _dotAnimations;
  late LoaderController _loaderController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    // Create staggered animations for each dot
    _createDotAnimations();

    _loaderController = widget.controller ?? LoaderController();
    _loaderController.initialize(_animationController);

    if (widget.options.loop) {
      _animationController.repeat();
    } else {
      _animationController.forward();
    }
  }

  void _createDotAnimations() {
    _dotAnimations = List.generate(widget.dotCount, (index) {
      // Calculate the delay for each dot
      final startInterval = index / widget.dotCount;
      final endInterval = (index + 0.5) / widget.dotCount;

      // Create a tween sequence for scale and opacity
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.5,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 40,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.0,
            end: 0.5,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 40,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.5, end: 0.5),
          weight: 20,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(startInterval, endInterval, curve: Curves.easeInOut),
        ),
      );
    });
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
  void didUpdateWidget(TypingLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animation duration if it changed
    if (oldWidget.options.durationMs != widget.options.durationMs) {
      _animationController.duration = Duration(
        milliseconds: widget.options.durationMs,
      );
    }

    // Handle dot count changes
    if (oldWidget.dotCount != widget.dotCount) {
      _createDotAnimations();
    }

    // Handle loop state changes
    if (oldWidget.options.loop != widget.options.loop) {
      if (widget.options.loop) {
        _animationController.repeat();
      } else if (_animationController.isAnimating) {
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
    final dotSize = size * 0.15;
    final spacing = size * 0.1;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizedBox(
          width: size,
          height: size * 0.5,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.dotCount, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                  child: Transform.scale(
                    scale: _dotAnimations[index].value,
                    child: _buildDot(dotSize),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDot(double size) {
    // Secondary color fallback to a lighter version of the main color
    final secondaryColor =
        widget.options.secondaryColor ?? widget.options.color.withOpacity(0.7);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.options.color,
        boxShadow:
            widget.options.backgroundColor != null
                ? [
                  BoxShadow(
                    color: secondaryColor.withOpacity(0.3),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  ),
                ]
                : null,
      ),
    );
  }
}
