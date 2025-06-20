# Flutter Multiple Loaders - Innovative Animations

This document provides detailed information about the innovative loading animations available in the Flutter Multiple Loaders package.

## Innovative Loaders Overview

The Flutter Multiple Loaders package includes several innovative and creative loading animations that can add visual interest and delight to your Flutter applications.

### DNA Helix Loader

The DNA Helix Loader displays an animated double helix that rotates to create a 3D DNA structure effect with connecting "rungs" between the strands.

**Features:**
- Fully animated 3D rotation effect
- Customizable strand colors
- Connecting bars that mimic DNA base pairs
- Smooth animation with configurable speed

**Example Usage:**
```dart
DnaHelixLoader(
  options: LoaderOptions(
    color: Colors.deepPurple,
    secondaryColor: Colors.pinkAccent,
    size: LoaderSize.large,
    durationMs: 3000,
  ),
)
```

### Morphing Shape Loader

The Morphing Shape Loader displays an animated shape that smoothly transitions between different geometric forms (circle, square, triangle, pentagon, etc.).

**Features:**
- Smooth morphing between multiple geometric shapes
- Customizable color transitions
- Configurable animation speed and size
- Optional rotation during morphing

**Example Usage:**
```dart
MorphingShapeLoader(
  options: LoaderOptions(
    color: Colors.teal,
    secondaryColor: Colors.amber,
    tertiaryColor: Colors.deepOrange,
    size: LoaderSize.large,
    durationMs: 4000,
  ),
)
```

### Galaxy Spiral Loader

The Galaxy Spiral Loader displays an animated spiral galaxy with particles rotating around a central point with a glowing core effect.

**Features:**
- Realistic galaxy spiral arm simulation
- Particles moving at different speeds based on distance from center
- Glowing core effect with customizable colors
- Configurable number of stars/particles

**Example Usage:**
```dart
GalaxySpiralLoader(
  options: LoaderOptions(
    color: Colors.blue,
    secondaryColor: Colors.purple,
    tertiaryColor: Colors.white,
    size: LoaderSize.large,
    durationMs: 6000,
  ),
)
```

### Particle Vortex Loader

The Particle Vortex Loader displays particles flowing in a mesmerizing vortex pattern, with customizable flow speed, particle count, and color schemes.

**Features:**
- Dynamic particle movement with physics-based motion
- Particles gradually move toward the center and respawn at the edges
- Motion blur/tail effects on particles
- Customizable colors and particle density
- Glowing central core

**Example Usage:**
```dart
ParticleVortexLoader(
  options: LoaderOptions(
    color: Colors.deepOrange,
    secondaryColor: Colors.amber,
    tertiaryColor: Colors.redAccent,
    size: LoaderSize.large,
    durationMs: 3500,
  ),
)
```

### Fractal Tree Loader

The Fractal Tree Loader displays an animated fractal tree that grows and branches, creating a beautiful organic pattern inspired by nature.

**Features:**
- Recursive branch generation that mimics natural growth patterns
- Organic growth animation with smooth transitions
- Random variations for a more natural look
- Customizable colors and branch thickness
- Optional leaf-like decorations at branch tips

**Example Usage:**
```dart
FractalTreeLoader(
  options: LoaderOptions(
    color: Colors.green,
    secondaryColor: Colors.lightGreenAccent,
    size: LoaderSize.large,
    durationMs: 5000,
  ),
)
```

### Liquid Blob Loader

The Liquid Blob Loader displays an animated morphing liquid blob with a fluid-like motion that creates a mesmerizing organic effect.

**Features:**
- Smooth morphing animation that mimics liquid behavior
- Realistic highlights that move across the surface
- Gradient coloring for a 3D effect
- Subtle shadow for depth perception
- Customizable colors and morphing speed

**Example Usage:**
```dart
LiquidBlobLoader(
  options: LoaderOptions(
    color: Colors.blueAccent,
    secondaryColor: Colors.cyanAccent,
    size: LoaderSize.large,
    durationMs: 4000,
  ),
)
```

### Page Turning Loader

The Page Turning Loader displays a realistic book with smoothly turning pages, creating an immersive reading animation effect.

**Features:**
- Enhanced 3D perspective with realistic page turning physics
- Dynamic shadows that adjust based on page position and lighting
- Natural page bending and curvature effects during turns
- Realistic page content visualization with text line patterns
- Book cover with texture and spine details
- Customizable page count, colors, and turning speed
- Smooth animation sequence with natural pauses and easing curves

**Example Usage:**
```dart
PageTurningLoader(
  pageCount: 20,  // Number of pages in the book
  options: LoaderOptions(
    color: Colors.indigo,        // Cover color
    secondaryColor: Colors.indigoAccent,  // Text/content color
    tertiaryColor: Colors.white, // Page color
    size: LoaderSize.large,
    durationMs: 3500,            // Total animation duration
  ),
)
```
 

## Common Customization Options

All innovative loaders can be customized using the `LoaderOptions` class, which provides the following options:

- **color**: The primary color of the loader (required)
- **secondaryColor**: Secondary color for elements that need a different color
- **tertiaryColor**: Third color option for more complex loaders
- **size**: The size of the loader (`LoaderSize.small`, `LoaderSize.medium`, `LoaderSize.large`, etc.)
- **durationMs**: Animation duration in milliseconds
- **loop**: Whether the animation should loop continuously
- **backgroundColor**: Optional background color
- **strokeWidth**: Width of strokes for applicable loaders

## Performance Considerations

Some of the more complex loaders (like Galaxy Spiral and Particle Vortex) use a higher number of drawn elements and may impact performance on lower-end devices. Consider using simpler loaders for performance-critical applications or reducing the number of particles/elements if needed.

## Custom Animation Control

For fine-grained control over the animations, you can provide a custom `LoaderController`:

```dart
final controller = LoaderController();

// In your widget:
LiquidBlobLoader(
  options: const LoaderOptions(
    // options...
  ),
  controller: controller,
)

// Later, control the animation:
controller.pause();
controller.resume();
controller.reset();
```

### Heartbeat Loader

The Heartbeat Loader displays a realistic anatomical heart animation with authentic cardiac rhythm patterns, blood flow simulation, and optional EKG-style pulse lines.

**Features:**
- Realistic cardiac rhythm with systole and diastole phases
- Blood flow simulation with animated particles moving through chambers and vessels
- Optional EKG-style pulse lines displaying heart rhythm
- Anatomically correct heart shape with chambers and major vessels
- Dynamic color transitions for oxygen-rich/poor blood simulation
- Customizable pulse intensity and visual effects
- Realistic heartbeat timing with double-beat pattern followed by pause

**Example Usage:**
```dart
HeartbeatLoader(
  pulseIntensity: 0.4, // Intensity of the heartbeat pulse (0.1 to 1.0)
  showBloodFlow: true, // Show blood flow animation inside the heart
  showPulseLines: false, // Show EKG-style pulse lines
  options: LoaderOptions(
    color: Colors.red, // Primary heart color
    secondaryColor: Colors.blue, // Deoxygenated blood color
    tertiaryColor: Colors.pink, // Oxygenated blood color
    size: LoaderSize.large,
    durationMs: 2000, // Heartbeat cycle duration
  ),
)
```
