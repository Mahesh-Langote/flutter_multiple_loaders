# Flutter Multiple Loaders Documentation

This document provides detailed information about the Flutter Multiple Loaders package, its components, and how to use them effectively in your Flutter applications.

## Table of Contents
- [Requirements](#requirements)
- [Installation](#installation)
- [Available Loaders](#available-loaders)
  - [Standard Loaders](#standard-loaders)
  - [Innovative Loaders](#innovative-loaders)
- [Developer Utilities](#developer-utilities)
- [Customization Options](#customization-options)
- [Animation Control](#animation-control)
- [Best Practices](#best-practices)
- [Examples](#examples)

## Requirements

- Flutter SDK >= 1.17.0
- Dart SDK >= 3.7.2

## Installation

To use this package, add `flutter_multiple_loaders` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_multiple_loaders: ^1.1.0
```

Then run:

```bash
flutter pub get
```

Import the package in your Dart code:

```dart
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';
```

## Available Loaders

### Standard Loaders

#### SpinnerLoader

A classic spinning circular loader.

```dart
SpinnerLoader(
  options: LoaderOptions(
    color: Colors.blue,
    size: LoaderSize.medium,
  ),
)
```

#### PulseLoader

A circle that pulses in and out with opacity changes.

```dart
PulseLoader(
  options: LoaderOptions(
    color: Colors.purple,
    size: LoaderSize.large,
  ),
)
```

#### BounceLoader

Multiple dots bouncing up and down with staggered animation.

```dart
BounceLoader(
  dotCount: 3,
  options: LoaderOptions(
    color: Colors.red,
    secondaryColor: Colors.orange,
  ),
)
```

#### WaveLoader

Multiple bars that animate in a wave-like pattern.

```dart
WaveLoader(
  barCount: 5,
  options: LoaderOptions(
    color: Colors.green,
    durationMs: 2000,
  ),
)
```

#### CircleLoader

A circular progress indicator with customizable properties.

```dart
CircleLoader(
  options: LoaderOptions(
    color: Colors.amber,
    backgroundColor: Colors.grey.shade200,
    strokeWidth: 6.0,
  ),
)
```

#### DotsLoader

Multiple dots that fade in and out in sequence.

```dart
DotsLoader(
  dotCount: 5,
  options: LoaderOptions(
    color: Colors.teal,
    secondaryColor: Colors.cyan,
    tertiaryColor: Colors.lightBlue,
  ),
)
```

#### GlowingLoader

A circle with pulsing glow effects and gradient colors.

```dart
GlowingLoader(
  options: LoaderOptions(
    color: Colors.purple,
    secondaryColor: Colors.purpleAccent,
    size: LoaderSize.large,
  ),
)
```

#### TypingLoader

A typing indicator with animated dots, commonly used in chat applications.

```dart
TypingLoader(
  dotCount: 3,
  options: LoaderOptions(
    color: Colors.blue,
    size: LoaderSize.medium,
    durationMs: 1200,
  ),
)
```

#### BlinkingLoader

A shape (circle, square, triangle, or star) that fades in and out.

```dart
// Default circle
BlinkingLoader();

// Star shape
BlinkingLoader(
  shape: BlinkingShape.star,
  options: LoaderOptions(
    color: Colors.amber,
    size: LoaderSize.extraLarge,
    durationMs: 800,
  ),
)
```

#### RippleLoader

Concentric circles that expand outward like ripples on water.

```dart
RippleLoader(
  rippleCount: 4,
  options: LoaderOptions(
    color: Colors.cyan,
    strokeWidth: 3.0,
    size: LoaderSize.large,
    durationMs: 2500,
  ),
)
```

#### HeartbeatLoader

A realistic anatomical heart animation with authentic cardiac rhythm patterns.

```dart
HeartbeatLoader(
  pulseIntensity: 0.4,
  options: LoaderOptions(
    color: Colors.red,
    size: LoaderSize.large,
    durationMs: 2000,
  ),
)
```

**Features:**
- Realistic cardiac rhythm with systole and diastole phases
- Anatomically correct heart shape with chambers and vessels
- Customizable pulse intensity

#### HourglassLoader *(new in 1.1.0)*

A smooth hourglass animation built with cubic Bézier curves, featuring animated sand draining from the top bulb to the bottom and a fine sand stream at the waist.

```dart
HourglassLoader(
  options: LoaderOptions(
    color: Colors.amber,
    secondaryColor: Colors.amber.withOpacity(0.35), // sand color
    size: LoaderSize.large,
    strokeWidth: 3.0,
    durationMs: 2400,
  ),
)
```

**Features:**
- Smooth Bézier-curved hourglass silhouette (no sharp corners)
- Sand drains from top bulb and fills bottom bulb in sync
- Fine sand stream drawn at the neck during the drain phase
- Clipped fill — sand stays perfectly inside the curved shape
- Fully customizable via `LoaderOptions`

#### ClockLoader *(new in 1.1.0)*

An analog clock face with rotating hands, creating a satisfying time-lapse loading effect.

```dart
ClockLoader(
  options: LoaderOptions(
    color: Colors.deepPurple,
    secondaryColor: Colors.deepPurpleAccent, // minute hand color
    size: LoaderSize.large,
    strokeWidth: 3.0,
    durationMs: 3000,
  ),
)
```

**Features:**
- Clock face with 12 tick marks
- Hour hand completes one full rotation per animation cycle
- Minute hand spins 12× faster than the hour hand
- Center dot and rounded stroke caps for a polished look
- Fully customizable colors and stroke width

### Innovative Loaders

See [INNOVATIVE_LOADERS.md](./INNOVATIVE_LOADERS.md) for full documentation of all innovative loaders:

- `DnaHelixLoader`
- `MorphingShapeLoader`
- `GalaxySpiralLoader`
- `ParticleVortexLoader`
- `FractalTreeLoader`
- `LiquidBlobLoader`
- `PageTurningLoader`
- `NeonPulseLoader`

---

## Developer Utilities *(new in 1.1.0)*

### MultipleLoaders.showOverlay

Display a full-screen modal loading barrier that blocks all user interaction while an async operation is in progress.

```dart
// Show overlay before async work
MultipleLoaders.showOverlay(
  context,
  loader: const SpinnerLoader(
    options: LoaderOptions(
      color: Colors.white,
      size: LoaderSize.large,
    ),
  ),
);

// Perform async task
await submitPayment();

// Dismiss overlay when done
if (mounted) {
  MultipleLoaders.hideOverlay(context);
}
```

**API:**
| Method | Description |
|---|---|
| `MultipleLoaders.showOverlay(context, {required Widget loader})` | Shows the overlay with the given loader |
| `MultipleLoaders.hideOverlay(context)` | Dismisses the overlay |

**Use cases:** Login / authentication, payment processing, file uploads, long network requests.

---

### LoaderFutureBuilder\<T\>

A widget that wraps `FutureBuilder<T>` and automatically renders a loader during `ConnectionState.waiting`, eliminating boilerplate async state handling.

```dart
LoaderFutureBuilder<String>(
  future: fetchUserProfile(),
  loader: const CircleLoader(
    options: LoaderOptions(
      color: Colors.teal,
      size: LoaderSize.large,
      strokeWidth: 4.0,
    ),
  ),
  builder: (context, data) {
    // Called only when the future completes successfully
    return ProfileCard(name: data);
  },
)
```

**Constructor parameters:**
| Parameter | Type | Description |
|---|---|---|
| `future` | `Future<T>?` | The future to listen to |
| `loader` | `Widget` | The loader widget to show while waiting |
| `builder` | `Widget Function(BuildContext, T)` | Builder called with resolved data |

**Compared to plain `FutureBuilder`:**

```dart
// ❌ Before — boilerplate
FutureBuilder<String>(
  future: fetchUserProfile(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    return ProfileCard(name: snapshot.data!);
  },
)

// ✅ After — clean
LoaderFutureBuilder<String>(
  future: fetchUserProfile(),
  loader: const CircleLoader(options: LoaderOptions(color: Colors.teal)),
  builder: (context, data) => ProfileCard(name: data),
)
```

---

## Customization Options

All loaders accept a `LoaderOptions` object:

```dart
LoaderOptions({
  Color color = Colors.blue,        // Primary color
  LoaderSize size = LoaderSize.medium, // Size of the loader
  int durationMs = 1500,            // Animation duration in milliseconds
  bool loop = true,                 // Whether to loop the animation
  Color? backgroundColor,           // Background color (if applicable)
  Color? secondaryColor,            // Secondary color for multi-colored loaders
  Color? tertiaryColor,             // Tertiary color for multi-colored loaders
  Color? quaternaryColor,           // Quaternary color for complex loaders
  double strokeWidth = 4.0,         // Thickness for stroke-based loaders
})
```

### Loader Sizes

| Enum value | Pixels |
|---|---|
| `LoaderSize.extraSmall` | 16 px |
| `LoaderSize.small` | 24 px |
| `LoaderSize.medium` | 32 px |
| `LoaderSize.large` | 48 px |
| `LoaderSize.extraLarge` | 64 px |

## Animation Control

You can control the animation programmatically using the `LoaderController`:

```dart
final LoaderController controller = LoaderController();

SpinnerLoader(controller: controller);

controller.start();  // Start
controller.stop();   // Pause
controller.reset();  // Reset to beginning
```

## Best Practices

1. **Performance**: Avoid using too many animated loaders simultaneously, as they can impact performance.
2. **Visual Consistency**: Stick to a single loader style throughout your app for consistency.
3. **Sizing**: Choose appropriate sizes for your UI context using the predefined `LoaderSize` options.
4. **Duration**: The default 1500 ms duration works well for most states. Adjust as needed.
5. **Colors**: Match loader colors to your app's theme for a polished look.
6. **Overlays**: Always call `MultipleLoaders.hideOverlay` in a `finally` block to prevent the overlay from getting stuck if an error occurs.

## Examples

### Basic Loading State

```dart
Stack(
  children: [
    Container(color: Colors.black26),
    Center(
      child: SpinnerLoader(
        options: LoaderOptions(
          size: LoaderSize.large,
          color: Theme.of(context).primaryColor,
        ),
      ),
    ),
  ],
)
```

### Conditional Loading

```dart
Widget build(BuildContext context) {
  return isLoading
    ? Center(child: PulseLoader())
    : YourContentWidget();
}
```

### Button with Loading State

```dart
ElevatedButton(
  onPressed: isLoading ? null : _onSubmit,
  child: isLoading
    ? SpinnerLoader(
        options: LoaderOptions(
          size: LoaderSize.small,
          color: Colors.white,
        ),
      )
    : Text('Submit'),
)
```

### Safe Overlay Usage

```dart
Future<void> _submitForm() async {
  MultipleLoaders.showOverlay(context, loader: const SpinnerLoader());
  try {
    await myApi.submit(formData);
    if (mounted) {
      MultipleLoaders.hideOverlay(context);
      Navigator.pushNamed(context, '/success');
    }
  } catch (e) {
    if (mounted) {
      MultipleLoaders.hideOverlay(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
```

For more examples, check out the [example](./example) folder in the package repository.
