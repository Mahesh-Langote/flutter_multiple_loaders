import 'package:flutter/material.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';
import 'widgets/loader_category_manager.dart';
import 'widgets/loader_control_panel.dart';
import 'widgets/loader_showcase_widget.dart';

class UnifiedLoaderShowcaseFixed extends StatefulWidget {
  const UnifiedLoaderShowcaseFixed({super.key});

  @override
  State<UnifiedLoaderShowcaseFixed> createState() =>
      _UnifiedLoaderShowcaseFixedState();
}

class _UnifiedLoaderShowcaseFixedState extends State<UnifiedLoaderShowcaseFixed>
    with SingleTickerProviderStateMixin {
  final LoaderController _controller = LoaderController();
  late TabController _tabController;

  bool _isAnimating = true;
  LoaderSize _selectedSize = LoaderSize.large;
  Color _primaryColor = Colors.blue;
  Color _secondaryColor = Colors.pinkAccent;
  Color _tertiaryColor = Colors.white;
  Color _quaternaryColor = Colors.purple;
  int _durationMs = 1500;
  double _strokeWidth = 4.0;

  int _selectedCategoryIndex = 0;
  int _selectedLoaderIndex = 0;
  List<LoaderCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _categories = LoaderCategoryManager.getCategories();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabChange);
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
        _quaternaryColor = Colors.purple;
        _durationMs = loaderInfo.durationMs;
        _strokeWidth = loaderInfo.strokeWidth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;

    if (_categories.isEmpty) {
      return const Scaffold(body: Center(child: Text('No loaders available')));
    }

    final currentCategory = _categories[_selectedCategoryIndex];
    final currentLoader = currentCategory.loaders[_selectedLoaderIndex];

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

    final loaderWidget = currentLoader.createLoader(options, _controller);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Showcase Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Selector
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 40,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colorScheme.primary,
                ),
                labelColor: colorScheme.onPrimary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                tabs: _categories.map((c) => Tab(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )).toList(),
              ),
            ),

            // Loader Sub-selection
            _buildLoaderChips(currentCategory.loaders),

            Expanded(
              child: isLandscape && screenSize.width >= 900
                ? Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: LoaderShowcaseWidget(
                          title: currentLoader.name,
                          description: currentLoader.description,
                          loader: loaderWidget,
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      SizedBox(
                        width: 350,
                        child: _buildControlPanel(context),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: LoaderShowcaseWidget(
                          title: currentLoader.name,
                          description: currentLoader.description,
                          loader: loaderWidget,
                        ),
                      ),
                      _buildMobileControlBar(context),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileControlBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _showConfigurationSheet(context),
                icon: const Icon(Icons.tune_rounded),
                label: const Text('Configure Loader'),
              ),
            ),
            const SizedBox(width: 12),
            IconButton.filledTonal(
              onPressed: () {
                setState(() => _isAnimating = !_isAnimating);
                if (_isAnimating) {
                  _controller.start();
                } else {
                  _controller.stop();
                }
              },
              icon: Icon(_isAnimating ? Icons.pause_rounded : Icons.play_arrow_rounded),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfigurationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: _buildControlPanel(
                    context, 
                    isBottomSheet: true,
                    onUpdate: () => setSheetState(() {}),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoaderChips(List<LoaderInfo> loaders) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: loaders.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedLoaderIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(loaders[index].name),
              selected: isSelected,
              onSelected: (_) => _updateSelectedLoader(_selectedCategoryIndex, index),
              showCheckmark: false,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context, {bool isBottomSheet = false, VoidCallback? onUpdate}) {
    final currentCategory = _categories[_selectedCategoryIndex];
    final currentLoader = currentCategory.loaders[_selectedLoaderIndex];

    return LoaderControlPanel(
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
      isBottomSheet: isBottomSheet,
      onAnimatingChanged: (v) => setState(() {
        _isAnimating = v;
        onUpdate?.call();
      }),
      onSizeChanged: (v) => setState(() {
        _selectedSize = v;
        onUpdate?.call();
      }),
      onPrimaryColorChanged: (v) => setState(() {
        _primaryColor = v;
        onUpdate?.call();
      }),
      onSecondaryColorChanged: (v) => setState(() {
        _secondaryColor = v;
        onUpdate?.call();
      }),
      onTertiaryColorChanged: (v) => setState(() {
        _tertiaryColor = v;
        onUpdate?.call();
      }),
      onQuaternaryColorChanged: (v) => setState(() {
        _quaternaryColor = v;
        onUpdate?.call();
      }),
      onDurationChanged: (v) => setState(() {
        _durationMs = v;
        onUpdate?.call();
      }),
      onStrokeWidthChanged: (v) => setState(() {
        _strokeWidth = v;
        onUpdate?.call();
      }),
    );
  }
}
