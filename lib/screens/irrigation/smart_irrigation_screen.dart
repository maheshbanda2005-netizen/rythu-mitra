import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../services/app_state_service.dart';

class SmartIrrigationScreen extends StatefulWidget {
  const SmartIrrigationScreen({super.key});

  @override
  State<SmartIrrigationScreen> createState() => _SmartIrrigationScreenState();
}

class _SmartIrrigationScreenState extends State<SmartIrrigationScreen> {
  double _acres = 5.0;
  int _irrigationIndex = 0;
  int _soilIndex = 0;
  int _stageIndex = 2; // Flowering stage default

  // Water multipliers by stage (liters/acre/day)
  static const List<double> _stageMultipliers = [8000, 13000, 18500, 16000];
  // Pump hours multipliers by irrigation type
  static const List<double> _pumpMultipliers = [2.2, 3.0, 4.5];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    context.watch<AppStateService>();

    final waterLiters = _acres * _stageMultipliers[_stageIndex];
    final pumpHours = _acres * _pumpMultipliers[_irrigationIndex];

    // All labels localized via context.tr()
    final irrigationTypes = [
      context.tr('irrDrip'),
      context.tr('irrSprinkler'),
      context.tr('irrFlood'),
    ];
    final soilTypes = [
      context.tr('soilBlack'),
      context.tr('soilRed'),
      context.tr('soilClay'),
    ];
    final cropStages = [
      context.tr('stageSeedling'),
      context.tr('stageVegetative'),
      context.tr('stageFlowering'),
      context.tr('stageBoll'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('smartIrrigation')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Result Card ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('irrTodayNeed'),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          context.tr('irrWeatherOpt'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(waterLiters / 1000).toStringAsFixed(1)}k ${context.tr('irrLitresDay')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${context.tr('irrPumpTime')}: ~${pumpHours.toStringAsFixed(1)} ${context.tr('irrHours')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.water_drop_rounded, size: 18, color: Colors.white70),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.tr('irrRainAdvisory'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Parameters Header ──────────────────────────
            Text(
              context.tr('irrParams'),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),

            // ── Acreage Slider ─────────────────────────────
            _buildSliderCard(context, isDark),
            const SizedBox(height: 14),

            // ── Irrigation Type ────────────────────────────
            _buildSelectorCard(
              context: context,
              isDark: isDark,
              title: context.tr('irrTypeLabel'),
              selectedIndex: _irrigationIndex,
              items: irrigationTypes,
              onChanged: (i) => setState(() => _irrigationIndex = i),
            ),
            const SizedBox(height: 14),

            // ── Soil Type ─────────────────────────────────
            _buildSelectorCard(
              context: context,
              isDark: isDark,
              title: context.tr('irrSoilLabel'),
              selectedIndex: _soilIndex,
              items: soilTypes,
              onChanged: (i) => setState(() => _soilIndex = i),
            ),
            const SizedBox(height: 14),

            // ── Crop Stage ────────────────────────────────
            _buildSelectorCard(
              context: context,
              isDark: isDark,
              title: context.tr('irrStageLabel'),
              selectedIndex: _stageIndex,
              items: cropStages,
              onChanged: (i) => setState(() => _stageIndex = i),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('irrFarmArea'),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              Text(
                '${_acres.toStringAsFixed(1)} ${context.tr('irrAcres')}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: _acres,
            min: 0.5,
            max: 20.0,
            divisions: 39,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _acres = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorCard({
    required BuildContext context,
    required bool isDark,
    required String title,
    required int selectedIndex,
    required List<String> items,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedIndex,
              isExpanded: true,
              items: items
                  .asMap()
                  .entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(
                          e.value,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ],
      ),
    );
  }
}
