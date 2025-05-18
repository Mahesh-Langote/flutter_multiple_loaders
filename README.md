# Flutter Multiple Loaders

A Flutter package providing a collection of customizable loading animations for your Flutter applications.

## Features

This package includes multiple loading animation styles with customizable properties:

- **Spinner Loader**: A classic spinning circular loader
- **Pulse Loader**: A circle that pulses in and out
- **Bounce Loader**: Multiple dots that bounce up and down
- **Wave Loader**: Multiple bars that animate in a wave-like pattern
- **Circle Loader**: A circular progress indicator with customizable properties
- **Dots Loader**: Multiple dots that fade in and out in sequence

All loaders feature:
- Customizable sizes (extra small to extra large)
- Custom colors (primary, secondary, and tertiary)
- Adjustable animation speed
- Optional background colors
- Animation control (start, stop, reset)

## Getting started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_multiple_loaders: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

Import the package:

```dart
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';
```

### Basic Usage

Use any of the loaders with default options:

```dart
// Simple spinner animation
SpinnerLoader();

// Pulse animation
PulseLoader();

// Bounce animation 
BounceLoader();

// Wave animation
WaveLoader();

// Circle animation
CircleLoader();

// Dots animation
DotsLoader();
```

### Customizing Loaders

All loaders accept custom options through the `LoaderOptions` class:

```dart
// Customized spinner loader
SpinnerLoader(
  options: LoaderOptions(
    color: Colors.purple,
    size: LoaderSize.large,
    durationMs: 1000,
    loop: true,
  ),
);

// Multi-colored wave loader
WaveLoader(
  barCount: 5,
  options: LoaderOptions(
    color: Colors.blue,
    secondaryColor: Colors.green,
    tertiaryColor: Colors.orange,
    size: LoaderSize.medium,
  ),
);
```

### Controlling Animation Programmatically

Use the `LoaderController` to control the animation:

```dart
class _MyWidgetState extends State<MyWidget> {
  final LoaderController _controller = LoaderController();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SpinnerLoader(controller: _controller),
        
        ElevatedButton(
          onPressed: () => _controller.start(),
          child: Text('Start'),
        ),
        
        ElevatedButton(
          onPressed: () => _controller.stop(),
          child: Text('Stop'),
        ),
        
        ElevatedButton(
          onPressed: () => _controller.reset(),
          child: Text('Reset'),
        ),
      ],
    );
  }
}
```

Check the [example](./example) folder for more detailed usage examples.

## Additional information

### Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

### License

This package is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
