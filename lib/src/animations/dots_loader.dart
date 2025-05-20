import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A dots loader animation.
///
/// This loader displays multiple dots that fade in and out in sequence.
class DotsLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// The number of dots to display
  final int dotCount;

  /// The spacing between dots
  final double spacing;

  /// Creates a [DotsLoader] with the given options.
  const DotsLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
    this.dotCount = 3,
    this.spacing = 4.0,
  });

  @override
  State<DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<DotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
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
    _opacityAnimations = List.generate(widget.dotCount, (index) {
      final beginPoint = index / widget.dotCount;
      final endPoint = beginPoint + (1 / widget.dotCount);

      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(beginPoint, endPoint, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void didUpdateWidget(DotsLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dotCount != widget.dotCount) {
      _initializeAnimations();
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
  Widget build(BuildContext context) {
    final dotSize = widget.options.size.value / 3;
    final totalWidth =
        (dotSize * widget.dotCount) + (widget.spacing * (widget.dotCount - 1));

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizedBox(
          width: totalWidth,
          height: dotSize,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.dotCount, (index) {
              return Opacity(
                opacity: _opacityAnimations[index].value,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: _getDotColor(index),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Color _getDotColor(int index) {
    if (widget.options.secondaryColor != null && index % 2 == 1) {
      return widget.options.secondaryColor!;
    }
    if (widget.options.tertiaryColor != null && index % 3 == 2) {
      return widget.options.tertiaryColor!;
    }
    return widget.options.color;
  }
}
