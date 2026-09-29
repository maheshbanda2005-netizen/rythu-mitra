import 'dart:math' as math;
import 'package:flutter/material.dart';

class GlowGradientButton extends StatefulWidget {
  final String label;
  final Widget? icon;
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color innerColor;
  final TextStyle? textStyle;

  const GlowGradientButton({
    super.key,
    required this.label,
    this.icon,
    required this.onTap,
    this.width = 200,
    this.height = 52,
    this.innerColor = const Color(0xFF232D26),
    this.textStyle,
  });

  @override
  State<GlowGradientButton> createState() => _GlowGradientButtonState();
}

class _GlowGradientButtonState extends State<GlowGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Rotating conic gradient glow aura (Behind)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _animCtrl,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animCtrl.value * 2 * math.pi,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const SweepGradient(
                              colors: [
                                Color(0xFF2E7D32), // Agri Emerald
                                Color(0xFF10B981), // Mint
                                Color(0xFF06B6D4), // Cyan
                                Color(0xFF3B82F6), // Blue
                                Color(0xFF8B5CF6), // Purple
                                Color(0xFFF59E0B), // Amber
                                Color(0xFF10B981), // Lime
                                Color(0xFF2E7D32), // Emerald
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Glass / Glow blur layer
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.all(2.2),
                    decoration: BoxDecoration(
                      color: widget.innerColor,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: _isHovered ? 0.45 : 0.2),
                          blurRadius: _isHovered ? 18 : 10,
                          spreadRadius: _isHovered ? 2 : 0,
                        ),
                      ],
                    ),
                  ),
                ),

                // Inner label content
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      widget.icon!,
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: widget.textStyle ??
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
