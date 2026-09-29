import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../services/app_state_service.dart';

class SatelliteFarmScreen extends StatelessWidget {
  const SatelliteFarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lang = context.watch<AppStateService>().currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('satelliteHealth')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Satellite Imagery Container with Grid Heatmap
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF9333EA), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9333EA).withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Simulated NDVI field zones
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              _buildZoneBox(const Color(0xFF15803D), 'Zone A: 0.82 (Lush)'),
                              _buildZoneBox(const Color(0xFF16A34A), 'Zone B: 0.78 (Good)'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildZoneBox(const Color(0xFFEAB308), 'Zone C: 0.52 (Moderate)'),
                              _buildZoneBox(const Color(0xFFEF4444), 'Zone D: 0.31 (Water Stress)'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Boundary Overlay Lines
                  Center(
                    child: Container(
                      width: 140,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Plot #1 (5 Acres)',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.satellite_alt_rounded, color: Colors.cyan, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Sentinel-2 (2d ago)',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Health Score Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF16241C) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '84%',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang == 'te' ? 'పొలం ఆరోగ్యం: బాగుంది' : (lang == 'hi' ? 'खेत स्वास्थ्य: उत्तम' : 'Farm Health: Vigorous'),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lang == 'te'
                              ? '82% విస్తీర్ణంలో ఆకుల పచ్చదనం మరియు క్లోరోఫిల్ సంతృప్తికరంగా ఉంది.'
                              : (lang == 'hi'
                                  ? '82% क्षेत्र में पत्तियों का हरापन और क्लोरोफिल संतोषजनक है।'
                                  : '82% of crop canopy demonstrates optimal chlorophyll & NDVI vigor.'),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Stress Alert Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2B1C1C) : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 22, color: AppColors.danger),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang == 'te'
                              ? 'ఈశాన్యం జోన్ D లో తేమ లోపం'
                              : (lang == 'hi' ? 'उत्तर-पूर्व जोन D में नमी की कमी' : 'Moisture Deficit in North-East Zone D'),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.danger),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lang == 'te'
                              ? 'జోన్ D లోని 0.5 ఎకరాలలో నేల తేమ తక్కువగా ఉన్నట్లు ఉపగ్రహ చిత్రాలు సూచిస్తున్నాయి. డ్రిప్ లాటరల్స్ పరిశీలించండి.'
                              : (lang == 'hi'
                                  ? 'उपग्रह तस्वीरों के अनुसार जोन D के 0.5 एकड़ में नमी कम है। ड्रिप लाइनों की जांच करें।'
                                  : 'Satellite telemetry indicates moisture stress across 0.5 acres in Zone D. Inspect drip lateral lines.'),
                          style: const TextStyle(fontSize: 11.5, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Color Legend
            Text(
              lang == 'te' ? 'NDVI పచ్చదనం సూచిక సంకేతాలు:' : (lang == 'hi' ? 'NDVI सूचकांक संकेत:' : 'NDVI Vegetation Index Legend:'),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            _buildLegendItem(
              const Color(0xFF15803D),
              lang == 'te' ? 'NDVI > 0.7: దట్టమైన పచ్చదనం' : (lang == 'hi' ? 'NDVI > 0.7: सघन हरियाली (स्वस्थ)' : 'NDVI > 0.7: Healthy Canopy (Dense)'),
            ),
            const SizedBox(height: 6),
            _buildLegendItem(
              const Color(0xFFEAB308),
              lang == 'te' ? 'NDVI 0.4 - 0.6: మధ్యస్థ పెరుగుదల' : (lang == 'hi' ? 'NDVI 0.4 - 0.6: मध्यम विकास' : 'NDVI 0.4 - 0.6: Moderate Growth'),
            ),
            const SizedBox(height: 6),
            _buildLegendItem(
              const Color(0xFFEF4444),
              lang == 'te' ? 'NDVI < 0.4: ఒత్తిడి లేదా ఎండిపోవడం' : (lang == 'hi' ? 'NDVI < 0.4: तनावग्रस्त या सूखा' : 'NDVI < 0.4: Stressed / Sparse Growth'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneBox(Color col, String label) {
    return Expanded(
      child: Container(
        color: col.withValues(alpha: 0.85),
        padding: const EdgeInsets.all(8),
        alignment: Alignment.topLeft,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color col, String text) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: col, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
