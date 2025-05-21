import 'package:flutter/material.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Multiple Loaders Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoadersShowcase(),
    );
  }
}

class LoadersShowcase extends StatefulWidget {
  const LoadersShowcase({super.key});

  @override
  State<LoadersShowcase> createState() => _LoadersShowcaseState();
}

class _LoadersShowcaseState extends State<LoadersShowcase> {
  final LoaderController _controller = LoaderController();
  bool _isAnimating = true;
  LoaderSize _selectedSize = LoaderSize.medium;
  Color _selectedColor = Colors.blue;
  int _durationMs = 1500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Multiple Loaders'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 10,
          child: Column(
            children: [
              const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Spinner'),
                  Tab(text: 'Pulse'),
                  Tab(text: 'Bounce'),
                  Tab(text: 'Wave'),
                  Tab(text: 'Circle'),
                  Tab(text: 'Dots'),
                  Tab(text: 'Square'),
                  Tab(text: 'Flipping Card'),
                  Tab(text: 'Glowing'),
                  Tab(text: 'Typing'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildLoaderTab(
                      (options) => SpinnerLoader(
                        options: options,
                        controller: _controller,
                      ),
                    ),
                    _buildLoaderTab(
                      (options) => PulseLoader(
                        options: options,
                        controller: _controller,
                      ),
                    ),
                    _buildLoaderTab(
                      (options) => BounceLoader(
                        options: options,
                        controller: _controller,
                        dotCount: 3,
                      ),
                    ),
                    _buildLoaderTab(
                      (options) => WaveLoader(
                        options: options,
                        controller: _controller,
                        barCount: 5,
                      ),
                    ),
                    _buildLoaderTab(
                      (options) => CircleLoader(
                        options: options,
                        controller: _controller,
                      ),
                    ),
                    _buildLoaderTab(
                      (options) => DotsLoader(
                        options: options,
                        controller: _controller,
                        dotCount: 5,
                      ),
                    ),
                    _buildLoaderTab(
                      (options) => RotatingSquareLoader(
                        options: options,
                        controller: _controller,
                      ),
                    ),
                    _buildLoaderTab(
                      (options) => FlippingCardLoader(
                        options: options,
                        controller: _controller,
                      ),
                    ),
                    _buildLoaderTab(
                      (options) => GlowingLoader(
                        options: options,
                        controller: _controller,
                      ),
                    ),
                    _buildLoaderTab(
                      (options) => TypingLoader(
                        options: options,
                        controller: _controller,
                        dotCount: 3,
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

  Widget _buildLoaderTab(Widget Function(LoaderOptions options) loaderBuilder) {
    // Create loader options from current state each time the widget is built
    final options = LoaderOptions(
      color: _selectedColor,
      size: _selectedSize,
      durationMs: _durationMs,
      loop: _isAnimating,
      backgroundColor: Colors.grey.withAlpha(51), // 0.2 opacity
      secondaryColor: _selectedColor.withAlpha(179), // 0.7 opacity
      tertiaryColor: _selectedColor.withAlpha(102), // 0.4 opacity
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loaderBuilder(options),
          const SizedBox(height: 20),
          Text(
            'Size: ${_selectedSize.name}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'Duration: ${_durationMs}ms',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
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
              const Text('Color:'),
              DropdownButton<Color>(
                value: _selectedColor,
                items: const [
                  DropdownMenuItem(value: Colors.blue, child: Text('Blue')),
                  DropdownMenuItem(value: Colors.red, child: Text('Red')),
                  DropdownMenuItem(value: Colors.green, child: Text('Green')),
                  DropdownMenuItem(value: Colors.purple, child: Text('Purple')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedColor = value;
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
                min: 500,
                max: 3000,
                divisions: 5,
                label: '${_durationMs}ms',
                onChanged: (value) {
                  setState(() {
                    _durationMs = value.toInt();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
