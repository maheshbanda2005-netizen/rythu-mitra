import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../localization/app_localizations.dart';

class AudioReadAloudBar extends StatefulWidget {
  final String textToSpeak;
  final String? audioTitle;
  final VoidCallback? onPlay;

  const AudioReadAloudBar({
    super.key,
    required this.textToSpeak,
    this.audioTitle,
    this.onPlay,
  });

  @override
  State<AudioReadAloudBar> createState() => _AudioReadAloudBarState();
}

class _AudioReadAloudBarState extends State<AudioReadAloudBar>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          backgroundColor: AppColors.primary,
          content: Row(
            children: [
              const Icon(Icons.volume_up_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${context.tr('speakingVoice')}: "${widget.textToSpeak.length > 55 ? "${widget.textToSpeak.substring(0, 55)}..." : widget.textToSpeak}"',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isPlaying
            ? (isDark ? const Color(0xFF1E382B) : const Color(0xFFE8F5E9))
            : (isDark ? const Color(0xFF16241C) : Colors.white),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isPlaying
              ? AppColors.primaryLight
              : (isDark ? const Color(0xFF263D30) : const Color(0xFFD8E4D6)),
          width: _isPlaying ? 1.8 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: _isPlaying
                ? AppColors.primary.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: _togglePlay,
        borderRadius: BorderRadius.circular(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isPlaying ? AppColors.primary : AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.volume_up_rounded,
                color: _isPlaying ? Colors.white : AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isPlaying
                              ? context.tr('speakingVoice')
                              : (widget.audioTitle ?? context.tr('listenVoice')),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: _isPlaying ? AppColors.primary : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accentAmber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          context.tr('voiceAiBadge'),
                          style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFFB45309)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.tr('voiceAiDesc'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (_isPlaying) ...[
              Row(
                children: List.generate(4, (i) {
                  return AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      final val = (_animController.value + (i * 0.25)) % 1.0;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 3.5,
                        height: 10 + (val * 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(width: 8),
            ] else ...[
              const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 24),
            ],
          ],
        ),
      ),
    );
  }
}
