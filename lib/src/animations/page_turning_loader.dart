import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/loader_options.dart';
import '../utils/loader_controller.dart';

/// A realistic page turning loader with right-to-left page flipping.
class PageTurningLoader extends StatefulWidget {
  final LoaderOptions options;
  final LoaderController? controller;
  final int pageCount;

  const PageTurningLoader({
    super.key,
    this.options = const LoaderOptions(),
    this.controller,
    this.pageCount = 4,
  });

  @override
  State<PageTurningLoader> createState() => _PageTurningLoaderState();
}

class _PageTurningLoaderState extends State<PageTurningLoader>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pageController;
  late Animation<double> _pageFlipAnimation;
  late Animation<double> _curlAnimation;
  late LoaderController _loaderController;

  int _currentPageIndex = 0;
  bool _isFlipping = false;
  List<int> _leftPages = [];
  List<int> _rightPages = [];

  @override
  void initState() {
    super.initState();

    // Initialize page stacks
    _rightPages = List.generate(widget.pageCount, (index) => index);
    _leftPages = [];

    _mainController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.options.durationMs),
    );

    _pageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pageFlipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOutCubic),
    ));

    _curlAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
    ));

    _loaderController = widget.controller ?? LoaderController();
    _loaderController.initialize(_mainController);

    _startPageFlipping();
  }

  void _startPageFlipping() async {
    if (widget.options.loop) {
      while (mounted) {
        await _flipToNextPage();
        if (!mounted) break;
        await Future.delayed(const Duration(milliseconds: 800));

        // Reset when all pages are flipped
        if (_rightPages.isEmpty) {
          _resetPages();
        }
      }
    } else {
      for (int i = 0; i < widget.pageCount; i++) {
        if (!mounted) break;
        await _flipToNextPage();
        if (i < widget.pageCount - 1) {
          await Future.delayed(const Duration(milliseconds: 800));
        }
      }
    }
  }

  void _resetPages() {
    setState(() {
      _rightPages = List.generate(widget.pageCount, (index) => index);
      _leftPages = [];
      _currentPageIndex = 0;
    });
  }

  Future<void> _flipToNextPage() async {
    if (!mounted || _rightPages.isEmpty) return;

    setState(() {
      _isFlipping = true;
    });

    await _pageController.forward();

    if (mounted) {
      setState(() {
        // Move page from right stack to left stack
        final flippedPage = _rightPages.removeAt(_rightPages.length - 1);
        _leftPages.add(flippedPage);
        _currentPageIndex = (_currentPageIndex + 1) % widget.pageCount;
        _isFlipping = false;
      });
      _pageController.reset();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.options.size.value;
    final bookWidth = size * 1.6;
    final bookHeight = size;

    return Container(
      width: bookWidth,
      height: bookHeight,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pageFlipAnimation, _curlAnimation]),
        builder: (context, child) {
          return CustomPaint(
            painter: _RealisticPageFlipPainter(
              leftPages: _leftPages,
              rightPages: _rightPages,
              flipProgress: _pageFlipAnimation.value,
              curlProgress: _curlAnimation.value,
              isFlipping: _isFlipping,
              pageCount: widget.pageCount,
              color: widget.options.color,
              secondaryColor: widget.options.secondaryColor ??
                  widget.options.color.withOpacity(0.7),
              backgroundColor: widget.options.tertiaryColor ?? Colors.white,
            ),
          );
        },
      ),
    );
  }
}

class _RealisticPageFlipPainter extends CustomPainter {
  final List<int> leftPages;
  final List<int> rightPages;
  final double flipProgress;
  final double curlProgress;
  final bool isFlipping;
  final int pageCount;
  final Color color;
  final Color secondaryColor;
  final Color backgroundColor;

