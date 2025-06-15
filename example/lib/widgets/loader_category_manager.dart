import 'package:flutter/material.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';

/// Represents a category of loaders
class LoaderCategory {
  /// The name of the category
  final String name;

  /// The list of loaders in this category
  final List<LoaderInfo> loaders;

  /// Creates a loader category
  const LoaderCategory({required this.name, required this.loaders});
}

/// Holds information about a specific loader
class LoaderInfo {
  /// The name of the loader
  final String name;

  /// A brief description of what the loader looks like
  final String description;

  /// Function to create the loader widget with given options and controller
  final Widget Function(LoaderOptions options, LoaderController controller)
  createLoader;

  /// Default primary color for this loader
  final Color primaryColor;

  /// Default secondary color for this loader (if applicable)
  final Color? secondaryColor;

  /// Default tertiary color for this loader (if applicable)
  final Color? tertiaryColor;

  /// Default animation duration in milliseconds
  final int durationMs;

  /// Default stroke width (if applicable)
  final double strokeWidth;

  /// Whether this loader uses stroke width
  final bool usesStrokeWidth;

  /// Creates loader information
  const LoaderInfo({
    required this.name,
    required this.description,
    required this.createLoader,
    required this.primaryColor,
    this.secondaryColor,
    this.tertiaryColor,
    required this.durationMs,
    this.strokeWidth = 4.0,
    this.usesStrokeWidth = false,
  });
}

