import 'package:example/unified_loader_showcase.dart';
import 'package:flutter/material.dart';

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
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Multiple Loaders'),
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flutter Multiple Loaders',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'A comprehensive collection of customizable loading animations',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildNavButton(
              context: context,
              title: 'All Loaders',
              description: 'Explore all loading animations',
              destination: const UnifiedLoaderShowcaseFixed(),
              color: Colors.deepPurple,
              icon: Icons.auto_awesome,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required String title,
    required String description,
    required Widget destination,
    required Color color,
    IconData? icon,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed:
          () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => destination)),
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null) Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*

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
*/
