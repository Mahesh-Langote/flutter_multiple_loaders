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
  final LoaderController _controller = LoaderController();
  bool _isAnimating = true;
  LoaderSize _selectedSize = LoaderSize.large;
  Color _primaryColor = Colors.deepPurple;
  Color _secondaryColor = Colors.pinkAccent;
  Color _tertiaryColor = Colors.white;
  int _durationMs = 3000;
  double _strokeWidth = 4.0;
  String _currentLoaderType = 'DNAHelix';
  final Map<String, Map<String, dynamic>> _loaderDefaults = {
    'DNAHelix': {
      'primaryColor': Colors.deepPurple,
      'secondaryColor': Colors.pinkAccent,
      'duration': 3000,
    },
    'MorphingShape': {
      'primaryColor': Colors.teal,
      'secondaryColor': Colors.amber,
      'tertiaryColor': Colors.deepOrange,
      'duration': 3000,
    },
    'GalaxySpiral': {
      'primaryColor': Colors.blue,
      'secondaryColor': Colors.purple,
      'tertiaryColor': Colors.white,
      'duration': 6000,
    },
    'ParticleVortex': {
      'primaryColor': Colors.deepOrange,
      'secondaryColor': Colors.amber,
      'tertiaryColor': Colors.redAccent,
      'duration': 3000,
    },
    'FractalTree': {
      'primaryColor': Colors.green,
      'secondaryColor': Colors.lightGreenAccent,
      'duration': 5000,
    },
    'LiquidBlob': {
      'primaryColor': Colors.blueAccent,
      'secondaryColor': Colors.cyanAccent,
      'duration': 3000,
    },
    'Circle': {'primaryColor': Colors.blue, 'duration': 1500},
    'Spinner': {'primaryColor': Colors.purple, 'duration': 1500},
    'Wave': {'primaryColor': Colors.teal, 'duration': 1500},
  };
  void _updateLoaderType(String loaderType) {
    setState(() {
      _currentLoaderType = loaderType;

      // Set default colors and duration for the selected loader
      final defaults = _loaderDefaults[loaderType];
      if (defaults != null) {
        _primaryColor = defaults['primaryColor'];
        _secondaryColor = defaults['secondaryColor'];
        _tertiaryColor = defaults['tertiaryColor'] ?? Colors.white;
        _durationMs = defaults['duration'];

        // Set specific stroke width for Circle and Spinner loaders
        if (loaderType == 'Circle') {
          _strokeWidth = 5.0;
        } else if (loaderType == 'Spinner') {
          _strokeWidth = 4.0;
        } else {
          _strokeWidth = 4.0; // Default value for other loaders
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Default to first loader type
    _updateLoaderType('DNAHelix');
  }

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
          length: 9,
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
                  Tab(text: 'Circle'),
                  Tab(text: 'Spinner'),
                  Tab(text: 'Wave'),
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
                              loader: DnaHelixLoader(
                                controller: _controller,
                                options: LoaderOptions(
                                  color: _primaryColor,
                                  secondaryColor: _secondaryColor,
                                  size: _selectedSize,
                                  durationMs: _durationMs,
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
                              loader: MorphingShapeLoader(
                                controller: _controller,
                                options: LoaderOptions(
                                  color: _primaryColor,
                                  secondaryColor: _secondaryColor,
                                  tertiaryColor: _tertiaryColor,
                                  size: _selectedSize,
                                  durationMs: _durationMs,
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
                              loader: GalaxySpiralLoader(
                                controller: _controller,
                                options: LoaderOptions(
                                  color: _primaryColor,
                                  secondaryColor: _secondaryColor,
                                  tertiaryColor: _tertiaryColor,
                                  size: _selectedSize,
                                  durationMs: _durationMs,
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
                              loader: ParticleVortexLoader(
                                controller: _controller,
                                options: LoaderOptions(
                                  color: _primaryColor,
                                  secondaryColor: _secondaryColor,
                                  tertiaryColor: _tertiaryColor,
                                  size: _selectedSize,
                                  durationMs: _durationMs,
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
                              loader: FractalTreeLoader(
                                controller: _controller,
                                options: LoaderOptions(
                                  color: _primaryColor,
                                  secondaryColor: _secondaryColor,
                                  size: _selectedSize,
                                  durationMs: _durationMs,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildCustomizationSection(),
                          ],
                        ),
                      ),
                    ), // Liquid Blob tab content
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            _buildSection(
                              title: 'Liquid Blob Loader',
                              description:
                                  'Mesmerizing morphing blob with fluid-like motion',
                              loader: LiquidBlobLoader(
                                controller: _controller,
                                options: LoaderOptions(
                                  color: _primaryColor,
                                  secondaryColor: _secondaryColor,
                                  size: _selectedSize,
                                  durationMs: _durationMs,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildCustomizationSection(),
                          ],
                        ),
                      ),
                    ),

                    // Circle tab content
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            _buildSection(
                              title: 'Circle Loader',
                              description:
                                  'A circular progress indicator with smooth animation',
                              loader: CircleLoader(
                                controller: _controller,
                                options: LoaderOptions(
                                  color: _primaryColor,
                                  size: _selectedSize,
                                  durationMs: _durationMs,
                                  strokeWidth: _strokeWidth,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildCustomizationSection(),
                          ],
                        ),
                      ),
                    ),

                    // Spinner tab content
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            _buildSection(
                              title: 'Spinner Loader',
                              description:
                                  'A classic spinning circular loader animation',
                              loader: SpinnerLoader(
                                controller: _controller,
                                options: LoaderOptions(
                                  color: _primaryColor,
                                  size: _selectedSize,
                                  durationMs: _durationMs,
                                  strokeWidth: _strokeWidth,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildCustomizationSection(),
                          ],
                        ),
                      ),
                    ),

                    // Wave tab content
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          children: [
                            _buildSection(
                              title: 'Wave Loader',
                              description:
                                  'Multiple bars animating in a wave-like pattern',
                              loader: WaveLoader(
                                controller: _controller,
                                barCount: 5,
                                options: LoaderOptions(
                                  color: _primaryColor,
                                  size: _selectedSize,
                                  durationMs: _durationMs,
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
              _buildControlPanel(),
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
            color: Colors.black.withValues(alpha: 0.05),
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
            color: Colors.black.withValues(alpha: 0.05),
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

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filled(
                onPressed: () {
                  setState(() {
                    _isAnimating = !_isAnimating;
                    if (_isAnimating) {
                      _controller.start();
                    } else {
                      _controller.stop();
                    }
                  });
                },
                icon: Icon(_isAnimating ? Icons.pause : Icons.play_arrow),
                tooltip: _isAnimating ? 'Pause' : 'Play',
              ),
              IconButton.filled(
                onPressed: () {
                  setState(() {
                    _isAnimating = true;
                    _controller.reset();
                    _controller.start();
                  });
                },
                icon: const Icon(Icons.refresh),
                tooltip: 'Reset',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Size:'),
              DropdownButton<LoaderSize>(
                value: _selectedSize,
                items:
                    LoaderSize.values
                        .where((size) => size != LoaderSize.custom)
                        .map(
                          (size) => DropdownMenuItem(
                            value: size,
                            child: Text(size.name),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSize = value;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Primary Color:'),
              DropdownButton<Color>(
                value: _primaryColor,
                items: const [
                  DropdownMenuItem(
                    value: Colors.deepPurple,
                    child: Text('Deep Purple'),
                  ),
                  DropdownMenuItem(value: Colors.blue, child: Text('Blue')),
                  DropdownMenuItem(value: Colors.teal, child: Text('Teal')),
                  DropdownMenuItem(
                    value: Colors.deepOrange,
                    child: Text('Deep Orange'),
                  ),
                  DropdownMenuItem(value: Colors.green, child: Text('Green')),
                  DropdownMenuItem(
                    value: Colors.blueAccent,
                    child: Text('Blue Accent'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _primaryColor = value;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Secondary Color:'),
              DropdownButton<Color>(
                value: _secondaryColor,
                items: const [
                  DropdownMenuItem(
                    value: Colors.pinkAccent,
                    child: Text('Pink Accent'),
                  ),
                  DropdownMenuItem(value: Colors.amber, child: Text('Amber')),
                  DropdownMenuItem(value: Colors.purple, child: Text('Purple')),
                  DropdownMenuItem(
                    value: Colors.redAccent,
                    child: Text('Red Accent'),
                  ),
                  DropdownMenuItem(
                    value: Colors.lightGreenAccent,
                    child: Text('Light Green Accent'),
                  ),
                  DropdownMenuItem(
                    value: Colors.cyanAccent,
                    child: Text('Cyan Accent'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _secondaryColor = value;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Duration:'),
              Slider(
                value: _durationMs.toDouble(),
                min: 1000,
                max: 6000,
                divisions: 10,
                label: '${_durationMs}ms',
                onChanged: (value) {
                  setState(() {
                    _durationMs = value.toInt();
                  });
                },
              ),
            ],
          ), // Add stroke width control for Circle and Spinner loaders
          if (_currentLoaderType == 'Circle' || _currentLoaderType == 'Spinner')
            Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Stroke Width:'),
                    Slider(
                      value: _strokeWidth,
                      min: 1.0,
                      max: 10.0,
                      divisions: 9,
                      label: _strokeWidth.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _strokeWidth = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
