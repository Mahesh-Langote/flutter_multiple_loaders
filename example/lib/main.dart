import 'package:example/unified_loader_showcase.dart';
import 'package:example/developer_utilities_example.dart';
import 'package:flutter_multiple_loaders/flutter_multiple_loaders.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  // Enable dark mode toggle
  bool _isDarkMode = false;

  // Theme mode based on dark mode setting
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Multiple Loaders Example',
      debugShowCheckedModeBanner: false,
      // Light theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // Dark theme
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // Current theme mode
      themeMode: themeMode,
      // Pass the dark mode toggle function to the main screen
      home: MainScreen(
        toggleDarkMode: _toggleDarkMode,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Function()? toggleDarkMode;
  final bool isDarkMode;

  const MainScreen({super.key, this.toggleDarkMode, this.isDarkMode = false});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late List<Animation<double>> _staggeredAnimations;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _staggeredAnimations = List.generate(
      5,
      (index) => CurvedAnimation(
        parent: _entranceController,
        curve: Interval(index * 0.1, 0.6 + (index * 0.1), curve: Curves.easeOutBack),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          _AnimatedGradientBackground(isDarkMode: widget.isDarkMode),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom Sliver App Bar
              SliverAppBar(
                expandedHeight: isSmallScreen ? 240.0 : 300.0,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  centerTitle: true,
                  title: FadeTransition(
                    opacity: _staggeredAnimations[0],
                    child: Text(
                      'Multiple Loaders',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 18 : 22,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  background: Center(
                    child: FadeTransition(
                      opacity: _staggeredAnimations[1],
                      child: ScaleTransition(
                        scale: _staggeredAnimations[1],
                        child: HourglassLoader(
                          options: LoaderOptions(
                            color: colorScheme.primary,
                            secondaryColor: colorScheme.secondary,
                            size: LoaderSize.large,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: widget.toggleDarkMode,
                    icon: Icon(
                      widget.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Content
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20.0 : screenSize.width * 0.15,
                  vertical: 32.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Header text
                    FadeTransition(
                      opacity: _staggeredAnimations[2],
                      child: SlideTransition(
                        position: _staggeredAnimations[2].drive(
                          Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Premium Animations',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: colorScheme.primary,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Enhance your Flutter apps with beautiful, smooth, and highly customizable loading indicators.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 48),

                    // Main Actions
                    FadeTransition(
                      opacity: _staggeredAnimations[3],
                      child: SlideTransition(
                        position: _staggeredAnimations[3].drive(
                          Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero),
                        ),
                        child: isSmallScreen
                            ? Column(
                                children: [
                                  _buildActionCard(
                                    context: context,
                                    title: 'Showcase Gallery',
                                    subtitle: '20+ Loaders',
                                    description: 'Customize and preview all animations in real-time.',
                                    icon: Icons.auto_awesome_rounded,
                                    color: Colors.indigo,
                                    destination: const UnifiedLoaderShowcaseFixed(),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildActionCard(
                                    context: context,
                                    title: 'Developer Tools',
                                    subtitle: 'Quick Helpers',
                                    description: 'Implementation examples for FutureBuilder and Overlays.',
                                    icon: Icons.terminal_rounded,
                                    color: Colors.teal,
                                    destination: const DeveloperUtilitiesExample(),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: _buildActionCard(
                                      context: context,
                                      title: 'Showcase Gallery',
                                      subtitle: '20+ Loaders',
                                      description: 'Customize and preview all animations in real-time.',
                                      icon: Icons.auto_awesome_rounded,
                                      color: Colors.indigo,
                                      destination: const UnifiedLoaderShowcaseFixed(),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: _buildActionCard(
                                      context: context,
                                      title: 'Developer Tools',
                                      subtitle: 'Quick Helpers',
                                      description: 'Implementation examples for FutureBuilder and Overlays.',
                                      icon: Icons.terminal_rounded,
                                      color: Colors.teal,
                                      destination: const DeveloperUtilitiesExample(),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 56),

                    // Stats / Highlights Section
                    FadeTransition(
                      opacity: _staggeredAnimations[4],
                      child: _buildHighlights(context),
                    ),
                    
                    const SizedBox(height: 64),
                    
                    // Footer
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildSocialButton(
                                context, 
                                Icons.code_rounded, 
                                'GitHub', 
                                'https://github.com/Mahesh-Langote/flutter_multiple_loaders',
                              ),
                              const SizedBox(width: 16),
                              _buildSocialButton(
                                context, 
                                Icons.coffee_rounded, 
                                'Support',
                                'https://buymeacoffee.com/maheshlangote',
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Released under MIT License • v1.1.1',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required Widget destination,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Material(
        color: isDark ? theme.colorScheme.surfaceContainer : Colors.white,
        borderRadius: BorderRadius.circular(32),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => destination),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(icon, color: color, size: 36),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.labelLarge?.copyWith(color: color, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'EXPLORE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios_rounded, color: color, size: 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHighlights(BuildContext context) {
    return Column(
      children: [
        _buildHighlightItem(context, Icons.rocket_launch_rounded, 'Optimized Performance', 'Hardware accelerated animations with zero lag.'),
        const SizedBox(height: 24),
        _buildHighlightItem(context, Icons.extension_rounded, 'Easy Integration', 'Drop-in replacement for default CircularProgressIndicator.'),
        const SizedBox(height: 24),
        _buildHighlightItem(context, Icons.auto_mode_rounded, 'Memory Safe', 'Automatically disposes resources to prevent leaks.'),
      ],
    );
  }

  Widget _buildHighlightItem(BuildContext context, IconData icon, String title, String desc) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(desc, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(BuildContext context, IconData icon, String label, String url) {
    return OutlinedButton.icon(
      onPressed: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not launch $url')),
            );
          }
        }
      },
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}

class _AnimatedGradientBackground extends StatefulWidget {
  final bool isDarkMode;
  const _AnimatedGradientBackground({required this.isDarkMode});

  @override
  State<_AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<_AnimatedGradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.5 + (_controller.value * 0.2), 1.0],
              colors: widget.isDarkMode
                ? [
                    colorScheme.surface,
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
                    colorScheme.surface,
                  ]
                : [
                    colorScheme.surface,
                    colorScheme.primaryContainer.withValues(alpha: 0.1),
                    colorScheme.surface,
                  ],
            ),
          ),
        );
      },
    );
  }
}
