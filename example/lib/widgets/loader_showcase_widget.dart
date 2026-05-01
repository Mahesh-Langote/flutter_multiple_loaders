import 'dart:math';
import 'package:flutter/material.dart';

class LoaderShowcaseWidget extends StatelessWidget {
  final String title;
  final String description;
  final Widget loader;
  final String? codeSnippet;

  const LoaderShowcaseWidget({
    super.key,
    required this.title,
    required this.description,
    required this.loader,
    this.codeSnippet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    String loaderName = title.replaceAll(' Loader', '');
    String snippet = codeSnippet ?? _getDefaultCodeSnippet(loaderName);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double showcaseSize = isSmallScreen
            ? constraints.maxWidth * 0.85
            : min(constraints.maxWidth * 0.75, constraints.maxHeight * 0.7);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'ANIMATION PREVIEW',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Main Loader Container (Glassmorphism inspired)
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: showcaseSize,
                    height: showcaseSize,
                    decoration: BoxDecoration(
                      color: isDark 
                        ? Colors.white.withValues(alpha: 0.03) 
                        : Colors.black.withValues(alpha: 0.02),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: isDark 
                          ? Colors.white.withValues(alpha: 0.05) 
                          : Colors.black.withValues(alpha: 0.05),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Transform.scale(
                        scale: isSmallScreen ? 1.1 : 1.3,
                        child: loader,
                      ),
                    ),
                  ),
                  
                  // Code Button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton.small(
                      heroTag: 'code_btn_$title',
                      onPressed: () => _showCodeSnippetBottomSheet(context, title, snippet),
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      foregroundColor: theme.colorScheme.onSecondaryContainer,
                      elevation: 0,
                      child: const Icon(Icons.code_rounded),
                    ),
                  ),
                ],
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
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    if (isSmallScreen) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return _buildCodePanel(context, title, codeSnippet, scrollController);
            },
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: min(screenSize.width * 0.7, 700),
              maxHeight: min(screenSize.height * 0.8, 600),
            ),
            child: _buildCodePanel(context, title, codeSnippet, null),
          ),
        ),
      );
    }
  }

  Widget _buildCodePanel(BuildContext context, String title, String codeSnippet, ScrollController? scrollController) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Code Snippet',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_all_rounded),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Code Content
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: SelectableText(
                codeSnippet,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getDefaultCodeSnippet(String loaderName) {
    String baseName = loaderName.replaceAll(' ', '');
    Map<String, String> loaderColors = {
      'DNAHelix': 'Colors.deepPurple, secondaryColor: Colors.pinkAccent',
      'MorphingShape': 'Colors.teal, secondaryColor: Colors.amber, tertiaryColor: Colors.deepOrange',
      'GalaxySpiral': 'Colors.blue, secondaryColor: Colors.purple, tertiaryColor: Colors.white',
      'ParticleVortex': 'Colors.deepOrange, secondaryColor: Colors.amber, tertiaryColor: Colors.redAccent',
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
    int duration = baseName == 'GalaxySpiral' ? 6000 : baseName == 'FractalTree' ? 5000 : 3000;

    return 'import \'package:flutter/material.dart\';\n'
        'import \'package:flutter_multiple_loaders/flutter_multiple_loaders.dart\';\n\n'
        'Widget build(BuildContext context) {\n'
        '  return ${baseName}Loader(\n'
        '    options: LoaderOptions(\n'
        '      color: $colors,\n'
        '      size: LoaderSize.large,\n'
        '      durationMs: $duration,\n'
        '    ),\n'
        '  );\n'
        '}';
  }
}
