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
        _durationMs = loaderInfo.durationMs;
        _strokeWidth = loaderInfo.strokeWidth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      strokeWidth: _strokeWidth,
    );

    // Create the current loader widget
    final loaderWidget = currentLoader.createLoader(options, _controller);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Multiple Loaders'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category tabs
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs:
                  _categories
                      .map((category) => Tab(text: category.name))
                      .toList(),
            ),

            // Loader selection
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: currentLoaders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ActionChip(
                      avatar: Icon(
                        Icons.circle,
                        color: currentLoaders[index].primaryColor,
                        size: 16,
                      ),
                      label: Text(currentLoaders[index].name),
                      onPressed:
                          () => _updateSelectedLoader(
                            _selectedCategoryIndex,
                            index,
                          ),
                    ),
                  );
                },
              ),
            ),

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

            // Control panel - using fixed version
            LoaderControlPanel(
              controller: _controller,
              isAnimating: _isAnimating,
              selectedSize: _selectedSize,
              primaryColor: _primaryColor,
              secondaryColor: _secondaryColor,
              tertiaryColor: _tertiaryColor,
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
              onDurationChanged: (value) => setState(() => _durationMs = value),
              onStrokeWidthChanged:
                  currentLoader.usesStrokeWidth
                      ? (value) => setState(() => _strokeWidth = value)
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
