import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../services/app_state_service.dart';
import '../../calendar/farm_calendar_screen.dart';

class MyFarmCard extends StatelessWidget {
  const MyFarmCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;
    final dayUnit = lang == 'te' ? 'రో' : (lang == 'hi' ? 'दिन' : 'd');

    final stages = [
      {'title': context.tr('stageSeedling'), 'icon': Icons.spa_rounded, 'days': '0-25 $dayUnit'},
      {'title': context.tr('stageVegetative'), 'icon': Icons.eco_rounded, 'days': '26-55 $dayUnit'},
      {'title': context.tr('stageFlowering'), 'icon': Icons.local_florist_rounded, 'days': '56-90 $dayUnit'},
      {'title': context.tr('stageHarvest'), 'icon': Icons.agriculture_rounded, 'days': '91-150 $dayUnit'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16261D) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF263F2F) : const Color(0xFFE2EBE1),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Title & Edit/Calendar button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.agriculture_rounded, size: 20, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('myFarm'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          lang == 'te'
                              ? 'ప్లాట్ #1 • సర్వే నం: 142/A'
                              : (lang == 'hi'
                                  ? 'प्लॉट #1 • सर्वे नं: 142/A'
                                  : 'Plot #1 • Survey No: 142/A'),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FarmCalendarScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          lang == 'te'
                              ? 'క్యాలెండర్ →'
                              : (lang == 'hi' ? 'कैलेंडर →' : 'Calendar →'),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Info Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E3327) : const Color(0xFFF4F9F4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFarmMetaItem(Icons.eco_rounded, lang == 'te' ? 'పంట' : (lang == 'hi' ? 'फसल' : 'Crop'), appState.activeCrop),
                  ),
                  Container(width: 1, height: 28, color: Colors.grey.withValues(alpha: 0.25)),
                  Expanded(
                    child: _buildFarmMetaItem(Icons.square_foot_rounded, lang == 'te' ? 'విస్తీర్ణం' : (lang == 'hi' ? 'क्षेत्र' : 'Area'), '${appState.farmAreaAcres} ${lang == 'te' ? 'ఎకరాలు' : (lang == 'hi' ? 'एकड़' : 'Acres')}'),
                  ),
                  Container(width: 1, height: 28, color: Colors.grey.withValues(alpha: 0.25)),
                  Expanded(
                    child: _buildFarmMetaItem(
                      Icons.calendar_today_rounded,
                      lang == 'te' ? 'విత్తిన రోజు' : (lang == 'hi' ? 'बुवाई तिथि' : 'Sowing Date'),
                      lang == 'te' ? '10 ఆగస్టు (65 రో)' : (lang == 'hi' ? '10 अगस्त (65 दिन)' : '10 Aug (65d)'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Crop Growth Stage Progression
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.tr('cropStage')}: ',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                Text(
                  stages[appState.activeCropStageIndex]['title'] as String,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Stage Indicator Steps
            Row(
              children: List.generate(stages.length, (idx) {
                final isCompleted = idx < appState.activeCropStageIndex;
                final isCurrent = idx == appState.activeCropStageIndex;

                return Expanded(
                  child: InkWell(
                    onTap: () => appState.updateCropStage(idx),
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            if (idx > 0)
                              Expanded(
                                child: Container(
                                  height: 4,
                                  color: isCompleted || isCurrent
                                      ? AppColors.primaryLight
                                      : Colors.grey.withValues(alpha: 0.25),
                                ),
                              ),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCurrent
                                    ? AppColors.primary
                                    : (isCompleted
                                        ? AppColors.primaryLight
                                        : (isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0))),
                                border: isCurrent
                                    ? Border.all(color: Colors.white, width: 2)
                                    : null,
                                boxShadow: isCurrent
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: isCompleted
                                    ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                                    : Icon(
                                        stages[idx]['icon'] as IconData,
                                        size: 14,
                                        color: isCurrent ? Colors.white : Colors.grey,
                                      ),
                              ),
                            ),
                            if (idx < stages.length - 1)
                              Expanded(
                                child: Container(
                                  height: 4,
                                  color: isCompleted
                                      ? AppColors.primaryLight
                                      : Colors.grey.withValues(alpha: 0.25),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          stages[idx]['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                            color: isCurrent
                                ? (isDark ? Colors.white : AppColors.primary)
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stages[idx]['days'] as String,
                          style: TextStyle(fontSize: 9.5, color: Colors.grey.withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmMetaItem(IconData icon, String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
