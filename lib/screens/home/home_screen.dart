import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/search_header.dart';
import '../../core/widgets/fanned_photo_deck.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/modern_animations.dart';
import '../../services/agri_data_service.dart';
import '../../services/app_state_service.dart';
import 'widgets/weather_card.dart';
import 'widgets/my_farm_card.dart';
import 'widgets/seasonal_crops_card.dart';
import 'widgets/quick_actions_grid.dart';
import '../crops/crop_detail_screen.dart';
import '../notifications/notifications_screen.dart';
import '../language/language_screen.dart';
import '../emergency/emergency_screen.dart';
import '../videos/agri_video_hub_screen.dart';
import '../videos/video_player_modal.dart';
import '../schemes/government_schemes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return context.tr('goodMorning');
    } else if (hour < 17) {
      return context.tr('goodAfternoon');
    }
    return context.tr('goodEvening');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modern Gradient Hero Section with Jade Sky Background
                GradientBackgroundCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top App Bar Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${_getGreeting(context)}, ',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1B5E20),
                                      ),
                                    ),
                                     const Icon(Icons.verified_user_rounded, size: 14, color: Color(0xFF1B5E20)),
                                   ],
                                 ),
                                const SizedBox(height: 2),
                                Text(
                                  appState.farmerName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.4,
                                    color: Color(0xFF0D3E14),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Language switcher chip
                              AnimatedScaleContainer(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LanguageScreen(isFromSettings: true),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF7FBF9A),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.translate_rounded, size: 14, color: Color(0xFF1B5E20)),
                                      const SizedBox(width: 4),
                                      Text(
                                        appState.currentLanguage.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF1B5E20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Notifications Bell with Badge
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  AnimatedScaleContainer(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF7FBF9A),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(Icons.notifications_none_rounded, size: 18, color: Color(0xFF1B5E20)),
                                    ),
                                  ),
                                  if (appState.unreadNotificationsCount > 0)
                                    Positioned(
                                      right: 4,
                                      top: 4,
                                      child: PulseAnimation(
                                        duration: const Duration(milliseconds: 1500),
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                            color: AppColors.danger,
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                                          child: Text(
                                            '${appState.unreadNotificationsCount}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Location Bar with modern styling
                      AnimatedScaleContainer(
                        onTap: () => _showLocationPicker(context, appState),
                        child: GlassmorphismContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          borderRadius: BorderRadius.circular(12),
                          opacity: 0.3,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_rounded, size: 12, color: Color(0xFF1B5E20)),
                              const SizedBox(width: 4),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 160),
                                child: Text(
                                  appState.location,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1B5E20),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Color(0xFF1B5E20)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Smart Search Bar with modern animation
                StaggeredFadeIn(
                  index: 1,
                  child: SearchHeader(
                    placeholder: context.tr('searchPlaceholder'),
                  ),
                ),
                const SizedBox(height: 18),
                // Live Weather Card with staggered animation
                StaggeredFadeIn(
                  index: 2,
                  child: const WeatherCard(),
                ),
                const SizedBox(height: 18),
                // My Farm Dashboard Card with staggered animation
                StaggeredFadeIn(
                  index: 3,
                  child: const MyFarmCard(),
                ),
                const SizedBox(height: 22),

                // Interactive Fanned Photo Deck Gallery with staggered animation
                StaggeredFadeIn(
                  index: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.tr('photoGalleryTitle'),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              context.tr('photoGallerySub'),
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      FannedPhotoDeck(
                        crops: AgriDataService.crops,
                        currentLang: lang,
                        onCropSelected: (crop) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CropDetailScreen(crop: crop)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // Seasonal Crops Recommendations with staggered animation
                StaggeredFadeIn(
                  index: 5,
                  child: const SeasonalCropsCard(),
                ),
                const SizedBox(height: 22),

                // Featured Video Training Tutorial with staggered animation
                StaggeredFadeIn(
                  index: 6,
                  child: _buildFeaturedVideoCard(context, isDark, lang),
                ),
                const SizedBox(height: 22),

                // Quick Actions Grid with staggered animation
                StaggeredFadeIn(
                  index: 7,
                  child: const QuickActionsGrid(),
                ),
                const SizedBox(height: 22),

                // Government Benefits For You with staggered animation
                StaggeredFadeIn(
                  index: 8,
                  child: _buildGovtBenefitsHomeCard(context, isDark, lang),
                ),
                const SizedBox(height: 20),

                // Emergency Helpline Banner with modern animation
                StaggeredFadeIn(
                  index: 9,
                  child: AnimatedScaleContainer(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EmergencyScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF331616) : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFFFCA5A5),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.danger.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text('🆘', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr('emergencyTitle'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.danger,
                                  ),
                                ),
                                Text(
                                  context.tr('emergencySubtitle'),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.danger,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.danger.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              context.tr('tollFree'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLocationPicker(BuildContext context, AppStateService appState) {
    final lang = appState.currentLanguage;
    final locations = lang == 'te'
        ? [
            'వరంగల్, తెలంగాణ',
            'హైదరాబాద్, తెలంగాణ',
            'ఖమ్మం, తెలంగాణ',
            'నిజామాబాద్, తెలంగాణ',
            'కరీంనగర్, తెలంగాణ',
            'గుంటూరు, ఆంధ్రప్రదేశ్',
            'విజయవాడ, ఆంధ్రప్రదేశ్',
          ]
        : (lang == 'hi'
            ? [
                'वारंगल, तेलंगाना',
                'हैदराबाद, तेलंगाना',
                'खम्मम, तेलंगाना',
                'निज़ामाबाद, तेलंगाना',
                'करीमनगर, तेलंगाना',
                'गुंटूर, आंध्र प्रदेश',
                'विजयवाड़ा, आंध्र प्रदेश',
              ]
            : [
                'Warangal, Telangana',
                'Hyderabad, Telangana',
                'Khammam, Telangana',
                'Nizamabad, Telangana',
                'Karimnagar, Telangana',
                'Guntur, Andhra Pradesh',
                'Vijayawada, Andhra Pradesh',
              ]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.7,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    context.tr('selectLocation'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: locations.length,
                      separatorBuilder: (_, index) => const Divider(height: 1),
                      itemBuilder: (context, idx) {
                        final loc = locations[idx];
                        final isSelected = appState.location == loc;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                          title: Text(loc, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                              : null,
                          onTap: () {
                            appState.setLocation(loc);
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedVideoCard(BuildContext context, bool isDark, String lang) {
    final featured = AgriDataService.trainingVideos.first;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.ondemand_video_rounded, size: 20, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      context.tr('videoTutorials'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AgriVideoHubScreen()),
                    );
                  },
                  child: Text(
                    '${context.tr('viewAll')} >',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => VideoPlayerModal(video: featured),
              );
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.network(
                      featured.thumbnailUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 140,
                        color: const Color(0xFF1E3024),
                        alignment: Alignment.center,
                        child: const Icon(Icons.play_circle_fill_rounded, size: 48, color: Colors.white),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: 140,
                          color: isDark ? const Color(0xFF1E3024) : Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                          ),
                        );
                      },
                    ),
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.75),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE11D48).withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 12,
                      right: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              featured.getLocalizedTitle(lang),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              featured.duration,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGovtBenefitsHomeCard(BuildContext context, bool isDark, String lang) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16251C) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF26402F) : const Color(0xFFDCE8DC),
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
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_rounded, size: 20, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    lang == 'te'
                        ? 'మీ పొలానికి ప్రభుత్వ పథకాలు'
                        : (lang == 'hi' ? 'खेत हेतु सरकारी योजनाएं' : 'Govt Benefits For You'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  lang == 'te' ? '3 అర్హత పథకాలు' : (lang == 'hi' ? '3 योजनाएं पात्र' : '3 Matching'),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            lang == 'te'
                ? 'రైతు భరోసా (₹15,000), TSMIP డ్రిప్ (100% సబ్సిడీ), పీఎం-కిసాన్ సహా మీ ప్రాంతానికి వర్తించే పథకాలు.'
                : (lang == 'hi'
                    ? 'रैतु भरोसा (₹15,000), ड्रिप सिंचाई (100% तक) व पीएम-किसान सहित योजनाएं उपलब्ध।'
                    : 'Rythu Bharosa (₹15,000), TSMIP Drip (up to 100%), and PM-Kisan available for your farm.'),
            style: TextStyle(
              fontSize: 12.5,
              height: 1.35,
              color: isDark ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          // Alert pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_active_rounded, size: 14, color: Color(0xFF16A34A)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    lang == 'te'
                        ? 'కొత్త సబ్సిడీ అలర్ట్: సూక్ష్మ సేద్యం (డ్రిప్) దరఖాస్తులు ప్రారంభమయ్యాయి.'
                        : (lang == 'hi'
                            ? 'नवीनतम अलर्ट: ड्रिप सूक्ष्म सिंचाई आवेदन खुले हैं।'
                            : 'New Alert: Drip micro-irrigation applications active.'),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF15803D)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GovernmentSchemesScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                lang == 'te' ? 'అన్ని పథకాలు చూడండి →' : (lang == 'hi' ? 'सभी योजनाएं देखें →' : 'View Schemes →'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
