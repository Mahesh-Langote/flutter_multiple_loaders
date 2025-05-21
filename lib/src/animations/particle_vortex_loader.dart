import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A particle vortex loader animation.
///
/// This loader displays particles flowing in a mesmerizing vortex pattern,
/// with customizable flow speed, particle count, and color schemes.
class ParticleVortexLoader extends StatefulWidget {
  /// Options to customize the loader appearance and behavior.
  final LoaderOptions options;

  /// Optional external controller for the animation.
  final LoaderController? controller;

  /// Creates a [ParticleVortexLoader] with the given options.
  const ParticleVortexLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
  });

  @override
  State<ParticleVortexLoader> createState() => _ParticleVortexLoaderState();
}

class _ParticleVortexLoaderState extends State<ParticleVortexLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late LoaderController _loaderController;

  final math.Random _random = math.Random();
  late List<_VortexParticle> _particles;
  final int _particleCount = 80;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _loaderController = widget.controller ?? LoaderController();
    _loaderController.initialize(_animationController);

    _initializeParticles();

    if (widget.options.loop) {
      _animationController.repeat();
    } else {
      _animationController.forward();
    }
  }

  void _initializeParticles() {
    _particles = List<_VortexParticle>.generate(
      _particleCount,
      (_) => _VortexParticle(
        distance: 0.1 + _random.nextDouble() * 0.9,
        angle: _random.nextDouble() * 2 * math.pi,
        speed: 0.5 + _random.nextDouble() * 1.5,
        size: 1.0 + _random.nextDouble() * 3.0,
        colorIndex: _random.nextInt(3),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.stop();
    if (widget.controller == null) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(ParticleVortexLoader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.options.durationMs != widget.options.durationMs) {
      _animationController.duration = Duration(
        milliseconds: widget.options.durationMs,
      );
    }

    if (oldWidget.options.loop != widget.options.loop) {
      if (widget.options.loop) {
        _animationController.repeat();
      } else {
        _animationController.forward();
      }
    }

    if (widget.controller != oldWidget.controller) {
      _loaderController = widget.controller ?? LoaderController();
      _loaderController.initialize(_animationController);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.options.size.value;

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _VortexPainter(
              progress: _animationController.value,
              particles: _particles,
              primaryColor: widget.options.color,
              secondaryColor:
                  widget.options.secondaryColor ??
                  widget.options.color.withOpacity(0.7),
              tertiaryColor:
                  widget.options.tertiaryColor ??
                  widget.options.color.withOpacity(0.4),
            ),
            size: Size.square(size),
          );
        },
      ),
    );
  }
}

class _VortexParticle {
  double distance;
  double angle;
  final double speed;
  final double size;
  final int colorIndex;

  _VortexParticle({
    required this.distance,
    required this.angle,
    required this.speed,
    required this.size,
    required this.colorIndex,
  });

  void update(double progress) {
    // Update the angle based on the speed and distance from center
    // Particles closer to the center rotate faster
    angle += speed * (1.0 - distance * 0.5) * 0.05;

    // Gradually move particles toward the center, then respawn them at the edge
    distance -= 0.003 * speed;
    if (distance <= 0.05) {
      distance = 1.0;
    }
  }
}

class _VortexPainter extends CustomPainter {
  final double progress;
  final List<_VortexParticle> particles;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;

  _VortexPainter({
    required this.progress,
    required this.particles,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Create color list
    final colors = [primaryColor, secondaryColor, tertiaryColor];

    // Update and draw each particle
    for (var particle in particles) {
      particle.update(progress);

      // Calculate position
      final x =
          center.dx + math.cos(particle.angle) * particle.distance * radius;
      final y =
          center.dy + math.sin(particle.angle) * particle.distance * radius;

      // Draw particle with a tail/streak effect for motion blur
      final tailPaint =
          Paint()
            ..color = colors[particle.colorIndex].withOpacity(0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = particle.size * 0.5;

      final startAngle = particle.angle - 0.3;
      final tailX =
          center.dx + math.cos(startAngle) * particle.distance * radius;
      final tailY =
          center.dy + math.sin(startAngle) * particle.distance * radius;

      canvas.drawLine(Offset(tailX, tailY), Offset(x, y), tailPaint);

      // Draw the particle
      final paint =
          Paint()
            ..color = colors[particle.colorIndex]
            ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particle.size, paint);

      // Add glow effect
      final glowPaint =
          Paint()
            ..color = colors[particle.colorIndex].withOpacity(0.2)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

      canvas.drawCircle(Offset(x, y), particle.size * 1.8, glowPaint);
    }

    // Draw center glow effect
    final centerGlowPaint =
        Paint()
          ..color = primaryColor.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0);

    canvas.drawCircle(center, radius * 0.2, centerGlowPaint);
  }

  @override
  bool shouldRepaint(_VortexPainter oldPainter) {
    return progress != oldPainter.progress;
  }
}
