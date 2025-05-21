import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';

/// A screen showcasing the innovative loaders.
class InnovativeLoadersShowcase extends StatefulWidget {
  /// Creates an [InnovativeLoadersShowcase].
  const InnovativeLoadersShowcase({super.key});

  @override
  State<InnovativeLoadersShowcase> createState() =>
      _InnovativeLoadersShowcaseState();
}

class _InnovativeLoadersShowcaseState extends State<InnovativeLoadersShowcase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Innovative Loaders'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 6,
          child: Column(
            children: [
              const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'DNA Helix'),
                  Tab(text: 'Morphing Shape'),
                  Tab(text: 'Galaxy Spiral'),
                  Tab(text: 'Particle Vortex'),
                  Tab(text: 'Fractal Tree'),
                  Tab(text: 'Liquid Blob'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // DNA Helix tab content
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            _buildSection(
                              title: 'DNA Helix Loader',
                              description:
                                  'An animated double helix that rotates in 3D space',
                              loader: const DnaHelixLoader(
                                options: LoaderOptions(
                                  color: Colors.deepPurple,
                                  secondaryColor: Colors.pinkAccent,
                                  size: LoaderSize.large,
                                  durationMs: 3000,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildCustomizationSection(),
                          ],
                        ),
                      ),
                    ),

                    // Morphing Shape tab content
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            _buildSection(
                              title: 'Morphing Shape Loader',
                              description:
                                  'A shape that morphs between geometric forms',
                              loader: const MorphingShapeLoader(
                                options: LoaderOptions(
                                  color: Colors.teal,
                                  secondaryColor: Colors.amber,
                                  tertiaryColor: Colors.deepOrange,
                                  size: LoaderSize.large,
                                  durationMs: 4000,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildCustomizationSection(),
                          ],
                        ),
                      ),
                    ),

                    // Galaxy Spiral tab content
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            _buildSection(
                              title: 'Galaxy Spiral Loader',
                              description:
                                  'A spiral galaxy with rotating stars and a glowing core',
                              loader: const GalaxySpiralLoader(
                                options: LoaderOptions(
                                  color: Colors.blue,
                                  secondaryColor: Colors.purple,
                                  tertiaryColor: Colors.white,
                                  size: LoaderSize.large,
                                  durationMs: 6000,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildCustomizationSection(),
                          ],
                        ),
                      ),
                    ),

                    // Particle Vortex tab content
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            _buildSection(
                              title: 'Particle Vortex Loader',
                              description:
                                  'Mesmerizing particles flowing in a vortex pattern',
                              loader: const ParticleVortexLoader(
                                options: LoaderOptions(
                                  color: Colors.deepOrange,
                                  secondaryColor: Colors.amber,
                                  tertiaryColor: Colors.redAccent,
                                  size: LoaderSize.large,
                                  durationMs: 3500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildCustomizationSection(),
                          ],
                        ),
                      ),
                    ),

                    // Fractal Tree tab content
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            _buildSection(
                              title: 'Fractal Tree Loader',
                              description:
                                  'A beautiful animated fractal tree inspired by nature',
                              loader: const FractalTreeLoader(
                                options: LoaderOptions(
                                  color: Colors.green,
                                  secondaryColor: Colors.lightGreenAccent,
                                  size: LoaderSize.large,
                                  durationMs: 5000,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildCustomizationSection(),
                          ],
                        ),
                      ),
                    ),

                    // Liquid Blob tab content
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            _buildSection(
                              title: 'Liquid Blob Loader',
                              description:
                                  'Mesmerizing morphing blob with fluid-like motion',
                              loader: const LiquidBlobLoader(
                                options: LoaderOptions(
                                  color: Colors.blueAccent,
                                  secondaryColor: Colors.cyanAccent,
                                  size: LoaderSize.large,
                                  durationMs: 4000,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildCustomizationSection(),
                          ],
                        ),
                      ),
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

  Widget _buildSection({
    required String title,
    required String description,
    required Widget loader,
  }) {
    // Extract loader type for code snippet
    String loaderName = title.replaceAll(' Loader', '');
    String codeSnippet = _getCodeSnippetForLoader(loaderName);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.code, color: Colors.blueGrey),
              tooltip: 'View code snippet',
              onPressed: () {
                _showCodeSnippetBottomSheet(title, codeSnippet);
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
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: loader,
        ),
      ],
    );
  }

  void _showCodeSnippetBottomSheet(String title, String codeSnippet) {
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
                      Flexible(
                        child: Text(
                          '$title Code Example',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: codeSnippet));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Code snippet copied to clipboard'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
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

  String _getCodeSnippetForLoader(String loaderName) {
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
    };

    String colors = loaderColors[baseName] ?? 'Colors.blue';
    int duration =
        baseName == 'GalaxySpiral'
            ? 6000
            : baseName == 'FractalTree'
            ? 5000
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

  Widget _buildCustomizationSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customization Options',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'All loaders can be customized with:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildCustomizationItem(
              'Custom colors (primary, secondary, tertiary)',
            ),
            _buildCustomizationItem('Custom sizes via LoaderSize enum'),
            _buildCustomizationItem('Custom animation durations'),
            _buildCustomizationItem('Looping control'),
            _buildCustomizationItem('External animation controllers'),
            const SizedBox(height: 16),
            const Text(
              'Code Snippets',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildCodeSnippetSection(
              'Basic Usage',
              'import \'package:flutter/material.dart\';\n'
                  'import \'package:flutter_multiple_loaders/flutter_multiple_loaders.dart\';\n\n'
                  '// Show a loader in any widget\n'
                  'Widget build(BuildContext context) {\n'
                  '  return Center(\n'
                  '    child: DnaHelixLoader(\n'
                  '      options: LoaderOptions(\n'
                  '        color: Colors.deepPurple,\n'
                  '        secondaryColor: Colors.pinkAccent,\n'
                  '        size: LoaderSize.large,\n'
                  '        durationMs: 3000,\n'
                  '      ),\n'
                  '    ),\n'
                  '  );\n'
                  '}',
            ),
            const SizedBox(height: 16),
            _buildCodeSnippetSection(
              'Standard Loader Example',
              'import \'package:flutter/material.dart\';\n'
                  'import \'package:flutter_multiple_loaders/flutter_multiple_loaders.dart\';\n\n'
                  'Widget build(BuildContext context) {\n'
                  '  return Center(\n'
                  '    child: CircleLoader(\n'
                  '      options: LoaderOptions(\n'
                  '        color: Colors.blue,\n'
                  '        size: LoaderSize.medium,\n'
                  '        durationMs: 1500,\n'
                  '      ),\n'
                  '    ),\n'
                  '  );\n'
                  '}',
            ),
            const SizedBox(height: 16),
            _buildCodeSnippetSection(
              'With Controller',
              'final LoaderController controller = LoaderController();\n\n'
                  'void startLoader() {\n'
                  '  controller.start();\n'
                  '}\n\n'
                  'void stopLoader() {\n'
                  '  controller.stop();\n'
                  '}\n\n'
                  'Widget build(BuildContext context) {\n'
                  '  return LiquidBlobLoader(\n'
                  '    controller: controller,\n'
                  '    options: LoaderOptions(\n'
                  '      color: Colors.blueAccent,\n'
                  '      secondaryColor: Colors.cyanAccent,\n'
                  '      size: LoaderSize.large,\n'
                  '    ),\n'
                  '  );\n'
                  '}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildCodeSnippetSection(String title, String codeSnippet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 40.0,
                ), // Make room for the copy button
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    codeSnippet,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  tooltip: 'Copy code snippet',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: codeSnippet));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code snippet copied to clipboard'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
