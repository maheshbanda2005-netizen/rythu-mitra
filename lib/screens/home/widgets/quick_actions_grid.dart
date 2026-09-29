import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../crops/crop_list_screen.dart';
import '../../fertilizer/fertilizer_calculator_screen.dart';
import '../../diagnosis/ai_diagnosis_screen.dart';
import '../../market/market_screen.dart';
import '../../schemes/government_schemes_screen.dart';
import '../../calendar/farm_calendar_screen.dart';
import '../../expenses/farm_expenses_screen.dart';
import '../../equipment/equipment_rental_screen.dart';
import '../../marketplace/agri_marketplace_screen.dart';
import '../../community/community_screen.dart';
import '../../expert/talk_to_expert_screen.dart';
import '../../voice/voice_assistant_screen.dart';
import '../../organic/organic_farming_screen.dart';
import '../../irrigation/smart_irrigation_screen.dart';
import '../../satellite/satellite_farm_screen.dart';
import '../../videos/agri_video_hub_screen.dart';
import '../../analytics/crop_yield_predictor_screen.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = _buildActions(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            context.tr('quickActions'),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.42,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            return _GradientActionCard(item: actions[index]);
          },
        ),
      ],
    );
  }

  List<_ActionItem> _buildActions(BuildContext context) => [
        _ActionItem(
          title: context.tr('cropGuide'),
          sub: context.tr('cropGuideSub'),
          icon: Icons.eco_rounded,
          gradientColors: const [Color(0xFF1B5E20), Color(0xFF2E7D32)],
          badgeColor: const Color(0xFF4CAF50),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CropListScreen())),
        ),
        _ActionItem(
          title: 'దిగుబడి అంచనా',
          sub: '1M Kaggle AI Yield',
          icon: Icons.insights_rounded,
          gradientColors: const [Color(0xFF065F46), Color(0xFF059669)],
          badgeColor: const Color(0xFF10B981),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CropYieldPredictorScreen())),
        ),
        _ActionItem(
          title: context.tr('fertilizer'),
          sub: context.tr('fertilizerSub'),
          icon: Icons.science_rounded,
          gradientColors: const [Color(0xFF4A148C), Color(0xFF7C3AED)],
          badgeColor: const Color(0xFF9C27B0),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FertilizerCalculatorScreen())),
        ),
        _ActionItem(
          title: context.tr('diseaseAI'),
          sub: context.tr('diseaseAISub'),
          icon: Icons.pest_control_rounded,
          gradientColors: const [Color(0xFFB71C1C), Color(0xFFDC2626)],
          badgeColor: const Color(0xFFEF5350),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIDiagnosisScreen())),
        ),
        _ActionItem(
          title: context.tr('videoTutorials'),
          sub: context.tr('watchVideo'),
          icon: Icons.ondemand_video_rounded,
          gradientColors: const [Color(0xFF880E4F), Color(0xFFE91E63)],
          badgeColor: const Color(0xFFFF4081),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgriVideoHubScreen())),
        ),
        _ActionItem(
          title: context.tr('marketPrices'),
          sub: context.tr('marketPricesSub'),
          icon: Icons.currency_rupee_rounded,
          gradientColors: const [Color(0xFFE65100), Color(0xFFF59E0B)],
          badgeColor: const Color(0xFFFFB300),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketScreen())),
        ),
        _ActionItem(
          title: context.tr('govtSchemes'),
          sub: context.tr('govtSchemesSub'),
          icon: Icons.account_balance_rounded,
          gradientColors: const [Color(0xFF0D47A1), Color(0xFF1565C0)],
          badgeColor: const Color(0xFF1976D2),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GovernmentSchemesScreen())),
        ),
        _ActionItem(
          title: context.tr('farmCalendar'),
          sub: context.tr('farmCalendarSub'),
          icon: Icons.calendar_month_rounded,
          gradientColors: const [Color(0xFF004D40), Color(0xFF00796B)],
          badgeColor: const Color(0xFF009688),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FarmCalendarScreen())),
        ),
        _ActionItem(
          title: context.tr('expenseTracker'),
          sub: context.tr('expenseTrackerSub'),
          icon: Icons.receipt_long_rounded,
          gradientColors: const [Color(0xFF1B5E20), Color(0xFF059669)],
          badgeColor: const Color(0xFF00C853),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FarmExpensesScreen())),
        ),
        _ActionItem(
          title: context.tr('voiceAssistant'),
          sub: context.tr('voiceAssistantSub'),
          icon: Icons.mic_rounded,
          gradientColors: const [Color(0xFF880E4F), Color(0xFFE11D48)],
          badgeColor: const Color(0xFFFF1744),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VoiceAssistantScreen())),
        ),
        _ActionItem(
          title: context.tr('equipmentRental'),
          sub: context.tr('equipmentRentalSub'),
          icon: Icons.agriculture_rounded,
          gradientColors: const [Color(0xFF3E2723), Color(0xFFB45309)],
          badgeColor: const Color(0xFFFF8F00),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EquipmentRentalScreen())),
        ),
        _ActionItem(
          title: context.tr('krishiBazaar'),
          sub: context.tr('krishiBazaarSub'),
          icon: Icons.shopping_bag_rounded,
          gradientColors: const [Color(0xFF006064), Color(0xFF0891B2)],
          badgeColor: const Color(0xFF00BCD4),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgriMarketplaceScreen())),
        ),
        _ActionItem(
          title: context.tr('community'),
          sub: context.tr('communitySub'),
          icon: Icons.groups_rounded,
          gradientColors: const [Color(0xFF1A237E), Color(0xFF4F46E5)],
          badgeColor: const Color(0xFF3F51B5),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunityScreen())),
        ),
        _ActionItem(
          title: context.tr('talkToExpert'),
          sub: context.tr('talkToExpertSub'),
          icon: Icons.support_agent_rounded,
          gradientColors: const [Color(0xFF004D40), Color(0xFF0D9488)],
          badgeColor: const Color(0xFF1DE9B6),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TalkToExpertScreen())),
        ),
        _ActionItem(
          title: context.tr('organicFarming'),
          sub: context.tr('organicFarmingSub'),
          icon: Icons.spa_rounded,
          gradientColors: const [Color(0xFF1B5E20), Color(0xFF16A34A)],
          badgeColor: const Color(0xFF69F0AE),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrganicFarmingScreen())),
        ),
        _ActionItem(
          title: context.tr('smartIrrigation'),
          sub: context.tr('smartIrrigationSub'),
          icon: Icons.water_drop_rounded,
          gradientColors: const [Color(0xFF01579B), Color(0xFF0284C7)],
          badgeColor: const Color(0xFF40C4FF),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SmartIrrigationScreen())),
        ),
        _ActionItem(
          title: context.tr('satelliteHealth'),
          sub: context.tr('satelliteHealthSub'),
          icon: Icons.satellite_alt_rounded,
          gradientColors: const [Color(0xFF4A148C), Color(0xFF9333EA)],
          badgeColor: const Color(0xFFE040FB),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SatelliteFarmScreen())),
        ),
      ];
}

