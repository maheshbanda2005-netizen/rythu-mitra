import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/audio_read_aloud_bar.dart';
import '../../core/widgets/glow_gradient_button.dart';
import '../../models/crop_model.dart';
import '../../services/agri_data_service.dart';
import '../../services/app_state_service.dart';
import '../fertilizer/fertilizer_calculator_screen.dart';
import '../videos/video_player_modal.dart';
import '../../models/video_model.dart';
import '../../models/crop_portal_model.dart';
import '../../core/utils/url_helper.dart';
import '../../services/kaggle_crop_yield_service.dart';
import '../analytics/crop_yield_predictor_screen.dart';

class CropDetailScreen extends StatelessWidget {
  final CropModel crop;

  const CropDetailScreen({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;

    final sections = [
      {'title': context.tr('secOverview'), 'content': crop.getLocalizedOverview(lang), 'icon': Icons.description_rounded},
      {'title': context.tr('secLandPrep'), 'content': crop.getLocalizedLandPrep(lang), 'icon': Icons.agriculture_rounded},
      {'title': context.tr('secSowing'), 'content': crop.getLocalizedSowing(lang), 'icon': Icons.eco_rounded},
      {'title': context.tr('secFertilizer'), 'content': crop.getLocalizedFertilizer(lang), 'icon': Icons.science_rounded},
      {'title': context.tr('secIrrigation'), 'content': crop.getLocalizedIrrigation(lang), 'icon': Icons.water_drop_rounded},
      {'title': context.tr('secPest'), 'content': crop.getLocalizedPest(lang), 'icon': Icons.pest_control_rounded},
      {'title': context.tr('secHarvest'), 'content': crop.getLocalizedHarvest(lang), 'icon': Icons.inventory_2_rounded},
      {
        'title': context.tr('secEconomics'),
        'content': lang == 'te'
            ? 'సగటు ఎకరా ఖర్చు: ${crop.getLocalizedCost(lang)}\nఆశించే దిగుబడి: ${crop.getLocalizedYield(lang)}\nనికర లాభం: సుమారు ₹40,000 - ₹65,000 / ఎకరానికి.'
            : (lang == 'hi'
                ? 'औसत प्रति एकड़ लागत: ${crop.getLocalizedCost(lang)}\nअनुमानित पैदावार: ${crop.getLocalizedYield(lang)}\nशुद्ध लाभ: लगभग ₹40,000 - ₹65,000 / एकड़।'
                : 'Average Cost / Acre: ${crop.getLocalizedCost(lang)}\nExpected Yield: ${crop.getLocalizedYield(lang)}\nEstimated Net Profit: Approx ₹40,000 - ₹65,000 / Acre.'),
        'icon': Icons.trending_up_rounded,
      },
    ];

    // Get dedicated original video guides and research portals for this crop
    final cropVideos = AgriDataService.getCropVideos(crop.id);
    final portals = CropPortalModel.defaultPortals;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible Real Photo Header
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Real Crop Photo with fallback
                  Image.network(
                    crop.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(int.parse(crop.colorHex)).withValues(alpha: 0.9),
                              AppColors.primary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(crop.icon, color: Colors.white, size: 64),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                  // Gradient dark overlay for high contrast
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.75),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Crop Info Floating Overlay
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(crop.icon, color: AppColors.primary, size: 32),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                crop.getLocalizedName(lang),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.4,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.accentAmber,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  crop.getLocalizedCategory(lang),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Audio Read-Aloud Voice Bar (Specially for low-literacy farmers)
                  AudioReadAloudBar(
                    textToSpeak: crop.audioExplanationTe,
                    audioTitle: '${crop.getLocalizedName(lang)} ${context.tr('listenAudio')}',
                  ),
                  const SizedBox(height: 18),

                  // 2. Dedicated Original Crop Videos Section
                  _buildCropVideosSection(context, cropVideos, isDark, lang),
                  const SizedBox(height: 24),

                  // 3. Search in Different Agricultural Sites Section
                  _buildDifferentSitesSearchSection(context, portals, isDark, lang),
                  const SizedBox(height: 24),

                  // 3. Visual Do's and Don'ts Section (Crucial for uneducated farmers)
                  _buildVisualDosAndDonts(context, isDark, lang),
                  const SizedBox(height: 20),

                  // 4. Quick Agronomic Stats Grid (100% Pure Single Language)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF16241C) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildStatItem(context.tr('seasonLabel'), crop.getLocalizedCategory(lang), Icons.calendar_today_rounded),
                            _buildStatItem(context.tr('durationLabel'), crop.getLocalizedDuration(lang), Icons.timer_outlined),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            _buildStatItem(context.tr('waterLabel'), crop.getLocalizedWater(lang), Icons.water_drop_outlined),
                            _buildStatItem(context.tr('yieldLabel'), crop.getLocalizedYield(lang), Icons.trending_up_rounded),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            _buildStatItem(context.tr('soilLabel'), crop.getLocalizedSoil(lang), Icons.landscape_rounded, fullWidth: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5. Fertilizer Calculator Call to Action with Glowing Rotating Gradient Button
                  Center(
                    child: GlowGradientButton(
                      width: double.infinity,
                      height: 56,
                      label: context.tr('calcFertilizer'),
                      icon: const Icon(Icons.science_rounded, color: Colors.white, size: 22),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FertilizerCalculatorScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 5B. Kaggle 1M Dataset Yield Insights & Predictor Callout Card
                  _buildKaggleYieldBenchmarkCard(context, crop, isDark, lang),
                  const SizedBox(height: 24),

                  // 6. Comprehensive Accordions in pure single language
                  Text(
                    context.tr('cultivationGuideTitle'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  ...sections.map((sec) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: isDark ? const Color(0xFF16241C) : Colors.white,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
                          ),
                        ),
                        child: Theme(
                          data: theme.copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            shape: const Border(),
                            collapsedShape: const Border(),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(sec['icon'] as IconData, color: AppColors.primary, size: 20),
                            ),
                            title: Text(
                              sec['title'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                                child: Text(
                                  sec['content'] as String,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    height: 1.5,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualDosAndDonts(BuildContext context, bool isDark, String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('dosDontsHeading'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        // Do's Card (Green)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF142E1F) : const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF86EFAC), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.tr('dosTitle'),
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...crop.getLocalizedDos(lang).map((doItem) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            doItem,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Don'ts Card (Red)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF331A1A) : const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFCA5A5), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.cancel_rounded, color: Color(0xFFDC2626), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.tr('dontsTitle'),
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...crop.getLocalizedDonts(lang).map((dontItem) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.cancel_rounded, color: Color(0xFFDC2626), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            dontItem,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, {bool fullWidth = false}) {
    return Expanded(
      flex: fullWidth ? 2 : 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropVideosSection(
    BuildContext context,
    List<AgriVideoModel> cropVideos,
    bool isDark,
    String lang,
  ) {
    final heading = lang == 'te'
        ? 'పంట అసలైన వీడియో గైడ్లు'
        : (lang == 'hi' ? 'फसल मूल वीडियो मार्गदर्शिका' : 'Original Crop Video Guides');
    final sub = lang == 'te'
        ? 'శాస్త్రవేత్తల అధికారిక శిక్షణా వీడియోలు & ప్రత్యక్ష డెమోలు'
        : (lang == 'hi'
            ? 'वैज्ञानिकों के आधिकारिक प्रशिक्षण वीडियो एवं खेत प्रदर्शन'
            : 'Official scientific training masterclasses & field demos');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.play_circle_filled_rounded, color: Color(0xFFDC2626), size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${cropVideos.length} ${lang == 'te' ? 'వీడియోలు' : 'Videos'}',
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...cropVideos.map((video) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF16241C) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Preview Thumbnail with overlays
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => VideoPlayerModal(video: video),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            video.thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFF1E293B),
                              child: const Icon(Icons.videocam_rounded, size: 48, color: Colors.white38),
                            ),
                          ),
                        ),
                        // Dark Vignette
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.15),
                                  Colors.black.withValues(alpha: 0.65),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        // Center Play Button
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDC2626).withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFDC2626).withValues(alpha: 0.4),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                            ),
                          ),
                        ),
                        // Category Badge
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              video.getLocalizedCategory(lang),
                              style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        // Duration & Views
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.timer_outlined, size: 12, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  video.duration,
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Video Info & Dual Action Buttons
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.getLocalizedTitle(lang),
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, height: 1.3),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.school_outlined, size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${video.instructorName} • ${video.sourceOrg ?? video.instructorTitle}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Watch in App Modal
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => VideoPlayerModal(video: video),
                                );
                              },
                              icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
                              label: Text(
                                lang == 'te' ? 'యాప్‌లో చూడండి' : (lang == 'hi' ? 'ऐप में देखें' : 'Watch in App'),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isDark ? Colors.white : AppColors.primary,
                                side: BorderSide(
                                  color: isDark ? const Color(0xFF263D30) : const Color(0xFFC7D7C5),
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Open Original on YouTube
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                UrlHelper.openUrl(video.getEffectiveVideoUrl());
                              },
                              icon: const Icon(Icons.open_in_new_rounded, size: 16, color: Colors.white),
                              label: Text(
                                lang == 'te' ? 'యూట్యూబ్‌లో ↗' : (lang == 'hi' ? 'यूट्यूब पर ↗' : 'YouTube ↗'),
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDC2626),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDifferentSitesSearchSection(
    BuildContext context,
    List<CropPortalModel> portals,
    bool isDark,
    String lang,
  ) {
    final title = lang == 'te'
        ? 'వివిధ వెబ్‌సైట్లలో శోధించండి'
        : (lang == 'hi' ? 'विभिन्न कृषि पोर्टलों पर खोजें' : 'Search in Different Sites');
    final subtitle = lang == 'te'
        ? '${crop.getLocalizedName(lang)} గురించిన అధికారిక పరిశోధనలు, మార్కెట్ ధరలు & విశ్వవిద్యాలయ పోర్టల్స్'
        : (lang == 'hi'
            ? '${crop.getLocalizedName(lang)} के बारे में अनुसंधान, मंडी भाव एवं सरकारी पोर्टल'
            : 'Official ICAR research, university guidelines & mandi prices for ${crop.nameEn}');

    final topics = lang == 'te'
        ? [
            {'label': '🌾 సమగ్ర సాగు గైడ్', 'q': '${crop.nameEn} complete cultivation guide ICAR package of practices'},
            {'label': '🐛 పురుగుల నివారణ', 'q': '${crop.nameEn} pest and disease control guide telugu icar'},
            {'label': '🧪 ఎరువుల ప్రణాళిక', 'q': '${crop.nameEn} fertilizer schedule dosage NPK micronutrients pjtsau'},
            {'label': '💰 మార్కెట్ లైవ్ ధరలు', 'q': '${crop.nameEn} mandi price today telangana agmarknet'},
            {'label': '📜 ప్రభుత్వ సబ్సిడీలు', 'q': '${crop.nameEn} subsidy schemes seeds rythu bima telangana'},
            {'label': '🌱 అధిక దిగుబడి విత్తనాలు', 'q': '${crop.nameEn} certified high yield hybrid varieties ICAR'},
          ]
        : (lang == 'hi'
            ? [
                {'label': '🌾 सम्पूर्ण फसल गाइड', 'q': '${crop.nameEn} complete cultivation guide ICAR package'},
                {'label': '🐛 कीट एवं रोग प्रबंधन', 'q': '${crop.nameEn} pest and disease control guide ICAR'},
                {'label': '🧪 उर्वरक मात्रा एवं समय', 'q': '${crop.nameEn} fertilizer schedule dosage NPK'},
                {'label': '💰 आज का मंडी भाव', 'q': '${crop.nameEn} mandi price today agmarknet'},
                {'label': '📜 सरकारी अनुदान', 'q': '${crop.nameEn} government subsidy schemes kisan portal'},
                {'label': '🌱 उन्नत बीज किस्में', 'q': '${crop.nameEn} certified high yield varieties ICAR'},
              ]
            : [
                {'label': '🌾 Cultivation Guide', 'q': '${crop.nameEn} complete cultivation package ICAR practices'},
                {'label': '🐛 Pest Control', 'q': '${crop.nameEn} pest disease management ICAR'},
                {'label': '🧪 Fertilizer Schedule', 'q': '${crop.nameEn} fertilizer dosage NPK schedule'},
                {'label': '💰 Mandi Prices', 'q': '${crop.nameEn} market yard prices today agmarknet'},
                {'label': '📜 Govt Subsidies', 'q': '${crop.nameEn} government agriculture schemes subsidy'},
                {'label': '🌱 Seed Varieties', 'q': '${crop.nameEn} high yield certified seed varieties'},
              ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.travel_explore_rounded, color: Color(0xFF0284C7), size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Quick Topic Search Chips
        Text(
          lang == 'te' ? 'శీఘ్ర శోధన అంశాలు (Quick Topics):' : 'Quick Search Topics:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: topics.map((t) {
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                final url = 'https://www.google.com/search?q=${Uri.encodeComponent(t['q']!)}';
                UrlHelper.openUrl(url);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E3025) : const Color(0xFFF1F7F1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2E4B39) : const Color(0xFFCDE2CF),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t['label']!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 13,
                      color: isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Official Agricultural Portals List
        Text(
          lang == 'te' ? 'అధికారిక వ్యవసాయ సైట్లు & పోర్టల్స్:' : 'Official Agriculture Portals:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 10),

        ...portals.map((portal) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF16241C) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Portal Icon Circle
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: portal.themeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(portal.icon, color: portal.themeColor, size: 24),
                ),
                const SizedBox(width: 14),
                // Portal Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              portal.getLocalizedName(lang),
                              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: portal.themeColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              portal.getLocalizedBadge(lang),
                              style: TextStyle(
                                color: portal.themeColor,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        portal.getLocalizedDescription(lang),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.3,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Open Site Button
                IconButton(
                  onPressed: () {
                    final targetUrl = portal.buildUrl(crop, lang);
                    UrlHelper.openUrl(targetUrl);
                  },
                  tooltip: 'Open in ${portal.nameEn}',
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: portal.themeColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildKaggleYieldBenchmarkCard(
    BuildContext context,
    CropModel crop,
    bool isDark,
    String lang,
  ) {
    final benchmark = KaggleCropYieldService.getBenchmarkForCrop(crop.nameEn);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF14291B) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.insights_rounded, color: Color(0xFF10B981), size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang == 'te' ? 'Kaggle 10 లక్షల రికార్డుల దిగుబడి విశ్లేషణ' : 'Kaggle 1M Records Yield Insights',
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'samuelotiattakorah/agriculture-crop-yield',
                      style: TextStyle(fontSize: 10.5, color: isDark ? Colors.white60 : Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B3825) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 'te' ? 'సగటు జాతీయ దిగుబడి' : 'Avg National Yield',
                        style: TextStyle(fontSize: 10.5, color: isDark ? Colors.white60 : Colors.black54),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${benchmark?.avgYieldQuintalsPerAcre ?? 18.8} Qtl/Acre',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF10B981)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B3825) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 'te' ? 'ఎరువుల ప్రభావం' : 'Fertilizer Boost',
                        style: TextStyle(fontSize: 10.5, color: isDark ? Colors.white60 : Colors.black54),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '+38.5% (+6.1 Qtl)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF16A34A)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CropYieldPredictorScreen(initialCropName: crop.nameEn),
                  ),
                );
              },
              icon: const Icon(Icons.calculate_rounded, color: Colors.white, size: 18),
              label: Text(
                lang == 'te' ? 'నా పొలం దిగుబడిని అంచనా వేయండి (AI Predictor) ↗' : 'Calculate My Farm Yield (AI Predictor) ↗',
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
