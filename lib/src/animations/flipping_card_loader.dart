import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A flipping card loader animation.
///
/// This loader displays a card that flips on its vertical axis,
/// creating a 3D flipping card effect.
class FlippingCardLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Creates a [FlippingCardLoader] with the given options.
  const FlippingCardLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
  });

  @override
  State<FlippingCardLoader> createState() => _FlippingCardLoaderState();
}

class _FlippingCardLoaderState extends State<FlippingCardLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;
  late LoaderController _loaderController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
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
  void didUpdateWidget(FlippingCardLoader oldWidget) {
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
    final cardWidth = size * 0.8;
    final cardHeight = size * 0.5;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Transform(
              alignment: Alignment.center,
              transform:
                  Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateY(_flipAnimation.value),
              child: Container(
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                  color:
                      _flipAnimation.value < math.pi / 2 ||
                              _flipAnimation.value > 3 * math.pi / 2
                          ? widget.options.color
                          : widget.options.secondaryColor ??
                              widget.options.color.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border:
                      widget.options.strokeWidth > 0
                          ? Border.all(
                            color:
                                widget.options.backgroundColor ??
                                Colors.white.withOpacity(0.5),
                            width: widget.options.strokeWidth,
                          )
                          : null,
                ),
                child: Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform:
                        Matrix4.identity()..rotateY(
                          _flipAnimation.value < math.pi ? 0 : math.pi,
                        ),
                    child: Icon(
                      _flipAnimation.value < math.pi / 2 ||
                              _flipAnimation.value > 3 * math.pi / 2
                          ? Icons.refresh
                          : Icons.hourglass_empty,
                      color: widget.options.backgroundColor ?? Colors.white,
                      size: cardWidth * 0.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