  _RealisticPageFlipPainter({
    required this.leftPages,
    required this.rightPages,
    required this.flipProgress,
    required this.curlProgress,
    required this.isFlipping,
    required this.pageCount,
    required this.color,
    required this.secondaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    // Draw book base and spine
    _drawBookBase(canvas, size, paint);

    // Draw left pages stack
    _drawLeftPagesStack(canvas, size, paint);

    // Draw right pages stack
    _drawRightPagesStack(canvas, size, paint);

    // Draw the currently flipping page
    if (isFlipping && flipProgress > 0) {
      _drawFlippingPage(canvas, size, paint);
    }

    // Draw book binding and details
    _drawBookDetails(canvas, size, paint);
  }

  void _drawBookBase(Canvas canvas, Size size, Paint paint) {
    // Book cover background
    final coverRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(6),
    );

    paint.color = color.withOpacity(0.9);
    canvas.drawRRect(coverRect, paint);

    // Cover texture
    final coverGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withOpacity(0.8),
        color,
        color.withOpacity(0.95),
      ],
    );

    paint.shader = coverGradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    canvas.drawRRect(coverRect, paint);
    paint.shader = null;
  }

  void _drawLeftPagesStack(Canvas canvas, Size size, Paint paint) {
    final pageWidth = size.width * 0.44;
    final pageHeight = size.height * 0.88;
    final pageTop = size.height * 0.06;
    final stackLeft = size.width * 0.06;

    // Draw each page in the left stack with slight offset for thickness
    for (int i = 0; i < leftPages.length; i++) {
      final pageIndex = leftPages[i];
      final offset = i * 1.5; // Stack thickness

      final pageRect = Rect.fromLTWH(
        stackLeft + offset,
        pageTop,
        pageWidth - offset,
        pageHeight,
      );

      // Page shadow for depth
      if (i > 0) {
        final shadowPaint = Paint()
          ..color = Colors.black.withOpacity(0.05)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            pageRect.translate(1, 1),
            const Radius.circular(3),
          ),
          shadowPaint,
        );
      }

      // Page background
      paint.color = backgroundColor;
      if (i == leftPages.length - 1) {
        // Top page is slightly brighter
        paint.color = backgroundColor;
      } else {
        paint.color = backgroundColor.withOpacity(0.95);
      }

      canvas.drawRRect(
        RRect.fromRectAndRadius(pageRect, const Radius.circular(3)),
        paint,
      );

      // Draw content only on the top page
      if (i == leftPages.length - 1) {
        _drawPageContent(canvas, pageRect, pageIndex, isLeftPage: true);
      }

      // Page edge lines for thickness effect
      if (i < leftPages.length - 1) {
        final edgePaint = Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..strokeWidth = 0.5;

        canvas.drawLine(
          Offset(pageRect.right, pageRect.top),
          Offset(pageRect.right, pageRect.bottom),
          edgePaint,
        );
      }
    }
  }

  void _drawRightPagesStack(Canvas canvas, Size size, Paint paint) {
    final pageWidth = size.width * 0.44;
    final pageHeight = size.height * 0.88;
    final pageTop = size.height * 0.06;
    final stackRight = size.width * 0.94;

    // Draw each page in the right stack
    for (int i = 0; i < rightPages.length; i++) {
      final pageIndex = rightPages[i];
      final offset = (rightPages.length - 1 - i) * 1.5; // Stack thickness

      final pageRect = Rect.fromLTWH(
        stackRight - pageWidth + offset,
        pageTop,
        pageWidth - offset,
        pageHeight,
      );

      // Skip drawing the top page if it's currently flipping
      if (i == rightPages.length - 1 && isFlipping) continue;

      // Page shadow for depth
      if (i < rightPages.length - 1) {
        final shadowPaint = Paint()
          ..color = Colors.black.withOpacity(0.05)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            pageRect.translate(-1, 1),
            const Radius.circular(3),
          ),
          shadowPaint,
        );
      }

      // Page background
      paint.color = backgroundColor;
      if (i == rightPages.length - 1) {
        paint.color = backgroundColor;
      } else {
        paint.color = backgroundColor.withOpacity(0.95);
      }

      canvas.drawRRect(
        RRect.fromRectAndRadius(pageRect, const Radius.circular(3)),
        paint,
      );

      // Draw content only on the top page
      if (i == rightPages.length - 1) {
        _drawPageContent(canvas, pageRect, pageIndex, isLeftPage: false);
      }

      // Page edge lines
      if (i < rightPages.length - 1) {
        final edgePaint = Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..strokeWidth = 0.5;

        canvas.drawLine(
          Offset(pageRect.left, pageRect.top),
          Offset(pageRect.left, pageRect.bottom),
          edgePaint,
        );
      }
    }
  }

  void _drawFlippingPage(Canvas canvas, Size size, Paint paint) {
    if (rightPages.isEmpty) return;

    canvas.save();

    final pageWidth = size.width * 0.44;
    final pageHeight = size.height * 0.88;
    final pageTop = size.height * 0.06;

    // Page starting position (right side)
    final startX = size.width * 0.5;
    final endX = size.width * 0.06;

    // Calculate current position based on flip progress
    final currentX = startX + (endX - startX) * flipProgress;
    final centerY = pageTop + pageHeight * 0.5;

    // Page curl effect - starts from top-right corner
    final curlIntensity = curlProgress * (1 - flipProgress * 0.7);
    final curlHeight = pageHeight * 0.15 * curlIntensity;
    final curlWidth = pageWidth * 0.2 * curlIntensity;

    // 3D rotation effect
    final rotationAngle = math.pi * flipProgress;
    final perspectiveScale = math.cos(rotationAngle).abs();

    canvas.translate(currentX + pageWidth * 0.5, centerY);

    // Apply 3D transformation
    final transform = Matrix4.identity();
    transform.setEntry(3, 2, -0.001); // Perspective
    transform.rotateY(rotationAngle);

    canvas.transform(transform.storage);

    // Draw page shadow during flip
    final shadowIntensity = 0.4 * math.sin(rotationAngle);
    if (shadowIntensity > 0) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(shadowIntensity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6 + 4 * flipProgress);

      final shadowOffset = Offset(
        3 * math.sin(rotationAngle),
        2 + 3 * flipProgress,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: shadowOffset,
            width: pageWidth * perspectiveScale,
            height: pageHeight,
          ),
          const Radius.circular(3),
        ),
        shadowPaint,
      );
    }

    // Draw the flipping page
    final pageRect = Rect.fromCenter(
      center: Offset.zero,
      width: pageWidth * perspectiveScale,
      height: pageHeight,
    );

    paint.color = backgroundColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(pageRect, const Radius.circular(3)),
      paint,
    );

    // Draw page content (considering it's flipping, so content might be reversed)
    final flippingPageIndex = rightPages.last;
    canvas.save();
    if (flipProgress > 0.5) {
      // When more than halfway flipped, show the back side
      canvas.scale(-1, 1);
    }
    _drawPageContent(canvas, pageRect, flippingPageIndex,
        isLeftPage: flipProgress > 0.5);
    canvas.restore();

    // Draw page curl highlight
    if (curlIntensity > 0.1) {
      final curlPaint = Paint()
        ..color = Colors.white.withOpacity(0.6 * curlIntensity)
        ..style = PaintingStyle.fill;

      final curlPath = Path();
      curlPath.moveTo(pageRect.right - curlWidth, pageRect.top);
      curlPath.quadraticBezierTo(
        pageRect.right + curlWidth * 0.3,
        pageRect.top - curlHeight * 0.5,
        pageRect.right - curlWidth * 0.5,
        pageRect.top + curlHeight,
      );
      curlPath.quadraticBezierTo(
        pageRect.right - curlWidth * 0.8,
        pageRect.top + curlHeight * 0.3,
        pageRect.right - curlWidth,
        pageRect.top,
      );
      curlPath.close();

      canvas.drawPath(curlPath, curlPaint);

      // Curl shadow
      final curlShadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.2 * curlIntensity)
        ..style = PaintingStyle.fill;

      final shadowPath = Path();
      shadowPath.addPath(curlPath, Offset(1, 1));
      canvas.drawPath(shadowPath, curlShadowPaint);
    }

    canvas.restore();
  }

  void _drawPageContent(Canvas canvas, Rect pageRect, int pageIndex,
      {required bool isLeftPage}) {
    final contentPaint = Paint()
      ..color = secondaryColor.withOpacity(0.8)
      ..strokeWidth = 0.8;

    // Adjust content area based on page side
    final contentRect = Rect.fromLTWH(
      pageRect.left + pageRect.width * (isLeftPage ? 0.08 : 0.12),
      pageRect.top + pageRect.height * 0.12,
      pageRect.width * 0.8,
      pageRect.height * 0.76,
    );

    // Page number
    final pageNumberPaint = Paint()
      ..color = secondaryColor.withOpacity(0.6)
      ..strokeWidth = 0.6;

    final pageNumY = pageRect.bottom - pageRect.height * 0.05;
    final pageNumX = isLeftPage
        ? contentRect.left
        : contentRect.right - pageRect.width * 0.1;

    canvas.drawLine(
      Offset(pageNumX, pageNumY),
      Offset(pageNumX + pageRect.width * 0.08, pageNumY),
      pageNumberPaint,
    );

    // Draw text lines with realistic variation
    final lineCount = 14 + (pageIndex % 3);
    final lineSpacing = contentRect.height / 16;

    for (int i = 0; i < lineCount && i < 15; i++) {
      final y = contentRect.top + (i * lineSpacing);

      double lineWidth;
      if (i == 0) {
        // Title
        lineWidth = contentRect.width * 0.7;
        contentPaint.strokeWidth = 1.2;
      } else if (i == 1) {
        // Subtitle
        lineWidth = contentRect.width * 0.5;
        contentPaint.strokeWidth = 0.9;
      } else if (i % 5 == 0) {
        // Paragraph break
        lineWidth = contentRect.width * 0.6;
        contentPaint.strokeWidth = 0.8;
      } else {
        // Regular text with natural variation
        final seed = pageIndex * 7 + i * 3;
        final variation = 0.65 + 0.25 * math.sin(seed * 1.7);
        lineWidth = contentRect.width * variation;
        contentPaint.strokeWidth = 0.7;
      }

      final startX = contentRect.left;
      final endX = startX + lineWidth;

      canvas.drawLine(
        Offset(startX, y),
        Offset(endX, y),
        contentPaint,
      );
    }

    // Add a simple diagram or image placeholder on some pages
    if (pageIndex % 3 == 1) {
      final diagramRect = Rect.fromLTWH(
        contentRect.left + contentRect.width * 0.2,
        contentRect.bottom - contentRect.height * 0.25,
        contentRect.width * 0.6,
        contentRect.height * 0.15,
      );

      final diagramPaint = Paint()
        ..color = secondaryColor.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawRRect(
        RRect.fromRectAndRadius(diagramRect, const Radius.circular(4)),
        diagramPaint,
      );

      // Simple diagram content
      canvas.drawLine(
        Offset(diagramRect.left + diagramRect.width * 0.2, diagramRect.center.dy),
        Offset(diagramRect.right - diagramRect.width * 0.2, diagramRect.center.dy),
        diagramPaint,
      );
    }
  }

  void _drawBookDetails(Canvas canvas, Size size, Paint paint) {
    // Central binding
    final bindingRect = Rect.fromLTWH(
      size.width * 0.48,
      0,
      size.width * 0.04,
      size.height,
    );

    final bindingGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        color.withOpacity(0.7),
        color.withOpacity(0.9),
        color,
        color.withOpacity(0.9),
        color.withOpacity(0.7),
      ],
    );

    paint.shader = bindingGradient.createShader(bindingRect);
    canvas.drawRect(bindingRect, paint);
    paint.shader = null;

    // Binding stitches
    final stitchPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 0.8;

    for (int i = 1; i < 12; i++) {
      final y = size.height * (i / 12);
      canvas.drawLine(
        Offset(size.width * 0.485, y),
        Offset(size.width * 0.515, y),
        stitchPaint,
      );
    }

    // Book edge highlights
    final edgeHighlight = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1.0;

    // Left edge
    canvas.drawLine(
      Offset(size.width * 0.06, size.height * 0.06),
      Offset(size.width * 0.06, size.height * 0.94),
      edgeHighlight,
    );

    // Right edge
    canvas.drawLine(
      Offset(size.width * 0.94, size.height * 0.06),
      Offset(size.width * 0.94, size.height * 0.94),
      edgeHighlight,
    );
  }

  @override
  bool shouldRepaint(_RealisticPageFlipPainter oldDelegate) =>
      !_listEquals(leftPages, oldDelegate.leftPages) ||
          !_listEquals(rightPages, oldDelegate.rightPages) ||
          flipProgress != oldDelegate.flipProgress ||
          curlProgress != oldDelegate.curlProgress ||
          isFlipping != oldDelegate.isFlipping;

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}