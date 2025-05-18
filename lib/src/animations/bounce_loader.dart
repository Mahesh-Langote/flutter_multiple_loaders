import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A bouncing loader animation.
///
/// This loader displays multiple circles that bounce up and down.
class BounceLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// The number of dots to display.
  final int dotCount;

  /// Creates a [BounceLoader] with the given options.
  const BounceLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
    this.dotCount = 3,
  });

  @override
  State<BounceLoader> createState() => _BounceLoaderState();
}

class _BounceLoaderState extends State<BounceLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _bounceAnimations;
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
    _bounceAnimations = List.generate(widget.dotCount, (index) {
      final beginPercent = index * (1 / widget.dotCount);
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.0,
            end: -1.0,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: -1.0,
            end: 0.0,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 50,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            beginPercent,
            beginPercent + (1 / widget.dotCount),
            curve: Curves.linear,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(BounceLoader oldWidget) {
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

    if (oldWidget.dotCount != widget.dotCount) {
      _initializeAnimations();
    }
  }

  Color _getDotColor(int index) {
    if (index == 0) {
      return widget.options.color;
    } else if (index == 1 && widget.options.secondaryColor != null) {
      return widget.options.secondaryColor!;
    } else if (index == 2 && widget.options.tertiaryColor != null) {
      return widget.options.tertiaryColor!;
    }
    return widget.options.color;
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.options.size.value * 0.25;
    final spacing = widget.options.size.value * 0.15;
    final totalWidth =
        (dotSize * widget.dotCount) + (spacing * (widget.dotCount - 1));

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizedBox(
          width: totalWidth,
          height: widget.options.size.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.dotCount, (index) {
              return Row(
                children: [
                  Transform.translate(
                    offset: Offset(
                      0,
                      _bounceAnimations[index].value *
                          widget.options.size.value *
                          0.3,
                    ),
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getDotColor(index),
                      ),
                    ),
                  ),
                  if (index < widget.dotCount - 1) SizedBox(width: spacing),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
