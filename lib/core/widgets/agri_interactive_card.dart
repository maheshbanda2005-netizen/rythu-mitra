import 'package:flutter/material.dart';

class AgriInteractiveCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget iconWidget;
  final VoidCallback onTap;
  final Color bgColor;
  final Color bgColorLight;
  final Color textColorHover;
  final Color boxShadowColor;
  final double width;
  final double height;

  const AgriInteractiveCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.iconWidget,
    required this.onTap,
    this.bgColor = const Color(0xFFB8F9D3),
    this.bgColorLight = const Color(0xFFE2FCED),
    this.textColorHover = const Color(0xFF4C5656),
    this.boxShadowColor = const Color(0x7AB8F9D3), // rgba(184, 249, 211, 0.48)
    this.width = 200,
    this.height = 240,
  });

  @override
  State<AgriInteractiveCard> createState() => _AgriInteractiveCardState();
}

class _AgriInteractiveCardState extends State<AgriInteractiveCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final double ty = _isPressed ? 0.0 : (_isHovered ? -6.0 : 0.0);
    final double s = _isPressed ? 0.98 : (_isHovered ? 1.02 : 1.0);
    final transformMatrix = Matrix4.translationValues(0.0, ty, 0.0)
      ..multiply(Matrix4.diagonal3Values(s, s, 1.0));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: widget.width,
          height: widget.height,
          transform: transformMatrix,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF18261E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.11),
                      blurRadius: 28,
                      offset: const Offset(0, 16),
                    ),
                    BoxShadow(
                      color: widget.boxShadowColor,
                      blurRadius: 36,
                      offset: const Offset(0, 20),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Expanding circular overlay like CSS .card:hover .overlay
              Positioned(
                top: 40,
                child: AnimatedScale(
                  scale: _isHovered ? 4.2 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: isDark
                          ? widget.bgColor.withValues(alpha: 0.25)
                          : widget.bgColor.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              // Content: Center circle icon and title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Center animated circle
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isHovered ? widget.bgColor : (isDark ? const Color(0xFF22352A) : Colors.white),
                        border: Border.all(
                          color: _isHovered ? widget.bgColorLight : widget.bgColor,
                          width: 3.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: widget.iconWidget,
                    ),

                    const SizedBox(height: 16),

                    // Label / Title with smooth text transition
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        color: _isHovered
                            ? (isDark ? Colors.white : widget.textColorHover)
                            : (isDark ? Colors.white70 : const Color(0xFF2B3A33)),
                      ),
                      textAlign: TextAlign.center,
                      child: Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
