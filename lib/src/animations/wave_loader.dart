import 'package:flutter/material.dart';

import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A wave loader animation.
///
/// This loader displays multiple bars that animate in a wave-like pattern.
class WaveLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Number of bars in the wave
  final int barCount;

  /// Creates a [WaveLoader] with the given options.
  const WaveLoader({super.key, this.options = const LoaderOptions(), this.controller, this.barCount = 5});

  @override
  State<WaveLoader> createState() => _WaveLoaderState();
}

class _WaveLoaderState extends State<WaveLoader> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _barAnimations;
  late LoaderController _loaderController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.options.durationMs));

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
    _barAnimations = List.generate(widget.barCount, (index) {
      final delay = index / widget.barCount;
      // Ensure end value never exceeds 1.0
      final endValue = (delay + 0.5).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Interval(delay, endValue, curve: Curves.easeInOut)));
    });
  }

  @override
  void didUpdateWidget(WaveLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.barCount != widget.barCount) {
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
    final size = widget.options.size.value;
    final barWidth = size / (widget.barCount * 2);
    final spacing = barWidth / 2;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.barCount, (index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing),
                child: Container(
                  width: barWidth,
                  height: size * _barAnimations[index].value,
                  decoration: BoxDecoration(color: _getBarColor(index), borderRadius: BorderRadius.circular(barWidth / 2)),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Color _getBarColor(int index) {
    if (widget.options.secondaryColor != null && index % 2 == 1) {
      return widget.options.secondaryColor!;
    }
    if (widget.options.tertiaryColor != null && index % 3 == 2) {
      return widget.options.tertiaryColor!;
    }
    if (widget.options.quaternaryColor != null && index % 4 == 3) {
      return widget.options.quaternaryColor!;
    }
    return widget.options.color;
  }
}
