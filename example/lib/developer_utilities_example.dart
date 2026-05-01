import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';

class DeveloperUtilitiesExample extends StatefulWidget {
  const DeveloperUtilitiesExample({super.key});

  @override
  State<DeveloperUtilitiesExample> createState() => _DeveloperUtilitiesExampleState();
}

class _DeveloperUtilitiesExampleState extends State<DeveloperUtilitiesExample> {
  // Simulate a network request
  Future<String>? _dataFuture;

  void _fetchData() {
    setState(() {
      _dataFuture = Future.delayed(
        const Duration(seconds: 3),
        () => 'Data loaded successfully! 🎉',
      );
    });
  }

  void _showOverlayExample() async {
    // Show the overlay
    MultipleLoaders.showOverlay(
      context,
      loader: const SpinnerLoader(
        options: LoaderOptions(
          color: Colors.white,
          size: LoaderSize.large,
        ),
      ),
    );

    // Wait 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Hide the overlay
    if (mounted) {
      MultipleLoaders.hideOverlay(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Background task completed!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      appBar: AppBar(
        title: const Text('Developer Utilities'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 800;
          
          final overlayCard = _buildSectionCard(
            context: context,
            title: 'Loading Overlay Dialog',
            description: 'Blocks user interaction while displaying a loader. Perfect for login or payment processing.',
            icon: Icons.layers,
            gradientColors: [Colors.blue.shade700, Colors.indigo.shade600],
            buttonText: 'Simulate Payment (3s)',
            onPressed: _showOverlayExample,
            codeSnippet: 'MultipleLoaders.showOverlay(\n'
                '  context,\n'
                '  loader: const SpinnerLoader(\n'
                '    options: LoaderOptions(\n'
                '      color: Colors.white,\n'
                '      size: LoaderSize.large,\n'
                '    ),\n'
                '  ),\n'
                ');\n\n'
                '// Wait for task completion...\n\n'
                'MultipleLoaders.hideOverlay(context);',
          );

          final futureBuilderCard = _buildSectionCard(
            context: context,
            title: 'Loader Future Builder',
            description: 'Automatically handles Future states and cleanly displays a beautiful loader while waiting.',
            icon: Icons.hourglass_top,
            gradientColors: [Colors.teal.shade600, Colors.green.shade500],
            buttonText: 'Fetch Server Data',
            onPressed: _fetchData,
            codeSnippet: 'LoaderFutureBuilder<String>(\n'
                '  future: myNetworkRequestFuture,\n'
                '  loader: const CircleLoader(\n'
                '    options: LoaderOptions(\n'
                '      color: Colors.teal,\n'
                '      size: LoaderSize.large,\n'
                '      strokeWidth: 4.0,\n'
                '    ),\n'
                '  ),\n'
                '  builder: (context, data) {\n'
                '    // This only builds when the future completes successfully!\n'
                '    return Text(\'Data loaded: \$data\');\n'
                '  },\n'
                ')',
            child: Container(
              height: 150,
              margin: const EdgeInsets.only(top: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: _dataFuture == null
                  ? Center(
                      child: Text(
                        'Press "Fetch Server Data" to start',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    )
                  : LoaderFutureBuilder<String>(
                      future: _dataFuture,
                      loader: const CircleLoader(
                        options: LoaderOptions(
                          color: Colors.teal,
                          size: LoaderSize.large,
                          strokeWidth: 4.0,
                        ),
                      ),
                      builder: (context, data) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 48),
                              const SizedBox(height: 8),
                              Text(
                                data,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          );

          if (isSmallScreen) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  overlayCard,
                  const SizedBox(height: 24),
                  futureBuilderCard,
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: overlayCard),
                    const SizedBox(width: 24),
                    Expanded(child: futureBuilderCard),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradientColors,
    required String buttonText,
    required VoidCallback onPressed,
    required String codeSnippet,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.code, color: Colors.blueGrey),
                tooltip: 'View code snippet',
                onPressed: () {
                  _showCodeSnippetBottomSheet(title, codeSnippet);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: gradientColors.first,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          if (child != null) child,
        ],
      ),
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
}