/// Manager class that provides all available loaders organized by category
class LoaderCategoryManager {
  /// Get all available categories with their loaders
  static List<LoaderCategory> getCategories() {
    return [
      LoaderCategory(
        name: 'Standard',
        loaders: [
          LoaderInfo(
            name: 'Spinner',
            description: 'A classic spinning loader animation',
            primaryColor: Colors.purple,
            durationMs: 1500,
            usesStrokeWidth: true,
            strokeWidth: 4.0,
            createLoader:
                (options, controller) =>
                    SpinnerLoader(options: options, controller: controller),
          ),
          LoaderInfo(
            name: 'Pulse',
            description: 'A pulsing circle animation',
            primaryColor: Colors.blue,
            durationMs: 1500,
            createLoader:
                (options, controller) =>
                    PulseLoader(options: options, controller: controller),
          ),
          LoaderInfo(
            name: 'Bounce',
            description: 'Bouncing dots animation',
            primaryColor: Colors.orange,
            durationMs: 1500,
            createLoader:
                (options, controller) => BounceLoader(
                  options: options,
                  controller: controller,
                  dotCount: 3,
                ),
          ),
          LoaderInfo(
            name: 'Wave',
            description: 'Animated wave-like bars',
            primaryColor: Colors.teal,
            durationMs: 1500,
            createLoader:
                (options, controller) => WaveLoader(
                  options: options,
                  controller: controller,
                  barCount: 5,
                ),
          ),
          LoaderInfo(
            name: 'Circle',
            description: 'A circular progress indicator',
            primaryColor: Colors.blue,
            durationMs: 1500,
            usesStrokeWidth: true,
            strokeWidth: 5.0,
            createLoader:
                (options, controller) =>
                    CircleLoader(options: options, controller: controller),
          ),
          LoaderInfo(
            name: 'Dots',
            description: 'Sequence of fading dots',
            primaryColor: Colors.indigo,
            durationMs: 1500,
            createLoader:
                (options, controller) => DotsLoader(
                  options: options,
                  controller: controller,
                  dotCount: 5,
                ),
          ),
          LoaderInfo(
            name: 'RotatingSquare',
            description: 'A square that rotates',
            primaryColor: Colors.red,
            durationMs: 1500,
            createLoader:
                (options, controller) => RotatingSquareLoader(
                  options: options,
                  controller: controller,
                ),
          ),
          LoaderInfo(
            name: 'FlippingCard',
            description: 'A card that flips in 3D',
            primaryColor: Colors.amber,
            durationMs: 1500,
            createLoader:
                (options, controller) => FlippingCardLoader(
                  options: options,
                  controller: controller,
                ),
          ),
          LoaderInfo(
            name: 'Glowing',
            description: 'A pulsating glow effect',
            primaryColor: Colors.green,
            durationMs: 1500,
            createLoader:
                (options, controller) =>
                    GlowingLoader(options: options, controller: controller),
          ),
          LoaderInfo(
            name: 'Typing',
            description: 'Animated typing-like dots',
            primaryColor: Colors.purple,
            durationMs: 1500,
            createLoader:
                (options, controller) => TypingLoader(
                  options: options,
                  controller: controller,
                  dotCount: 3,
                ),
          ),
          LoaderInfo(
            name: 'Blinking',
            description: 'Shape that blinks with a fade effect',
            primaryColor: Colors.deepOrange,
            durationMs: 1200,
            createLoader:
                (options, controller) => BlinkingLoader(
                  options: options,
                  controller: controller,
                  shape: BlinkingShape.circle,
                ),
          ),
          LoaderInfo(
            name: 'Ripple',
            description: 'Concentric circles expanding like water ripples',
            primaryColor: Colors.cyan,
            durationMs: 2000,
            usesStrokeWidth: true,
            strokeWidth: 3.0,
            createLoader:
                (options, controller) => RippleLoader(
                  options: options,
                  controller: controller,
                  rippleCount: 3,
                ),
          ),
          LoaderInfo(
            name: 'Heartbeat',
            description:
                'A pulsing heart shape with realistic heartbeat rhythm',
            primaryColor: Colors.red,
            durationMs: 2500,
            usesStrokeWidth: true,
            strokeWidth: 2.0,
            createLoader:
                (options, controller) => HeartbeatLoader(
                  options: options,
                  controller: controller,
                  pulseIntensity: 0.3,
                ),
          ),
        ],
      ),
      LoaderCategory(
        name: 'Innovative',
        loaders: [
          LoaderInfo(
            name: 'DNAHelix',
            description: 'An animated double helix structure',
            primaryColor: Colors.deepPurple,
            secondaryColor: Colors.pinkAccent,
            durationMs: 3000,
            createLoader:
                (options, controller) =>
                    DnaHelixLoader(options: options, controller: controller),
          ),
          LoaderInfo(
            name: 'MorphingShape',
            description: 'A shape that smoothly transforms',
            primaryColor: Colors.teal,
            secondaryColor: Colors.amber,
            tertiaryColor: Colors.deepOrange,
            durationMs: 3000,
            createLoader:
                (options, controller) => MorphingShapeLoader(
                  options: options,
                  controller: controller,
                ),
          ),
          LoaderInfo(
            name: 'GalaxySpiral',
            description: 'A spiraling galaxy animation',
            primaryColor: Colors.blue,
            secondaryColor: Colors.purple,
            tertiaryColor: Colors.white,
            durationMs: 6000,
            createLoader:
                (options, controller) => GalaxySpiralLoader(
                  options: options,
                  controller: controller,
                ),
          ),
          LoaderInfo(
            name: 'ParticleVortex',
            description: 'Particles swirling in a vortex',
            primaryColor: Colors.deepOrange,
            secondaryColor: Colors.amber,
            tertiaryColor: Colors.redAccent,
            durationMs: 3000,
            createLoader:
                (options, controller) => ParticleVortexLoader(
                  options: options,
                  controller: controller,
                ),
          ),
          LoaderInfo(
            name: 'FractalTree',
            description: 'A growing fractal tree pattern',
            primaryColor: Colors.green,
            secondaryColor: Colors.lightGreenAccent,
            durationMs: 5000,
            createLoader:
                (options, controller) =>
                    FractalTreeLoader(options: options, controller: controller),
          ),
          LoaderInfo(
            name: 'LiquidBlob',
            description: 'A fluid, morphing blob',
            primaryColor: Colors.blueAccent,
            secondaryColor: Colors.cyanAccent,
            durationMs: 3000,
            createLoader:
                (options, controller) =>
                    LiquidBlobLoader(options: options, controller: controller),
          ),
          LoaderInfo(
            name: 'PageTurning',
            description: 'A book with turning pages',
            primaryColor: Colors.indigo,
            secondaryColor: Colors.indigoAccent,
            tertiaryColor: Colors.white,
            durationMs: 3500,
            createLoader:
                (options, controller) => PageTurningLoader(
                  options: options,
                  controller: controller,
                  pageCount: 20,
                ),
          ),
          LoaderInfo(
            name: 'NeonPulse',
            description: 'Futuristic neon rings with glow effects',
            primaryColor: Colors.cyan,
            secondaryColor: Colors.pinkAccent,
            tertiaryColor: Colors.deepPurple,
            durationMs: 2000,
            usesStrokeWidth: true,
            strokeWidth: 2.0,
            createLoader:
                (options, controller) => NeonPulseLoader(
                  options: options,
                  controller: controller,
                  ringCount: 4,
                  glowIntensity: 3.0,
                ),
          ),
        ],
      ),
    ];
  }
}
