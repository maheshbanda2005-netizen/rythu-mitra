import 'dart:math' as math;
import 'package:flutter/material.dart';

/// GradientBackground — "Jade Sky", converted from React to Flutter
/// Original source: https://21st.dev/community/gradients/editor?from=85ea2692-591f-4b2b-928f-de88da3d1a88
/// 
/// A beautiful animated gradient background that fills its parent with soft,
/// flowing colors inspired by jade skies. Features smooth animations and
/// modern visual effects.
class GradientBackground extends StatefulWidget {
  final Widget? child;
  final double blurAmount;
  final Duration animationDuration;
  final bool enableAnimation;

  const GradientBackground({
    super.key,
    this.child,
    this.blurAmount = 0.4,
    this.animationDuration = const Duration(seconds: 8),
    this.enableAnimation = true,
  });

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (widget.enableAnimation) {
      _controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      )..repeat(reverse: true);
      
      _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    if (widget.enableAnimation) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.enableAnimation ? _animation : const AlwaysStoppedAnimation(0),
      builder: (context, child) {
        return CustomPaint(
          painter: _JadeSkyPainter(
            animationValue: widget.enableAnimation ? _animation.value : 0,
            blurAmount: widget.blurAmount,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _JadeSkyPainter extends CustomPainter {
  final double animationValue;
  final double blurAmount;

  _JadeSkyPainter({
    required this.animationValue,
    required this.blurAmount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxRadius = math.max(size.width, size.height) * 0.8;

    // Background color
    final bgPaint = Paint()..color = const Color(0xFFCFE9F0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Animated gradient circles
    final circles = [
      // Circle 1: Light green-yellow (top-right area)
      _GradientCircle(
        center: Offset(
          size.width * (0.65 + math.sin(animationValue * math.pi * 2) * 0.05),
          size.height * (0.45 + math.cos(animationValue * math.pi * 2) * 0.05),
        ),
        radius: maxRadius * 0.4,
        colors: [const Color(0xFFEEF6E3), const Color(0x00EEF6E3)],
        stops: [0.0, 0.6],
      ),
      // Circle 2: Green (bottom-left area)
      _GradientCircle(
        center: Offset(
          size.width * (0.28 + math.cos(animationValue * math.pi * 2 + 1) * 0.04),
          size.height * (0.74 + math.sin(animationValue * math.pi * 2 + 1) * 0.04),
        ),
        radius: maxRadius * 0.5,
        colors: [const Color(0xFFB7D98E), const Color(0x00B7D98E)],
        stops: [0.0, 0.7],
      ),
      // Circle 3: Teal green (top-center area)
      _GradientCircle(
        center: Offset(
          size.width * (0.52 + math.sin(animationValue * math.pi * 2 + 2) * 0.03),
          size.height * (0.20 + math.cos(animationValue * math.pi * 2 + 2) * 0.03),
        ),
        radius: maxRadius * 0.6,
        colors: [const Color(0xFF7FBF9A), const Color(0x007FBF9A)],
        stops: [0.0, 0.8],
      ),
      // Circle 4: Light blue (bottom-right area)
      _GradientCircle(
        center: Offset(
          size.width * (0.80 + math.cos(animationValue * math.pi * 2 + 3) * 0.04),
          size.height * (0.84 + math.sin(animationValue * math.pi * 2 + 3) * 0.04),
        ),
        radius: maxRadius * 0.7,
        colors: [const Color(0xFFCFE9F0), const Color(0x00CFE9F0)],
        stops: [0.0, 0.9],
      ),
    ];

    // Apply blur effect by drawing with image filter
    final blurSigma = blurAmount * 10;
    for (final circle in circles) {
      final gradient = RadialGradient(
        colors: circle.colors,
        stops: circle.stops,
        center: Alignment(
          (circle.center.dx - size.width / 2) / (size.width / 2),
          (circle.center.dy - size.height / 2) / (size.height / 2),
        ),
        radius: 1.0,
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: circle.center, radius: circle.radius),
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);

      canvas.drawCircle(circle.center, circle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_JadeSkyPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.blurAmount != blurAmount;
  }
}

class _GradientCircle {
  final Offset center;
  final double radius;
  final List<Color> colors;
  final List<double> stops;

  _GradientCircle({
    required this.center,
    required this.radius,
    required this.colors,
    required this.stops,
  });
}

/// A pre-configured card wrapper using the GradientBackground
class GradientBackgroundCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const GradientBackgroundCard({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(20),
        ),
        child: GradientBackground(
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}