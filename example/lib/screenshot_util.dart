import 'dart:typed_data' show ByteData;

import 'package:flutter/material.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

/// A utility class for capturing screenshots of loaders
/// This is used by package developers to create GIF frames or images
class ScreenshotUtil {
  /// Captures an image of the given widget
  static Future<void> captureWidget(Widget widget, String filePath) async {
    // Create a repaint boundary widget to capture
    final RenderRepaintBoundary boundary = RenderRepaintBoundary();

    // Create the widget tree with the boundary
    final RenderView renderView = RenderView(
      view: WidgetsBinding.instance.platformDispatcher.views.single,
      child: RenderPositionedBox(alignment: Alignment.center, child: boundary),
      configuration: ViewConfiguration(

        devicePixelRatio:
            WidgetsBinding
                .instance
                .platformDispatcher
                .views
                .single
                .devicePixelRatio,
      ),
    );

    // Layout the widget
    PipelineOwner pipelineOwner = PipelineOwner();
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    // Get the image
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final buffer = byteData!.buffer.asUint8List();

    // Save to file
    final file = File(filePath);
    await file.writeAsBytes(buffer);
  }
}

void main() async {
  // Initialize widgets binding
  WidgetsFlutterBinding.ensureInitialized();

  // Create screenshot directory
  final Directory screenshotDir = Directory('screenshots');
  if (!await screenshotDir.exists()) {
    await screenshotDir.create();
  }

  // Capture each new loader
  await ScreenshotUtil.captureWidget(
    const Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: DnaHelixLoader(
          options: LoaderOptions(
            color: Colors.deepPurple,
            secondaryColor: Colors.pinkAccent,
            size: LoaderSize.large,
          ),
        ),
      ),
    ),
    'screenshots/dna_helix_loader.png',
  );

  await ScreenshotUtil.captureWidget(
    const Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: MorphingShapeLoader(
          options: LoaderOptions(
            color: Colors.teal,
            secondaryColor: Colors.amber,
            tertiaryColor: Colors.deepOrange,
            size: LoaderSize.large,
          ),
        ),
      ),
    ),
    'screenshots/morphing_shape_loader.png',
  );

  await ScreenshotUtil.captureWidget(
    const Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: GalaxySpiralLoader(
          options: LoaderOptions(
            color: Colors.blue,
            secondaryColor: Colors.purple,
            tertiaryColor: Colors.white,
            size: LoaderSize.large,
          ),
        ),
      ),
    ),
    'screenshots/galaxy_spiral_loader.png',
  );

  print('Screenshots captured successfully!');
}
