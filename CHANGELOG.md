## 1.1.0

* Added Classic Analog Loaders:
  * **HourglassLoader**: A smooth hourglass animation with cubic Bézier curves, animated sand draining from the top bulb to the bottom bulb, and a sand stream at the waist. Fully supports `color`, `secondaryColor`, `size`, `strokeWidth`, and `durationMs`.
  * **ClockLoader**: An analog clock face with tick marks, a rotating hour hand, and a faster-spinning minute hand creating a satisfying time-lapse effect. Supports all standard `LoaderOptions`.
* Added Developer Utility Helpers:
  * **`MultipleLoaders.showOverlay(context, loader: ...)`**: A static method that displays a full-screen modal loading barrier blocking user interaction until `MultipleLoaders.hideOverlay(context)` is called. Ideal for login, payment, and long async operations.
  * **`LoaderFutureBuilder<T>`**: A drop-in replacement for Flutter's `FutureBuilder` that automatically displays any package loader during `ConnectionState.waiting` and hands off to a clean builder callback when data is ready — eliminating boilerplate async state handling.
* Enhanced example app:
  * Added a new **Developer Utilities** screen demonstrating `showOverlay` and `LoaderFutureBuilder` with a premium responsive grid layout.
  * Code snippet popups (via `Icons.code` button → bottom sheet) added to each utility card, consistent with the existing loader showcase style.
* Null safety & dependency improvements:
  * Upgraded SDK constraint to `^3.7.2` and removed legacy/incompatible `dev_dependencies`.

## 1.0.4

* Added support for quaternary color parameter in loader options
  * Extended LoaderOptions class with quaternaryColor property
  * Updated BounceLoader, DotsLoader, and WaveLoader to support quaternary colors
  * Refactored color handling logic for improved efficiency and better color distribution
  * Contributed by Abhishek Sunkewar (@abhisunkewar)

## 1.0.3

* Added new innovative loader:
  * NeonPulseLoader: A futuristic cyberpunk-style loader with multiple concentric neon rings
  * Features customizable glow intensity, ring count, and optional rainbow color cycling
  * Includes realistic neon glow effects with multiple shadow layers for authentic cyberpunk aesthetics
  * Smooth phase-offset pulsing animation creates mesmerizing visual depth
* Updated documentation to include the new NeonPulseLoader
* Enhanced example app to showcase the NeonPulseLoader animation

## 1.0.2

* Added new innovative loaders:
  * HeartbeatLoader: A realistic anatomical heart animation with authentic cardiac rhythm patterns
  * RippleLoader: Concentric circles that expand outward like ripples on water with customizable ripple count
  * Features realistic cardiac rhythm with systole and diastole phases, anatomically correct heart shape
  * RippleLoader includes smooth expanding animation with fade-out effect and customizable ripple count
* Updated documentation to include both new loaders
* Enhanced example app to showcase the HeartbeatLoader and RippleLoader animations

## 1.0.1

* Added new innovative loader:
  * PageTurningLoader: A book with smoothly turning pages that simulates a realistic reading animation
  * Features realistic page turning physics, shadows, and text line visualizations
  * Customizable page count and turning speed
* Updated documentation to include the new PageTurningLoader

## 1.0.0

* Added new standard loader:
  * BlinkingLoader: A customizable shape that fades in and out with adjustable timing
  * Supports multiple shape options: circle, square, triangle, and star
* Updated example app to showcase the new BlinkingLoader animation

## 0.0.6

* Added new innovative loaders:
  * ParticleVortexLoader: Mesmerizing particles flowing in a vortex pattern
  * FractalTreeLoader: A beautiful animated fractal tree that grows and branches
  * LiquidBlobLoader: A morphing liquid-like blob with fluid motion
* Added comprehensive documentation for all innovative loaders in INNOVATIVE_LOADERS.md
* Enhanced example app with showcases for all new loaders

## 0.0.5

* Added GlowingLoader animation with pulsing glow effects and gradient colors
* Added TypingLoader animation simulating typing dots for chat applications 

## 0.0.4

* Added rotating square and flipping card animation
* Enhanced web example with an improved splash screen

## 0.0.3

* Fixed wave animation assertion error where curve end value could exceed 1.0, causing the animation to fail

## 0.0.2

* Fixed library documentation format
* Added proper library directive to main file
* Improved CI/CD workflow for more reliable package publishing
* Implemented version change detection in CI/CD pipeline
* Added automated checks for pull request merges

## 0.0.1

Initial release with the following features:
* Six loader animations: Spinner, Pulse, Bounce, Wave, Circle, and Dots
* Customizable colors, sizes, and animation durations
* Animation controller for programmatic control
* Support for multiple colors in animations
* Customizable loop behavior
