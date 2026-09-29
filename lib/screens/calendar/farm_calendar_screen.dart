import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../services/app_state_service.dart';

class FarmCalendarScreen extends StatefulWidget {
  const FarmCalendarScreen({super.key});

  @override
  State<FarmCalendarScreen> createState() => _FarmCalendarScreenState();
}

class _FarmCalendarScreenState extends State<FarmCalendarScreen> {
  final List<Map<String, dynamic>> _timeline = [
    {
      'day': 'Day 0',
      'titleEn': 'Sowing & Basal Fertilizer Application',
      'titleTe': 'విత్తనం విత్తడం & బేసల్ ఎరువులు',
      'titleHi': 'बुआई एवं बेसल उर्वरक प्रयोग',
      'descEn': 'Complete seed treatment and apply basal fertilizer (DAP + Potash) before sowing.',
      'descTe': 'విత్తన శుద్ధి మరియు భూమిలో బేసల్ ఎరువులు (DAP + Potash) వేసి విత్తడం పూర్తిచేయండి.',
      'descHi': 'बीज उपचार करें और बुआई से पहले बेसल खाद (DAP + पोटाश) डालें।',
      'isDone': true,
      'date': '10 Aug',
      'icon': Icons.spa_rounded,
    },
    {
      'day': 'Day 20',
      'titleEn': 'First Weeding & Gap Filling',
      'titleTe': 'మొదటి కలుపు తీత & గ్యాప్ ఫిల్లింగ్',
      'titleHi': 'पहला निराई-गुड़ाई एवं गैप भरना',
      'descEn': 'Check germination percentage, reseed gaps, and complete first round of weeding.',
      'descTe': 'మొలక శాతం సరిచూసి ఖాళీలలో విత్తనాలు నాటడం మరియు మొదటిసారి కలుపు తీయించడం.',
      'descHi': 'अंकुरण की जांच करें, खाली जगह पर बीज लगाएं और पहली निराई करें।',
      'isDone': true,
      'date': '30 Aug',
      'icon': Icons.eco_rounded,
    },
    {
      'day': 'Day 35',
      'titleEn': '1st Urea Top Dressing & Neem Oil Spray',
      'titleTe': '1వ దఫా యూరియా & వేపనూనె పిచికారీ',
      'titleHi': 'पहला यूरिया टॉप ड्रेसिंग एवं नीम तेल छिड़काव',
      'descEn': 'Apply 30 kg urea per acre during vegetative stage and spray neem oil against sucking pests.',
      'descTe': 'శాఖీయ దశలో ఎకరాకు 30 కిలోల యూరియా వేయడం మరియు రసం పీల్చే పురుగుల కోసం వేపనూనె స్ప్రే.',
      'descHi': 'वानस्पतिक अवस्था में 30 किग्रा यूरिया प्रति एकड़ डालें और नीम तेल का छिड़काव करें।',
      'isDone': true,
      'date': '14 Sep',
      'icon': Icons.science_rounded,
    },
    {
      'day': 'Day 65 (TODAY)',
      'titleEn': 'Flowering Stage - 2nd Fertilizer & Boron Spray',
      'titleTe': 'పూత దశ - 2వ దఫా ఎరువు & బోరాన్ స్ప్రే',
      'titleHi': 'फूल आने की अवस्था - दूसरी खाद एवं बोरॉन छिड़काव',
      'descEn': 'Spray 1g Boron + Planofix per liter of water to prevent flower drop.',
      'descTe': 'పూత రాలకుండా ఉండేందుకు లీటరు నీటికి 1 గ్రాము బోరాన్ + ప్లానోఫిక్స్ పిచికారీ చేయండి.',
      'descHi': 'फूलों को झड़ने से रोकने के लिए 1 ग्राम बोरॉन + प्लानोफिक्स प्रति लीटर पानी में छिड़कें।',
      'isDone': false,
      'isCurrent': true,
      'dateEn': 'Due Tomorrow',
      'dateTe': 'రేపు చేయాలి',
      'dateHi': 'कल नियत है',
      'icon': Icons.local_florist_rounded,
    },
    {
      'day': 'Day 90',
      'titleEn': 'Boll Development - Potassium Nitrate Spray',
      'titleTe': 'కాయ అభివృద్ధి దశ - పొటాషియం నైట్రేట్ పిచికారీ',
      'titleHi': 'कपास फल विकास - पोटेशियम नाइट्रेट छिड़काव',
      'descEn': 'Foliar spray of 13-0-45 @ 10g/L to increase boll weight and quality.',
      'descTe': 'కాయ నాణ్యత మరియు బరువు పెరగడానికి 13-0-45 ఎరువు 10 గ్రాములు లీటరు నీటికి పిచికారీ.',
      'descHi': 'गुणवत्ता और वजन बढ़ाने के लिए 13-0-45 खाद 10 ग्राम प्रति लीटर पानी में छिड़कें।',
      'isDone': false,
      'date': '10 Nov',
      'icon': Icons.circle_rounded,
    },
    {
      'day': 'Day 120-140',
      'titleEn': '1st Cotton Picking & Harvest Storage',
      'titleTe': 'మొదటి కోత & నిల్వ',
      'titleHi': 'पहली तुड़ाई एवं भंडारण',
      'descEn': 'Pick fully opened bolls in the morning hours only after morning dew has dried up.',
      'descTe': 'పూర్తిగా విచ్చుకున్న పత్తి కాయలను ఉదయం వేళల్లో తేమ ఆరిన తర్వాత మాత్రమే తీయండి.',
      'descHi': 'ओस सूखने के बाद सुबह के समय पूरी तरह खिली हुई कपास की तुड़ाई करें।',
      'isDone': false,
      'date': '15 Dec',
      'icon': Icons.agriculture_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'te' ? 'వ్యవసాయ క్యాలెండర్' : (lang == 'hi' ? 'कृषि कैलेंडर' : 'Farm Calendar')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Crop Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 14,
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
                      Expanded(
                        child: Text(
                          '${appState.activeCrop} ${lang == 'te' ? 'కాలపట్టిక' : (lang == 'hi' ? 'समय सारणी' : 'Timeline')}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          lang == 'te' ? '65 రోజులు పూర్తయ్యాయి' : (lang == 'hi' ? '65 दिन पूरे' : '65 Days Elapsed'),
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${lang == 'te' ? 'విత్తిన తేదీ' : (lang == 'hi' ? 'बुआई की तारीख' : 'Sowing Date')}: 10 Aug • ${lang == 'te' ? 'విస్తీర్ణం' : (lang == 'hi' ? 'क्षेत्र' : 'Area')}: ${appState.farmAreaAcres} ${lang == 'te' ? 'ఎకరాలు' : (lang == 'hi' ? 'एकड़' : 'Acres')}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Active Reminder Alert Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFCD34D)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active_rounded, color: Color(0xFF92400E), size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      lang == 'te'
                          ? 'రేపు పూత దశ ఎరువులు మరియు బోరాన్ స్ప్రే చేయవలసి ఉంది.'
                          : (lang == 'hi'
                              ? 'कल फूल आने की अवस्था की खाद और बोरॉन छिड़काव नियत है।'
                              : 'Due Tomorrow: Flowering stage fertilizer & Boron foliar spray.'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              lang == 'te' ? 'సాగు కాలక్రమం' : (lang == 'hi' ? 'फसल कार्य योजना' : 'Cultivation Roadmap'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),

            // Vertical Timeline Steps
            ...List.generate(_timeline.length, (idx) {
              final step = _timeline[idx];
              final isDone = step['isDone'] as bool;
              final isCurrent = step['isCurrent'] == true;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline Node
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _timeline[idx]['isDone'] = !isDone;
                          });
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone
                                ? AppColors.primary
                                : (isCurrent
                                    ? AppColors.accentAmber
                                    : (isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0))),
                            boxShadow: isCurrent
                                ? [
                                    BoxShadow(
                                      color: AppColors.accentAmber.withValues(alpha: 0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: isDone
                                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                                : Icon(
                                    step['icon'] as IconData,
                                    size: 18,
                                    color: isCurrent ? Colors.black87 : (isDark ? Colors.white70 : AppColors.primary),
                                  ),
                          ),
                        ),
                      ),
                      if (idx < _timeline.length - 1)
                        Container(
                          width: 3,
                          height: 60,
                          color: isDone ? AppColors.primary : Colors.grey.withValues(alpha: 0.3),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  // Content Card
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF16241C) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.accentAmber
                              : (isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0)),
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                step['day']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isCurrent ? AppColors.accentAmber : AppColors.primary,
                                ),
                              ),
                              Text(
                                step['date$lang'] ?? (lang == 'te' ? step['dateTe'] : (lang == 'hi' ? step['dateHi'] : step['dateEn'])) ?? step['date'] ?? '',
                                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (lang == 'te' ? step['titleTe'] : (lang == 'hi' ? step['titleHi'] : step['titleEn'])) ?? step['title'] ?? '',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (lang == 'te' ? step['descTe'] : (lang == 'hi' ? step['descHi'] : step['descEn'])) ?? step['desc'] ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
