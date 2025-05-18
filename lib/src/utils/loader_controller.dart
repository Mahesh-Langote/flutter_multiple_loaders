import 'package:flutter/widgets.dart';

/// Controller for managing loader animations.
///
/// This controller allows for programmatic control of loader animations,
/// including starting, stopping, and resetting animations.
class LoaderController {
  /// The animation controller that manages the animation.
  late AnimationController _controller;

  /// Whether the animation is currently playing.
  bool get isAnimating => _controller.isAnimating;

  /// The current status of the animation.
  AnimationStatus get status => _controller.status;

  /// The current value of the animation.
  double get value => _controller.value;

  /// Initializes the controller with an [AnimationController].
  void initialize(AnimationController controller) {
    _controller = controller;
  }

  /// Starts the animation.
  void start() {
    if (!isAnimating) {
      _controller.forward();
    }
  }

  /// Stops the animation.
  void stop() {
    if (isAnimating) {
      _controller.stop();
    }
  }

  /// Resets the animation to its initial state.
  void reset() {
    _controller.reset();
  }

  /// Reverses the animation.
  void reverse() {
    _controller.reverse();
  }

  /// Disposes the animation controller.
  void dispose() {
    _controller.dispose();
  }

  /// Creates a new animation that is driven by this controller.
  Animation<T> drive<T>(Animatable<T> animatable) {
    return animatable.animate(_controller);
  }
}
