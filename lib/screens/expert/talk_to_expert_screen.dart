import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../services/agri_data_service.dart';
import '../../services/app_state_service.dart';

class TalkToExpertScreen extends StatelessWidget {
  const TalkToExpertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final experts = AgriDataService.experts;
    final lang = context.watch<AppStateService>().currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('talkToExpert')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF047857)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.psychology_rounded, size: 36, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang == 'te' ? 'సర్టిఫైడ్ వ్యవసాయ నిపుణులు' : (lang == 'hi' ? 'प्रमाणित कृषि विशेषज्ञ' : 'Certified Agri Scientists'),
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang == 'te'
                              ? 'PJTSAU & ICAR సీనియర్ శాస్త్రవేత్తలతో నేరుగా మాట్లాడి మీ పంటను రక్షించుకోండి.'
                              : (lang == 'hi'
                                  ? 'PJTSAU और ICAR के वैज्ञानिकों से सीधे परामर्श प्राप्त करें।'
                                  : 'Direct crop consulting and pest advice from ICAR & PJTSAU scientists.'),
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              lang == 'te' ? 'అందుబాటులో ఉన్న నిపుణులు' : (lang == 'hi' ? 'उपलब्ध कृषि विशेषज्ञ' : 'Available Experts'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),

            ...experts.map((exp) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF16241C) : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundColor: Color(0xFFE0F2FE),
                          child: Icon(Icons.person_rounded, size: 28, color: AppColors.primary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      exp.name,
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  if (exp.isOnline)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDCFCE7),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text('Online', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(exp.title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              Text(exp.institution, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E3025) : const Color(0xFFF5F9F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, size: 15, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text('${exp.rating}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.work_outline_rounded, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text('${exp.experienceYears}+ Yrs', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.translate_rounded, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(exp.languages.join(", "), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Calling ${exp.name} at ${exp.phone}')),
                              );
                            },
                            icon: const Icon(Icons.call_rounded, size: 16),
                            label: Text(lang == 'te' ? 'కాల్ చేయండి' : (lang == 'hi' ? 'कॉल करें' : 'Call Expert')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              minimumSize: const Size(0, 44),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Opening chat with ${exp.name}')),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                            label: Text(lang == 'te' ? 'సందేశం పంపండి' : (lang == 'hi' ? 'मैसेज भेजें' : 'Send Message')),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 44),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
