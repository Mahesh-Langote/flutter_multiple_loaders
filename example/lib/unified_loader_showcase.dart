import 'package:flutter/material.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';
import 'widgets/loader_category_manager.dart';
import 'widgets/loader_control_panel.dart'; // Using the fixed version
import 'widgets/loader_showcase_widget.dart';

/// A unified screen showcasing all loaders in a well-organized manner
class UnifiedLoaderShowcaseFixed extends StatefulWidget {
  /// Creates a [UnifiedLoaderShowcaseFixed].
  const UnifiedLoaderShowcaseFixed({super.key});

  @override
  State<UnifiedLoaderShowcaseFixed> createState() =>
      _UnifiedLoaderShowcaseFixedState();
}

class _UnifiedLoaderShowcaseFixedState extends State<UnifiedLoaderShowcaseFixed>
    with SingleTickerProviderStateMixin {
  final LoaderController _controller = LoaderController();
  late TabController _tabController;

  // Current loader state
  bool _isAnimating = true;
  LoaderSize _selectedSize = LoaderSize.large;
  Color _primaryColor = Colors.blue;
  Color _secondaryColor = Colors.pinkAccent;
  Color _tertiaryColor = Colors.white;
  Color _quaternaryColor = Colors.purple;
  int _durationMs = 1500;
  double _strokeWidth = 4.0;

  // Current loader and category selection
  int _selectedCategoryIndex = 0;
  int _selectedLoaderIndex = 0;
  List<LoaderCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    // Get all loader categories
    _categories = LoaderCategoryManager.getCategories();

    // Set up tab controller for all categories
    _tabController = TabController(length: _categories.length, vsync: this);

    _tabController.addListener(_handleTabChange);

    // Set initial loader values
    _updateSelectedLoader(0, 0);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _selectedCategoryIndex = _tabController.index;
        _selectedLoaderIndex = 0;
        _updateSelectedLoader(_selectedCategoryIndex, _selectedLoaderIndex);
      });
    }
  }

  void _updateSelectedLoader(int categoryIndex, int loaderIndex) {
    if (categoryIndex < _categories.length &&
        loaderIndex < _categories[categoryIndex].loaders.length) {
      final loaderInfo = _categories[categoryIndex].loaders[loaderIndex];

      setState(() {
        _selectedCategoryIndex = categoryIndex;
        _selectedLoaderIndex = loaderIndex;
        _primaryColor = loaderInfo.primaryColor;
        _secondaryColor =
            loaderInfo.secondaryColor ?? _primaryColor.withValues(alpha: 0.7);
        _tertiaryColor = loaderInfo.tertiaryColor ?? Colors.white;
        _quaternaryColor = Colors.purple; // Default quaternary color
        _durationMs = loaderInfo.durationMs;
        _strokeWidth = loaderInfo.strokeWidth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    final bool isLandscape = screenSize.width > screenSize.height;

    if (_categories.isEmpty) {
      return const Scaffold(body: Center(child: Text('No loaders available')));
    }

    final currentCategory = _categories[_selectedCategoryIndex];
    final currentLoaders = currentCategory.loaders;
    final currentLoader = currentLoaders[_selectedLoaderIndex];

    // Create loader options based on current state
    final options = LoaderOptions(
      color: _primaryColor,
      size: _selectedSize,
      durationMs: _durationMs,
      loop: _isAnimating,
      backgroundColor: Colors.grey.withAlpha(51),
      secondaryColor: _secondaryColor,
      tertiaryColor: _tertiaryColor,
      quaternaryColor: _quaternaryColor,
      strokeWidth: _strokeWidth,
    );

    // Create the current loader widget
    final loaderWidget = currentLoader.createLoader(options, _controller);

    // Create an adaptive layout based on screen orientation and size
    Widget content;

    if (isLandscape && screenSize.width >= 900) {
      // Wide landscape layout - side by side
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left panel - showcase
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Category tabs
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs:
                      _categories
                          .map((category) => Tab(text: category.name))
                          .toList(),
                ),

                // Loader selection
                _buildLoaderSelection(currentLoaders),

                // Loader showcase
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LoaderShowcaseWidget(
                      title: '${currentLoader.name} Loader',
                      description: currentLoader.description,
                      loader: loaderWidget,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right panel - controls
          Expanded(
            flex: 2,
            child: LoaderControlPanel(
              controller: _controller,
              isAnimating: _isAnimating,
              selectedSize: _selectedSize,
              primaryColor: _primaryColor,
              secondaryColor: _secondaryColor,
              tertiaryColor: _tertiaryColor,
              quaternaryColor: _quaternaryColor,
              durationMs: _durationMs,
              strokeWidth: _strokeWidth,
              showStrokeWidth: currentLoader.usesStrokeWidth,
              onAnimatingChanged:
                  (value) => setState(() => _isAnimating = value),
              onSizeChanged: (value) => setState(() => _selectedSize = value),
              onPrimaryColorChanged:
                  (value) => setState(() => _primaryColor = value),
              onSecondaryColorChanged:
                  (value) => setState(() => _secondaryColor = value),
              onTertiaryColorChanged:
                  (value) => setState(() => _tertiaryColor = value),
              onQuaternaryColorChanged:
                  (value) => setState(() => _quaternaryColor = value),
              onDurationChanged: (value) => setState(() => _durationMs = value),
              onStrokeWidthChanged:
                  currentLoader.usesStrokeWidth
                      ? (value) => setState(() => _strokeWidth = value)
                      : null,
            ),
          ),
        ],
      );
    } else {
      // Portrait or narrow layout - stacked vertically
      content = Column(
        children: [
          // Category tabs with scrollable behavior for small screens
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs:
                _categories
                    .map((category) => Tab(text: category.name))
                    .toList(),
          ),

          // Loader selection
          _buildLoaderSelection(currentLoaders),

          // Loader showcase
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
              child: LoaderShowcaseWidget(
                title: '${currentLoader.name} Loader',
                description: currentLoader.description,
                loader: loaderWidget,
              ),
            ),
          ),

          // Control panel
          LoaderControlPanel(
            controller: _controller,
            isAnimating: _isAnimating,
            selectedSize: _selectedSize,
            primaryColor: _primaryColor,
            secondaryColor: _secondaryColor,
            tertiaryColor: _tertiaryColor,
            quaternaryColor: _quaternaryColor,
            durationMs: _durationMs,
            strokeWidth: _strokeWidth,
            showStrokeWidth: currentLoader.usesStrokeWidth,
            onAnimatingChanged: (value) => setState(() => _isAnimating = value),
            onSizeChanged: (value) => setState(() => _selectedSize = value),
            onPrimaryColorChanged:
                (value) => setState(() => _primaryColor = value),
            onSecondaryColorChanged:
                (value) => setState(() => _secondaryColor = value),
            onTertiaryColorChanged:
                (value) => setState(() => _tertiaryColor = value),
            onQuaternaryColorChanged:
                (value) => setState(() => _quaternaryColor = value),
            onDurationChanged: (value) => setState(() => _durationMs = value),
            onStrokeWidthChanged:
                currentLoader.usesStrokeWidth
                    ? (value) => setState(() => _strokeWidth = value)
                    : null,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Multiple Loaders',
          style: isSmallScreen ? const TextStyle(fontSize: 18) : null,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'About',
          ),
        ],
      ),
      body: SafeArea(child: content),
    );
  }

  // Extract loader selection into a separate method
  Widget _buildLoaderSelection(List<LoaderInfo> loaders) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return SizedBox(
      height: isSmallScreen ? 50 : 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 16,
          vertical: isSmallScreen ? 6 : 8,
        ),
        itemCount: loaders.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedLoaderIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ActionChip(
              avatar: Icon(
                Icons.circle,
                color: loaders[index].primaryColor,
                size: 16,
              ),
              label: Text(
                loaders[index].name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              backgroundColor:
                  isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
              onPressed:
                  () => _updateSelectedLoader(_selectedCategoryIndex, index),
            ),
          );
        },
      ),
    );
  }

  // Add info dialog
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About Flutter Multiple Loaders'),
            content: const SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A comprehensive collection of customizable loading animations for Flutter applications.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Features:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Multiple loader types'),
                  Text('• Customizable colors'),
                  Text('• Adjustable sizes'),
                  Text('• Animation control'),
                  Text('• Responsive design'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
