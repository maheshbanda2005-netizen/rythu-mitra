import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../services/app_state_service.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lang = context.watch<AppStateService>().currentLanguage;

    final List<Map<String, dynamic>> helplines = [
      {
        'titleEn': 'Kisan Call Centre (Govt of India)',
        'titleTe': 'కిసాన్ కాల్ సెంటర్',
        'titleHi': 'किसान कॉल सेंटर (भारत सरकार)',
        'number': '1551',
        'descEn': 'Ministry of Agriculture toll-free helpline. Get expert advice in 22 regional languages (6 AM to 10 PM).',
        'descTe': 'కేంద్ర వ్యవసాయ మంత్రిత్వ శాఖ టోల్-ఫ్రీ ఉచిత సేవ. 22 భాషల్లో శాస్త్రవేత్తల సలహా (ఉదయం 6 నుండి రాత్రి 10 వరకు).',
        'descHi': 'कृषि मंत्रालय की टोल-फ्री हेल्पलाइन। 22 भाषाओं में वैज्ञानिकों से निःशुल्क सलाह प्राप्त करें।',
        'badge': 'Toll-Free',
        'icon': Icons.phone_in_talk_rounded,
      },
      {
        'titleEn': 'Rythu Bharosa State Helpline',
        'titleTe': 'రైతు భరోసా సహాయ కేంద్రం',
        'titleHi': 'रायथू भरोसा राज्य हेल्पलाइन',
        'number': '1800-425-3520',
        'descEn': 'Direct support for farmer investment assistance and input subsidies.',
        'descTe': 'రైతు భరోసా మరియు పెట్టుబడి సహాయం సమస్యల పరిష్కార అధికారిక కేంద్రం.',
        'descHi': 'किसान निवेश सहायता और इनपुट सब्सिडी के लिए आधिकारिक सहायता केंद्र।',
        'badge': 'State Govt',
        'icon': Icons.account_balance_rounded,
      },
      {
        'titleEn': 'Agricultural Disaster Relief Emergency',
        'titleTe': 'ప్రకృతి వైపరీత్యాల అత్యవసర విభాగం',
        'titleHi': 'प्राकृतिक आपदा राहत आपातकालीन सेवा',
        'number': '1070',
        'descEn': 'Immediate emergency relief for unseasonal rainfall, floods, and crop damage.',
        'descTe': 'భారీ వర్షాలు, తుఫానులు, వరదల సమయంలో రైతుల అత్యవసర సహాయ కేంద్రం.',
        'descHi': 'भारी बारिश, ओलावृष्टि और बाढ़ के समय किसानों के लिए आपातकालीन राहत।',
        'badge': 'Emergency',
        'icon': Icons.thunderstorm_rounded,
      },
      {
        'titleEn': 'Crop Scientist Advisory (PJTSAU)',
        'titleTe': 'పంటల శాస్త్రవేత్తల పరిశోధనా కేంద్రం',
        'titleHi': 'फसल वैज्ञानिक परामर्श केंद्र (PJTSAU)',
        'number': '040-2401-5011',
        'descEn': 'University main research center for cotton, paddy, and chilli agronomy advice.',
        'descTe': 'ఆచార్య జయశంకర్ తెలంగాణ వ్యవసాయ విశ్వవిద్యాలయ ప్రధాన పరిశోధనా కేంద్రం.',
        'descHi': 'कपास, धान और मिर्च की फसलों के लिए विश्वविद्यालय अनुसंधान केंद्र।',
        'badge': 'Agronomists',
        'icon': Icons.psychology_rounded,
      },
      {
        'titleEn': 'District Agriculture Office (DAO)',
        'titleTe': 'జిల్లా వ్యవసాయ అధికారి కార్యాలయం',
        'titleHi': 'जिला कृषि अधिकारी कार्यालय',
        'number': '+91 870 245 6789',
        'descEn': 'Local mandal extension officers, certified seeds & fertilizer quality wing.',
        'descTe': 'స్థానిక మండల వ్యవసాయ విస్తరణ అధికారి మరియు ఎరువుల నియంత్రణ విభాగం.',
        'descHi': 'स्थानीय मंडल विस्तार अधिकारी और गुणवत्ता खाद/बीज नियंत्रण विभाग।',
        'badge': 'District Office',
        'icon': Icons.business_rounded,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('emergencyTitle')),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: helplines.length,
        separatorBuilder: (_, index) => const SizedBox(height: 14),
        itemBuilder: (context, idx) {
          final h = helplines[idx];
          final title = lang == 'te' ? h['titleTe'] as String : (lang == 'hi' ? h['titleHi'] as String : h['titleEn'] as String);
          final desc = lang == 'te' ? h['descTe'] as String : (lang == 'hi' ? h['descHi'] as String : h['descEn'] as String);

          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF16241C) : Colors.white,
              borderRadius: BorderRadius.circular(22),
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(h['icon'] as IconData, size: 20, color: AppColors.primary),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFECDD3)),
                      ),
                      child: Text(
                        h['badge'] as String,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.danger),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(fontSize: 12.5, color: Colors.grey[600], height: 1.35),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      h['number']!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Dialing ${h['number']}...')),
                        );
                      },
                      icon: const Icon(Icons.phone_in_talk_rounded, size: 16),
                      label: Text(lang == 'te' ? 'కాల్ చేయండి' : (lang == 'hi' ? 'कॉल करें' : 'Call Now')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