/// ──────────────────────────────────────────────────────────────────
/// Premium Gradient Card — inspired by the GradientCard React component
/// Features: gradient bg, scale + lift on press, badge icon, arrow CTA
/// ──────────────────────────────────────────────────────────────────
class _GradientActionCard extends StatefulWidget {
  final _ActionItem item;

  const _GradientActionCard({required this.item});

  @override
  State<_GradientActionCard> createState() => _GradientActionCardState();
}

class _GradientActionCardState extends State<_GradientActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _liftAnim;
  late Animation<double> _shadowAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _liftAnim = Tween<double>(begin: 0.0, end: -4.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _shadowAnim = Tween<double>(begin: 8.0, end: 20.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _press() => _ctrl.forward();
  void _release() {
    _ctrl.reverse();
    widget.item.onTap();
  }
  void _cancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, child) => Transform.translate(
        offset: Offset(0, _liftAnim.value),
        child: Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
      ),
      child: GestureDetector(
        onTapDown: (_) => _press(),
        onTapUp: (_) => _release(),
        onTapCancel: _cancel,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      item.gradientColors[0].withValues(alpha: 0.85),
                      item.gradientColors[1].withValues(alpha: 0.7),
                    ]
                  : item.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: item.gradientColors[1].withValues(alpha: 0.38),
                blurRadius: _shadowAnim.value,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // ── Decorative bubble ──────────────────
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: -10,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                // ── Card Content ──────────────────────
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Badge row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: item.badgeColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: item.badgeColor.withValues(alpha: 0.8),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  item.icon,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Text content grouped at bottom
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.sub,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: Colors.white.withValues(alpha: 0.72),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 10,
                              color: Colors.white,
                            ),
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
  ),
);
  }
}

class _ActionItem {
  final String title;
  final String sub;
  final IconData icon;
  final List<Color> gradientColors;
  final Color badgeColor;
  final VoidCallback onTap;

  _ActionItem({
    required this.title,
    required this.sub,
    required this.icon,
    required this.gradientColors,
    required this.badgeColor,
    required this.onTap,
  });
}
