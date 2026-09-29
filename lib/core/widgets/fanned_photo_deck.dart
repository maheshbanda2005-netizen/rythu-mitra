import 'package:flutter/material.dart';
import '../../models/crop_model.dart';
import '../theme/app_colors.dart';

/// A horizontal scrolling crop photo gallery with smooth slide-up on hover/press.
/// No rotation. No fanning. Clean, premium card scroll.
class FannedPhotoDeck extends StatefulWidget {
  final List<CropModel> crops;
  final Function(CropModel crop) onCropSelected;
  final String currentLang;

  const FannedPhotoDeck({
    super.key,
    required this.crops,
    required this.onCropSelected,
    required this.currentLang,
  });

  @override
  State<FannedPhotoDeck> createState() => _FannedPhotoDeckState();
}

class _FannedPhotoDeckState extends State<FannedPhotoDeck> {
  int? _pressedIndex;

  @override
  Widget build(BuildContext context) {
    final displayCrops = widget.crops.take(8).toList();
    final count = displayCrops.length;

    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final crop = displayCrops[index];
          final isPressed = _pressedIndex == index;

          return GestureDetector(
            onTapDown: (_) => setState(() => _pressedIndex = index),
            onTapUp: (_) {
              setState(() => _pressedIndex = null);
              widget.onCropSelected(crop);
            },
            onTapCancel: () => setState(() => _pressedIndex = null),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(0, isPressed ? -8 : 0, 0),
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isPressed
                      ? AppColors.primaryLight
                      : Colors.white.withValues(alpha: 0.25),
                  width: isPressed ? 2.0 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isPressed ? 0.3 : 0.14),
                    blurRadius: isPressed ? 24 : 12,
                    offset: Offset(0, isPressed ? 12 : 6),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Crop Photo
                  Image.network(
                    crop.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Color(int.parse(crop.colorHex)),
                      alignment: Alignment.center,
                      child: Icon(crop.icon, color: Colors.white, size: 48),
                    ),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: Color(int.parse(crop.colorHex)).withValues(alpha: 0.4),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),

                  // Gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Color(0xCC000000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.45, 1.0],
                      ),
                    ),
                  ),

                  // Category chip top-right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        crop.getLocalizedCategory(widget.currentLang),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // Emoji top-left
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        crop.icon,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  // Bottom label
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Text(
                        crop.getLocalizedName(widget.currentLang),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
