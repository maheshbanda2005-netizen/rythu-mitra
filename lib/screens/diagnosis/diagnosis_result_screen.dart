import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/diagnosis_model.dart';
import '../../services/app_state_service.dart';
import '../expert/talk_to_expert_screen.dart';
import '../fertilizer/fertilizer_calculator_screen.dart';

class DiagnosisResultScreen extends StatelessWidget {
  final DiagnosisReport report;

  const DiagnosisResultScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('diseaseAI')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Assessment Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF16241C) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.primaryLight,
                  width: 1.6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          report.cropName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFCD34D)),
                        ),
                        child: Text(
                          lang == 'te'
                              ? '${(report.confidenceScore * 100).toInt()}% ఖచ్చితత్వం'
                              : (lang == 'hi'
                                  ? '${(report.confidenceScore * 100).toInt()}% सटीकता'
                                  : '${(report.confidenceScore * 100).toInt()}% Confidence'),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    report.getLocalizedIssue(lang),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    report.issueNameEn,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Suspected Nutrient Deficiency Alert (if flagged by AI)
            if (report.isNutrientDeficiencySuspected) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF281E38) : const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDDD6FE)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.science_rounded, size: 24, color: Color(0xFF6D28D9)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang == 'te'
                                ? 'పోషక లోపం కూడా గమనించబడింది'
                                : (lang == 'hi' ? 'पोषक तत्व की कमी भी पाई गई' : 'Nutrient Deficiency Also Detected'),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF6D28D9),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            report.suspectedNutrient ?? (lang == 'te' ? 'సూక్ష్మ పోషక లోపం అవకాశం ఉంది' : 'Micronutrient deficiency suspected'),
                            style: const TextStyle(fontSize: 11.5),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FertilizerCalculatorScreen()),
                        );
                      },
                      child: Text(
                        lang == 'te' ? 'పరిష్కారం →' : (lang == 'hi' ? 'समाधान →' : 'Solution →'),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],

            // Symptoms
            _buildSection(
              title: lang == 'te' ? 'గమనించిన లక్షణాలు' : (lang == 'hi' ? 'देखे गए लक्षण' : 'Observed Symptoms'),
              content: report.getLocalizedSymptoms(lang),
              icon: Icons.search_rounded,
              isDark: isDark,
            ),
            const SizedBox(height: 14),

            // Causes
            _buildSection(
              title: lang == 'te' ? 'సమస్యకు కారణాలు' : (lang == 'hi' ? 'संभावित कारण' : 'Possible Causes'),
              content: report.getLocalizedCauses(lang),
              icon: Icons.warning_amber_rounded,
              isDark: isDark,
            ),
            const SizedBox(height: 14),

            // Chemical Management
            _buildSection(
              title: lang == 'te' ? 'సిఫార్సు చేసిన మందులు' : (lang == 'hi' ? 'अनुशंसित रासायनिक उपचार' : 'Recommended Chemical Treatment'),
              content: report.getLocalizedChemical(lang),
              icon: Icons.medication_liquid_rounded,
              isDark: isDark,
              highlightColor: const Color(0xFF0284C7),
            ),
            const SizedBox(height: 14),

            // Organic Management
            _buildSection(
              title: lang == 'te' ? 'ప్రకృతి & సేంద్రియ నివారణ' : (lang == 'hi' ? 'जैविक एवं प्राकृतिक उपचार' : 'Organic & Natural Treatment'),
              content: report.getLocalizedOrganic(lang),
              icon: Icons.eco_rounded,
              isDark: isDark,
              highlightColor: AppColors.primary,
            ),
            const SizedBox(height: 14),

            // Prevention
            _buildSection(
              title: lang == 'te' ? 'ముందస్తు జాగ్రత్తలు' : (lang == 'hi' ? 'रोकथाम के उपाय' : 'Preventive Measures'),
              content: report.getLocalizedPrevention(lang),
              icon: Icons.shield_outlined,
              isDark: isDark,
            ),
            const SizedBox(height: 20),

            // AI Statutory Warning
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF261D1D) : const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFECDD3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 20, color: Color(0xFF9F1239)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      lang == 'te'
                          ? 'ఈ ఫలితాలు కంప్యూటర్ విజన్ AI ఆధారంగా ఇవ్వబడిన ప్రాథమిక సూచనలు మాత్రమే. తెగులు తీవ్రంగా ఉంటే సమీపంలోని వ్యవసాయ అధికారి లేదా శాస్త్రవేత్తను సంప్రదించండి.'
                          : (lang == 'hi'
                              ? 'ये परिणाम कंप्यूटर विजन AI पर आधारित प्राथमिक सुझाव हैं। यदि प्रकोप गंभीर है तो कृषि वैज्ञानिक से संपर्क करें।'
                              : 'These results are AI advisory guidelines based on visual symptoms. Consult an agricultural scientist if infestation persists.'),
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF9F1239),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Talk to Expert Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TalkToExpertScreen()),
                );
              },
              icon: const Icon(Icons.call_rounded),
              label: Text(
                lang == 'te' ? 'వ్యవసాయ శాస్త్రవేత్తతో మాట్లాడండి' : (lang == 'hi' ? 'कृषि वैज्ञानिक से बात करें' : 'Consult Agri Scientist'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required bool isDark,
    Color? highlightColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlightColor != null
              ? highlightColor.withValues(alpha: 0.5)
              : (isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0)),
          width: highlightColor != null ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: highlightColor ?? AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: highlightColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
