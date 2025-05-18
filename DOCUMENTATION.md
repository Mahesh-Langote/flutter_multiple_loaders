# Flutter Multiple Loaders Documentation

This document provides detailed information about the Flutter Multiple Loaders package, its components, and how to use them effectively in your Flutter applications.

## Table of Contents
- [Installation](#installation)
- [Available Loaders](#available-loaders)
- [Customization Options](#customization-options)
- [Animation Control](#animation-control)
- [Best Practices](#best-practices)
- [Examples](#examples)

## Installation

To use this package, add `flutter_multiple_loaders` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_multiple_loaders: ^0.0.1
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

The package provides the following loader animations:

### SpinnerLoader

A classic spinning circular loader.

```dart
SpinnerLoader(
  options: LoaderOptions(
    color: Colors.blue,
    size: LoaderSize.medium,
  ),
)
```

### PulseLoader

A circle that pulses in and out with opacity changes.

```dart
PulseLoader(
  options: LoaderOptions(
    color: Colors.purple,
    size: LoaderSize.large,
  ),
)
```

### BounceLoader

Multiple dots bouncing up and down with staggered animation.

```dart
BounceLoader(
  dotCount: 3, // Number of dots
  options: LoaderOptions(
    color: Colors.red,
    secondaryColor: Colors.orange, // For alternating colors
  ),
)
```

### WaveLoader

Multiple bars that animate in a wave-like pattern.

```dart
WaveLoader(
  barCount: 5, // Number of bars
  options: LoaderOptions(
    color: Colors.green,
    durationMs: 2000, // Slower animation
  ),
)
```

### CircleLoader

A circular progress indicator with customizable properties.

```dart
CircleLoader(
  options: LoaderOptions(
    color: Colors.amber,
    backgroundColor: Colors.grey.shade200, // Background color
    strokeWidth: 6.0, // Thickness of the circle
  ),
)
```

### DotsLoader

Multiple dots that fade in and out in sequence.

```dart
DotsLoader(
  dotCount: 5, // Number of dots
  spacing: 6.0, // Spacing between dots
  options: LoaderOptions(
    color: Colors.teal,
    secondaryColor: Colors.cyan, // For alternating colors
    tertiaryColor: Colors.lightBlue, // For third color in pattern
  ),
)
```

## Customization Options

All loaders accept a `LoaderOptions` object that allows customization:

```dart
LoaderOptions({
  Color color = Colors.blue, // Primary color
  LoaderSize size = LoaderSize.medium, // Size of the loader
  int durationMs = 1500, // Animation duration in milliseconds
  bool loop = true, // Whether to loop the animation
  Color? backgroundColor, // Background color (if applicable)
  Color? secondaryColor, // Secondary color for multi-colored loaders
  Color? tertiaryColor, // Tertiary color for multi-colored loaders
  double strokeWidth = 4.0, // Thickness for stroke-based loaders
})
```

### Loader Sizes

The package provides predefined sizes through the `LoaderSize` enum:

- `LoaderSize.extraSmall` - 16.0 pixels
- `LoaderSize.small` - 24.0 pixels
- `LoaderSize.medium` - 32.0 pixels
- `LoaderSize.large` - 48.0 pixels
- `LoaderSize.extraLarge` - 64.0 pixels
- `LoaderSize.custom` - For custom sizes (manual implementation required)

## Animation Control

You can control the animation programmatically using the `LoaderController`:

```dart
// Create a controller
final LoaderController controller = LoaderController();

// Pass it to the loader
SpinnerLoader(controller: controller);

// Control the animation
controller.start(); // Start
controller.stop(); // Pause
controller.reset(); // Reset to beginning
```

## Best Practices

1. **Performance**: Avoid using too many animated loaders simultaneously, as they can impact performance.
2. **Visual Consistency**: Stick to a single loader style throughout your app for consistency.
3. **Sizing**: Choose appropriate sizes for your UI context, using the predefined `LoaderSize` options.
4. **Duration**: For most loading states, the default 1500ms duration works well. Adjust as needed.
5. **Colors**: Match the loader colors to your app's theme for a polished look.

## Examples

### Basic Loading State

```dart
Stack(
  children: [
    // Blurred or dimmed content
    Container(
      color: Colors.black26,
    ),
    // Centered loader
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

For more examples, check out the example folder in the package repository.
