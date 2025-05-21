import 'dart:math';
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
    // Get screen dimensions for responsive adjustments
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    // Extract loader type for code snippet
    String loaderName = title.replaceAll(' Loader', '');
    String snippet = codeSnippet ?? _getDefaultCodeSnippet(loaderName);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the showcase size based on available space
        final double showcaseSize =
            isSmallScreen
                ? constraints.maxWidth * 0.8
                : min(constraints.maxWidth * 0.7, constraints.maxHeight * 0.6);

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header with title and code button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 18 : 22,
                      ),
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
              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              // Loader container with animated appearance
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: showcaseSize,
                height: showcaseSize,
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .05),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(child: loader),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCodeSnippetBottomSheet(
    BuildContext context,
    String title,
    String codeSnippet,
  ) {
    // Check if we're on a small screen
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    // For code snippets, use a different approach based on platform
    if (isSmallScreen) {
      // Use bottom sheet for small screens (mobile)
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        height: 4,
                        width: 40,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '$title Code',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.content_copy),
                              tooltip: 'Copy to clipboard',
                              onPressed: () {
                                // Copy to clipboard
                                // This should use Clipboard.setData in a real implementation
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Code copied to clipboard'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: 'Close',
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Code snippet
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
    } else {
      // Use dialog for larger screens (tablet/desktop)
      showDialog(
        context: context,
        builder:
            (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: min(screenSize.width * 0.8, 800),
                  maxHeight: min(screenSize.height * 0.8, 600),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$title Code Example',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.content_copy),
                              tooltip: 'Copy to clipboard',
                              onPressed: () {
                                // Copy to clipboard
                                // This should use Clipboard.setData in a real implementation
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Code copied to clipboard'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: 'Close',
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Code snippet
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
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

                    // Footer
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
    }
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
