import 'package:flutter/material.dart';

/// A widget that showcases a single loader with its description and code snippet
class LoaderShowcaseWidget extends StatelessWidget {
  /// The title of the loader
  final String title;

  /// A brief description of the loader
  final String description;

  /// The loader widget to display
  final Widget loader;

  /// The default code snippet to display when viewing the loader's code
  final String? codeSnippet;

  /// Creates a loader showcase widget
  const LoaderShowcaseWidget({
    super.key,
    required this.title,
    required this.description,
    required this.loader,
    this.codeSnippet,
  });

  @override
  Widget build(BuildContext context) {
    // Extract loader type for code snippet
    String loaderName = title.replaceAll(' Loader', '');
    String snippet = codeSnippet ?? _getDefaultCodeSnippet(loaderName);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.code, color: Colors.blueGrey),
              tooltip: 'View code snippet',
              onPressed: () {
                _showCodeSnippetBottomSheet(context, title, snippet);
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: loader,
        ),
      ],
    );
  }

  void _showCodeSnippetBottomSheet(
    BuildContext context,
    String title,
    String codeSnippet,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$title Code',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.content_copy),
                        onPressed: () {
                          // Copy code to clipboard
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: SelectableText(
                          codeSnippet,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getDefaultCodeSnippet(String loaderName) {
    // Generate code snippet based on loader name
    String baseName = loaderName.replaceAll(' ', '');

    Map<String, String> loaderColors = {
      'DNAHelix': 'Colors.deepPurple, secondaryColor: Colors.pinkAccent',
      'MorphingShape':
          'Colors.teal, secondaryColor: Colors.amber, tertiaryColor: Colors.deepOrange',
      'GalaxySpiral':
          'Colors.blue, secondaryColor: Colors.purple, tertiaryColor: Colors.white',
      'ParticleVortex':
          'Colors.deepOrange, secondaryColor: Colors.amber, tertiaryColor: Colors.redAccent',
      'FractalTree': 'Colors.green, secondaryColor: Colors.lightGreenAccent',
      'LiquidBlob': 'Colors.blueAccent, secondaryColor: Colors.cyanAccent',
      'Circle': 'Colors.blue',
      'Spinner': 'Colors.purple',
      'Wave': 'Colors.teal',
      'Pulse': 'Colors.blue',
      'Bounce': 'Colors.orange',
      'Dots': 'Colors.indigo',
      'RotatingSquare': 'Colors.red',
      'FlippingCard': 'Colors.amber',
      'Glowing': 'Colors.green',
      'Typing': 'Colors.purple',
    };

    String colors = loaderColors[baseName] ?? 'Colors.blue';
    int duration =
        baseName == 'GalaxySpiral'
            ? 6000
            : baseName == 'FractalTree'
            ? 5000
            : baseName == 'Spinner' ||
                baseName == 'Circle' ||
                baseName == 'Wave'
            ? 1500
            : 3000;

    return 'import \'package:flutter/material.dart\';\n'
        'import \'package:flutter_multiple_loaders/flutter_multiple_loaders.dart\';\n\n'
        'Widget build(BuildContext context) {\n'
        '  return Center(\n'
        '    child: ${baseName}Loader(\n'
        '      options: LoaderOptions(\n'
        '        color: $colors,\n'
        '        size: LoaderSize.large,\n'
        '        durationMs: $duration,\n'
        '      ),\n'
        '    ),\n'
        '  );\n'
        '}\n\n'
        '// With controller example:\n'
        'final LoaderController controller = LoaderController();\n\n'
        '${baseName}Loader(\n'
        '  controller: controller,\n'
        '  options: LoaderOptions(\n'
        '    color: $colors,\n'
        '    size: LoaderSize.large,\n'
        '    durationMs: $duration,\n'
        '  ),\n'
        ');\n\n'
        '// Controller methods:\n'
        '// controller.start();\n'
        '// controller.stop();\n'
        '// controller.reset();';
  }
}
