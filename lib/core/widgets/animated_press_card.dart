import 'package:flutter/material.dart';

/// Premium animated press card with spring-physics lift effect.
/// On press: scales down slightly and lifts (translateY).
/// On release: springs back with overshoot for tactile premium feel.
class AnimatedPressCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? color;
  final Gradient? gradient;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;
  final bool enableGlow;
  final Color? glowColor;

  const AnimatedPressCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.color,
    this.gradient,
    this.border,
    this.padding,
    this.margin,
    this.elevation = 0,
    this.enableGlow = false,
    this.glowColor,
  });

  @override
  State<AnimatedPressCard> createState() => _AnimatedPressCardState();
}

class _AnimatedPressCardState extends State<AnimatedPressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _liftAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _liftAnim = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onTap != null) _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onTap != null) {
      _controller.reverse();
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final rRadius = widget.borderRadius ?? BorderRadius.circular(20);

    final cardColor = widget.color ??
        (isDark ? const Color(0xFF16241C) : Colors.white);

    final border = widget.border ??
        Border.all(
          color: isDark ? const Color(0xFF263D30) : const Color(0xFFE4EBE2),
          width: 1.2,
        );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -_liftAnim.value),
        child: Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
      ),
      child: Container(
        margin: widget.margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: widget.gradient != null ? null : cardColor,
          gradient: widget.gradient,
          borderRadius: rRadius,
          border: border,
          boxShadow: [
            BoxShadow(
              color: widget.enableGlow && widget.glowColor != null
                  ? widget.glowColor!.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: widget.enableGlow ? 16 : 12,
              offset: const Offset(0, 4),
              spreadRadius: widget.enableGlow ? 1 : 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: rRadius,
          child: InkWell(
            borderRadius: rRadius,
            splashColor: Colors.white.withValues(alpha: 0.08),
            highlightColor: Colors.white.withValues(alpha: 0.04),
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(16),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
