import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/video_model.dart';
import '../../services/app_state_service.dart';
import '../../core/widgets/audio_read_aloud_bar.dart';
import '../../core/utils/url_helper.dart';

class VideoPlayerModal extends StatefulWidget {
  final AgriVideoModel video;

  const VideoPlayerModal({super.key, required this.video});

  @override
  State<VideoPlayerModal> createState() => _VideoPlayerModalState();
}

class _VideoPlayerModalState extends State<VideoPlayerModal> {
  bool _isPlaying = true;
  double _currentSeconds = 15;
  final double _totalSeconds = 380; // ~6:20
  Timer? _playbackTimer;
  bool _isMuted = false;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _startPlayback();
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _startPlayback() {
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPlaying) {
        setState(() {
          if (_currentSeconds < _totalSeconds) {
            _currentSeconds += _playbackSpeed;
          } else {
            _isPlaying = false;
          }
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  String _formatTime(double seconds) {
    final m = (seconds / 60).floor();
    final s = (seconds % 60).floor();
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111D15) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              // Video Player Box (16:9)
              Container(
                width: double.infinity,
                height: 220,
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Thumbnail Image with Dark Gradient
                    Positioned.fill(
                      child: Image.network(
                        widget.video.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF1E293B),
                          child: const Center(
                            child: Icon(Icons.videocam_rounded, size: 64, color: Colors.white54),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    // Center Play/Pause Indicator
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.85),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),
                    // HD & Category Badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('HD', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.video.getLocalizedCategory(lang),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom Player Controls
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Progress bar slider
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                activeTrackColor: AppColors.primaryLight,
                                inactiveTrackColor: Colors.white24,
                                thumbColor: AppColors.primaryLight,
                              ),
                              child: Slider(
                                value: _currentSeconds.clamp(0.0, _totalSeconds),
                                min: 0.0,
                                max: _totalSeconds,
                                onChanged: (val) {
                                  setState(() {
                                    _currentSeconds = val;
                                  });
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 22),
                                      onPressed: _togglePlayPause,
                                    ),
                                    Text(
                                      '${_formatTime(_currentSeconds)} / ${_formatTime(_totalSeconds)}',
                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // Mute toggle
                                    IconButton(
                                      icon: Icon(_isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded, color: Colors.white, size: 18),
                                      onPressed: () => setState(() => _isMuted = !_isMuted),
                                    ),
                                    // Speed chip
                                    PopupMenuButton<double>(
                                      initialValue: _playbackSpeed,
                                      onSelected: (speed) => setState(() => _playbackSpeed = speed),
                                      color: const Color(0xFF1E293B),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white38),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text('${_playbackSpeed}x', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                      itemBuilder: (_) => [
                                        const PopupMenuItem(value: 0.75, child: Text('0.75x', style: TextStyle(color: Colors.white))),
                                        const PopupMenuItem(value: 1.0, child: Text('1.0x', style: TextStyle(color: Colors.white))),
                                        const PopupMenuItem(value: 1.25, child: Text('1.25x', style: TextStyle(color: Colors.white))),
                                        const PopupMenuItem(value: 1.5, child: Text('1.5x', style: TextStyle(color: Colors.white))),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 20),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Details & Chapters in 100% Pure Single Language
              Expanded(
                child: ListView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      widget.video.getLocalizedTitle(lang),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primaryContainer,
                          child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.video.instructorName, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                              Text(widget.video.instructorTitle, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E3025) : const Color(0xFFF1F5F1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.visibility_rounded, size: 13, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text('${widget.video.viewsCount} ${context.tr('views')}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Direct Watch Original Video on YouTube / Official Channel
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          UrlHelper.openUrl(widget.video.getEffectiveVideoUrl());
                        },
                        icon: const Icon(Icons.open_in_new_rounded, color: Colors.white, size: 18),
                        label: Text(
                          lang == 'te'
                              ? 'అసలైన వీడియో చూడండి (YouTube / Portal)'
                              : (lang == 'hi'
                                  ? 'मूल वीडियो देखें (YouTube / पोर्टल)'
                                  : 'Watch Original Video (YouTube / Portal)'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Audio Read Aloud for low-literacy farmers
                    AudioReadAloudBar(
                      audioTitle: context.tr('listenSummary'),
                      textToSpeak: widget.video.getLocalizedDescription(lang),
                    ),
                    const SizedBox(height: 20),

                    // Key Takeaways (Do's & Don'ts)
                    Text(
                      context.tr('keyTakeaways'),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    ...widget.video.getLocalizedTakeaways(lang).map((point) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                point,
                                style: const TextStyle(fontSize: 13, height: 1.35, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),

                    // Video Chapters
                    Text(
                      context.tr('chapters'),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    ...widget.video.chapters.map((ch) {
                      return Material(
                        color: Colors.transparent,
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ch.timestamp,
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12),
                            ),
                          ),
                          title: Text(
                            ch.getLocalizedTitle(lang),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          trailing: const Icon(Icons.play_circle_outline_rounded, size: 20, color: AppColors.primary),
                          onTap: () {
                            // Jump to timestamp
                            final parts = ch.timestamp.split(':');
                            if (parts.length == 2) {
                              final m = double.tryParse(parts[0]) ?? 0;
                              final s = double.tryParse(parts[1]) ?? 0;
                              setState(() {
                                _currentSeconds = (m * 60) + s;
                                _isPlaying = true;
                              });
                            }
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
