import 'package:flutter/material.dart';
import 'modern_animations.dart';

/// Modern animated icon button with smooth scale and ripple effects
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final String? tooltip;
  final bool enableAnimation;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size,
    this.tooltip,
    this.enableAnimation = true,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.enableAnimation) {
      _controller = AnimationController(
        duration: ModernAnimations.microInteraction,
        vsync: this,
      );
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: 0.9,
      ).animate(CurvedAnimation(parent: _controller, curve: ModernAnimations.defaultCurve));
    }
  }

  @override
  void dispose() {
    if (widget.enableAnimation) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enableAnimation || widget.onPressed == null) return;
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enableAnimation) return;
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (!widget.enableAnimation) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: widget.enableAnimation ? _scaleAnimation : const AlwaysStoppedAnimation(1.0),
        builder: (context, child) {
          return Transform.scale(
            scale: widget.enableAnimation ? _scaleAnimation.value : 1.0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.color?.withValues(alpha: 0.1) ?? Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.icon,
                color: widget.color,
                size: widget.size ?? 24,
              ),
            ),
          );
        },
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Floating action button with modern animation
class ModernFab extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool enableAnimation;

  const ModernFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.enableAnimation = true,
  });

  @override
  State<ModernFab> createState() => _ModernFabState();
}

class _ModernFabState extends State<ModernFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.enableAnimation) {
      _controller = AnimationController(
        duration: ModernAnimations.microInteraction,
        vsync: this,
      );
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: 0.95,
      ).animate(CurvedAnimation(parent: _controller, curve: ModernAnimations.defaultCurve));
    }
  }

  @override
  void dispose() {
    if (widget.enableAnimation) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enableAnimation) return;
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enableAnimation) return;
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (!widget.enableAnimation) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final fab = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: widget.enableAnimation ? _scaleAnimation : const AlwaysStoppedAnimation(1.0),
        builder: (context, child) {
          return Transform.scale(
            scale: widget.enableAnimation ? _scaleAnimation.value : 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (widget.backgroundColor ?? Theme.of(context).colorScheme.primary)
                        .withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(
                  widget.icon,
                  color: widget.foregroundColor ?? Colors.white,
                  size: 24,
                ),
              ),
            ),
          );
        },
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: fab,
      );
    }

    return fab;
  }
}