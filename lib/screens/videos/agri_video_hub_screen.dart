import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/video_model.dart';
import '../../services/agri_data_service.dart';
import '../../services/app_state_service.dart';
import 'video_player_modal.dart';

class AgriVideoHubScreen extends StatefulWidget {
  const AgriVideoHubScreen({super.key});

  @override
  State<AgriVideoHubScreen> createState() => _AgriVideoHubScreenState();
}

class _AgriVideoHubScreenState extends State<AgriVideoHubScreen> {
  String _selectedCategory = 'All';

  final List<String> _categoryKeys = [
    'allFilter',
    'kharifFilter',
    'fertilizer',
    'diseaseAI',
    'organicFarming',
    'equipmentRental',
  ];

  final Map<String, String> _keyToCategory = {
    'allFilter': 'All',
    'kharifFilter': 'Cultivation',
    'fertilizer': 'Fertilizer',
    'diseaseAI': 'Pest Control',
    'organicFarming': 'Organic',
    'equipmentRental': 'Machinery',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;
    final videos = AgriDataService.trainingVideos;

    final targetCategory = _keyToCategory[_selectedCategory] ?? 'All';

    final filtered = targetCategory == 'All'
        ? videos
        : videos.where((v) => v.category == targetCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('videoTutorials')),
      ),
      body: Column(
        children: [
          // Filter Chips (100% Pure Single Language)
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              itemCount: _categoryKeys.length,
              separatorBuilder: (_, index) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final catKey = _categoryKeys[idx];
                final isSelected = _selectedCategory == catKey;
                final label = context.tr(catKey);

                return ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: isDark ? const Color(0xFF1E3024) : Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => _selectedCategory = catKey),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Videos List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (_, index) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final video = filtered[idx];
                return _buildVideoCard(context, video, isDark, lang);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, AgriVideoModel video, bool isDark, String lang) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => VideoPlayerModal(video: video),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 16:9 Thumbnail with Duration and Play Button
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
                child: SizedBox(
                  height: 170,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          video.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFF1B3824),
                            child: const Center(
                              child: Icon(Icons.play_circle_fill_rounded, size: 54, color: Colors.white70),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.85),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            video.duration,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            video.getLocalizedCategory(lang),
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title & Instructor info in pure single language
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.getLocalizedTitle(lang),
                      style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              video.instructorName,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.visibility_outlined, size: 13, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${video.viewsCount} ${context.tr('views')}',
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
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
