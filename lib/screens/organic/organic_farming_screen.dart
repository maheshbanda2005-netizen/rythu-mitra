import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../services/app_state_service.dart';

class OrganicFarmingScreen extends StatelessWidget {
  const OrganicFarmingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lang = context.watch<AppStateService>().currentLanguage;

    final methods = [
      {
        'titleEn': 'Jeevamrutham Preparation',
        'titleTe': 'జీవామృతం తయారీ విధానం',
        'titleHi': 'जीवामृत निर्माण विधि',
        'categoryEn': 'Soil Micro-Organisms / Bio-Fertilizer',
        'categoryTe': 'భూసార పెంపు / జీవ ఎరువు',
        'categoryHi': 'मृदा उर्वरता संवर्धन / बायो-फर्टिलाइजर',
        'icon': Icons.spa_rounded,
        'ingredientsEn': '10 kg indigenous cow dung, 10 liters cow urine, 2 kg jaggery, 2 kg pulse flour, handful of live fertile soil, 200 liters water.',
        'ingredientsTe': 'దేశీ ఆవు పేడ 10 కేజీలు, ఆవు మూత్రం 10 లీటర్లు, బెల్లం 2 కేజీలు, పప్పు పిండి 2 కేజీలు, పుట్ట మన్ను దోసెడు, 200 లీటర్ల నీరు.',
        'ingredientsHi': '10 किग्रा देसी गाय का गोबर, 10 लीटर गोमूत्र, 2 किग्रा गुड़, 2 किग्रा बेसन, मुट्ठी भर उपजाऊ मिट्टी, 200 लीटर पानी।',
        'prepEn': 'Mix all ingredients in a 200L drum. Stir clockwise with a wooden stick twice daily for 48 hours. Keep in shade.',
        'prepTe': 'ఒక డ్రమ్ములో అన్నింటినీ కలిపి రోజూ ఉదయం, సాయంత్రం సవ్యదిశలో కర్రతో కలపాలి. 48 గంటల్లో సూక్ష్మజీవులతో కూడిన జీవామృతం తయారవుతుంది.',
        'prepHi': 'ड्रम में सभी सामग्री मिलाएं। दिन में दो बार लकड़ी के डंडे से क्लॉकवाइज घुमाएं। 48 घंटे में जीवामृत तैयार हो जाता है।',
        'usageEn': 'Apply 200 liters per acre through flood or drip irrigation, or 10% concentration as foliar spray.',
        'usageTe': 'ఎకరాకు 200 లీటర్లు నీటిపారుదల ద్వారా లేదా 10% మోతాదులో పిచికారీ చేయవచ్చు.',
        'usageHi': 'प्रति एकड़ 200 लीटर सिंचाई के साथ या 10% घोल बनाकर पर्णीय छिड़काव करें।',
      },
      {
        'titleEn': 'Neemastra (Organic Sucking Pest Control)',
        'titleTe': 'నీమాస్త్రం (సహజ రసం పీల్చే పురుగుల నివారణ)',
        'titleHi': 'नीमास्त्र (रस चूसक कीट निवारण)',
        'categoryEn': 'Aphids, Whiteflies & Jassids Control',
        'categoryTe': 'రసం పీల్చే పురుగుల నివారణ',
        'categoryHi': 'एफिड्स, सफेद मक्खी कीट नियंत्रण',
        'icon': Icons.eco_rounded,
        'ingredientsEn': '5 kg fresh neem leaves or powder, 5 liters cow urine, 2 kg cow dung, 100 liters water.',
        'ingredientsTe': 'వేప ఆకులు లేదా గింజల పొడి 5 కేజీలు, ఆవు మూత్రం 5 లీటర్లు, ఆవు పేడ 2 కేజీలు, 100 లీటర్ల నీరు.',
        'ingredientsHi': '5 किग्रा नीम की पत्तियां या चूर्ण, 5 लीटर गोमूत्र, 2 किग्रा गोबर, 100 लीटर पानी।',
        'prepEn': 'Ferment in a drum for 48 hours. Filter using a fine cloth and spray directly without dilution.',
        'prepTe': 'డ్రమ్ములో వేసి 48 గంటలు పులియబెట్టి, గుడ్డతో వడపోసి నేరుగా పిచికారీ చేయాలి.',
        'prepHi': '48 घंटे तक किण्वन होने दें। कपड़े से छानकर सीधे फसल पर छिड़काव करें।',
        'usageEn': 'Highly effective against early stage aphids, jassids, and whitefly nymphs.',
        'usageTe': 'లేత దశలో ఆశించే పచ్చదోమ, పేనుబంక, తెల్లదోమల నివారణకు అద్భుతంగా పనిచేస్తుంది.',
        'usageHi': 'प्रारंभिक अवस्था में एफिड्स और सफेद मक्खी के रोकथाम के लिए सर्वोत्तम।',
      },
      {
        'titleEn': 'Beejamrutham (Seed Inoculation Treatment)',
        'titleTe': 'బీజామృతం (విత్తన శుద్ధి విధానం)',
        'titleHi': 'बीजामृत (बीज शोधन विधि)',
        'categoryEn': 'Seed-Borne Disease Immunity',
        'categoryTe': 'విత్తన శుద్ధి & రోగనిరోధకత',
        'categoryHi': 'बीज जनित रोग निवारण',
        'icon': Icons.grass_rounded,
        'ingredientsEn': '5 kg cow dung, 5 liters cow urine, 50 grams lime, handful of anthill soil, 20 liters water.',
        'ingredientsTe': 'దేశీ ఆవు పేడ 5 కేజీలు, ఆవు మూత్రం 5 లీటర్లు, సున్నం 50 గ్రాములు, పుట్ట మన్ను.',
        'ingredientsHi': '5 किग्रा देसी गाय का गोबर, 5 लीटर गोमूत्र, 50 ग्राम चूना, मुट्ठी भर खेत की मिट्टी।',
        'prepEn': 'Mix overnight. Coat seeds with this paste gently and dry in shade before sowing.',
        'prepTe': 'విత్తనాలను విత్తే ముందు ఈ ద్రావణంలో ముంచి నీడలో ఆరబెట్టి విత్తుకోవాలి.',
        'prepHi': 'घोल में बीजों को हल्के हाथ से लेपकर छाया में सुखाकर बुआई करें।',
        'usageEn': 'Protects emerging seedlings from soil-borne fungi and wilt infections.',
        'usageTe': 'నేలద్వారా మరియు విత్తనం ద్వారా వచ్చే శిలీంధ్ర వ్యాధులను అరికడుతుంది.',
        'usageHi': 'मृदा जनित फफूंद और उकठा रोग से पौधों की रक्षा करता है।',
      },
      {
        'titleEn': 'Brahmastra (Broad Spectrum Caterpillar Control)',
        'titleTe': 'బ్రహ్మాస్త్రం (లద్దె మరియు కాయ తొలిచే పురుగుల నివారణ)',
        'titleHi': 'ब्रह्मास्त्र (सख्त कीट एवं सुंडी नियंत्रण)',
        'categoryEn': 'Bollworm & Stem Borer Control',
        'categoryTe': 'శనగపచ్చ, లద్దె పురుగుల నివారణ',
        'categoryHi': 'इल्ली एवं तना छेदक नियंत्रण',
        'icon': Icons.local_fire_department_rounded,
        'ingredientsEn': 'Neem, custard apple, pongamia, calotropis, and castor leaves (2 kg each), 10 liters cow urine.',
        'ingredientsTe': 'వేపాకులు, సీతాఫలం ఆకులు, కానుగ ఆకులు, జిల్లేడు ఆకులు, ఆముదం ఆకులు, ఆవు మూత్రం 10 లీటర్లు.',
        'ingredientsHi': 'नीम, सीताफल, करंज, आक और अरंडी के पत्ते (2-2 किग्रा), 10 लीटर गोमूत्र।',
        'prepEn': 'Crush bitter leaves and boil gently in cow urine until reduced by half. Cool and strain.',
        'prepTe': 'ఆకులను కచ్చాపచ్చాగా దంచి ఆవు మూత్రంలో వేసి చిన్న మంటపై మరిగించి చల్లార్చాలి.',
        'prepHi': 'पत्तों को कूटकर गोमूत्र में धीमी आंच पर उबालें, फिर ठंडा कर छान लें।',
        'usageEn': 'Mix 2-3 liters per 100 liters water for controlling tough caterpillars and borers.',
        'usageTe': '100 లీటర్ల నీటికి 2-3 లీటర్ల బ్రహ్మాస్త్రం కలిపి పిచికారీ చేస్తే పెద్ద పురుగులు సైతం నశిస్తాయి.',
        'usageHi': '100 लीटर पानी में 2-3 लीटर घोल मिलाकर छिड़काव करें।',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('organicFarming')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF15803D), Color(0xFF166534)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const Icon(Icons.compost_rounded, size: 40, color: Colors.white),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang == 'te' ? 'రసాయనాలు లేని సహజ సాగు' : (lang == 'hi' ? 'रसायन मुक्त प्राकृतिक खेती' : 'Chemical-Free Natural Farming'),
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang == 'te'
                              ? 'దేశీ ఆవు ఆధారిత జీవామృతం, కషాయాలతో పెట్టుబడి తగ్గించి ఆరోగ్యకరమైన దిగుబడి పొందండి.'
                              : (lang == 'hi'
                                  ? 'देसी गाय आधारित जीवामृत और काढ़े से लागत घटाएं और विषमुक्त उपज पाएं।'
                                  : 'Cut input costs and protect soil ecology with cow-based bio-fertilizers and decoctions.'),
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(
              lang == 'te' ? 'కషాయాలు & జీవామృతం తయారీ పద్ధతులు' : (lang == 'hi' ? 'जैविक काढ़ा एवं जीवामृत विधियां' : 'Bio-Formulations & Recipes'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),

            ...methods.map((m) {
              final title = lang == 'te' ? m['titleTe'] as String : (lang == 'hi' ? m['titleHi'] as String : m['titleEn'] as String);
              final cat = lang == 'te' ? m['categoryTe'] as String : (lang == 'hi' ? m['categoryHi'] as String : m['categoryEn'] as String);
              final ing = lang == 'te' ? m['ingredientsTe'] as String : (lang == 'hi' ? m['ingredientsHi'] as String : m['ingredientsEn'] as String);
              final prep = lang == 'te' ? m['prepTe'] as String : (lang == 'hi' ? m['prepHi'] as String : m['prepEn'] as String);
              final usage = lang == 'te' ? m['usageTe'] as String : (lang == 'hi' ? m['usageHi'] as String : m['usageEn'] as String);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
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
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(m['icon'] as IconData, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                              Text(cat, style: const TextStyle(fontSize: 11.5, color: AppColors.primary, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 22),
                    _buildInfoLine(
                      lang == 'te' ? 'కావలసిన పదార్థాలు:' : (lang == 'hi' ? 'आवश्यक सामग्री:' : 'Ingredients:'),
                      ing,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoLine(
                      lang == 'te' ? 'తయారీ విధానం:' : (lang == 'hi' ? 'बनाने की विधि:' : 'Preparation:'),
                      prep,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoLine(
                      lang == 'te' ? 'వాడే విధానం & లాభం:' : (lang == 'hi' ? 'प्रयोग एवं लाभ:' : 'Usage & Benefits:'),
                      usage,
                      isHighlight: true,
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

  Widget _buildInfoLine(String title, String desc, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isHighlight ? AppColors.primaryMedium : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          desc,
          style: TextStyle(fontSize: 13, height: 1.4, color: isHighlight ? AppColors.primary : null),
        ),
      ],
    );
  }
}
