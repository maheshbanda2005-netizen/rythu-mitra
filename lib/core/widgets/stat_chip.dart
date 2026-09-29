import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatChip extends StatelessWidget {
  final String label;
  final String? iconEmoji;
  final IconData? iconData;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const StatChip({
    super.key,
    required this.label,
    this.iconEmoji,
    this.iconData,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = backgroundColor ??
        (isDark ? const Color(0xFF1E3327) : const Color(0xFFEBF4EC));
    final txt = textColor ??
        (isDark ? AppColors.primaryLight : AppColors.primary);
    final border = borderColor ??
        (isDark ? const Color(0xFF2E4D3B) : const Color(0xFFD4E6D6));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconData != null) ...[
            Icon(iconData, size: 14, color: txt),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: txt,
            ),
          ),
        ],
      ),
    );
  }
}
