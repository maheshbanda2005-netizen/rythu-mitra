import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../services/agri_data_service.dart';
import '../../services/app_state_service.dart';

class FertilizerCalculatorScreen extends StatefulWidget {
  const FertilizerCalculatorScreen({super.key});

  @override
  State<FertilizerCalculatorScreen> createState() => _FertilizerCalculatorScreenState();
}

class _FertilizerCalculatorScreenState extends State<FertilizerCalculatorScreen> {
  String _selectedCrop = 'cotton';
  String _selectedStage = 'flowering';
  String _selectedSoil = 'black_soil';
  int _selectedNutrientIdx = 0;

  static const List<Map<String, String>> _cropOptions = [
    {'id': 'cotton', 'te': 'పత్తి', 'en': 'Cotton', 'hi': 'कपास'},
    {'id': 'paddy', 'te': 'వరి', 'en': 'Paddy', 'hi': 'धान'},
    {'id': 'chilli', 'te': 'మిరప', 'en': 'Chilli', 'hi': 'मिर्च'},
    {'id': 'maize', 'te': 'మొక్కజొన్న', 'en': 'Maize', 'hi': 'मक्का'},
    {'id': 'redgram', 'te': 'కందులు', 'en': 'Red Gram', 'hi': 'अरहर'},
    {'id': 'tomato', 'te': 'టమోటా', 'en': 'Tomato', 'hi': 'टमाटर'},
  ];

  static const List<Map<String, String>> _stageOptions = [
    {'id': 'basal', 'te': 'విత్తే సమయంలో (ఆఖరి దుక్కి)', 'en': 'Sowing / Basal Stage', 'hi': 'बुवाई के समय'},
    {'id': 'vegetative', 'te': 'శాఖీయ దశ (25-45 రోజులు)', 'en': 'Vegetative Stage (25-45 days)', 'hi': 'वानस्पतिक अवस्था (25-45 दिन)'},
    {'id': 'flowering', 'te': 'పూత దశ (50-75 రోజులు)', 'en': 'Flowering Stage (50-75 days)', 'hi': 'फूल आने की अवस्था (50-75 दिन)'},
    {'id': 'fruiting', 'te': 'కాయ లేదా గింజ అభివృద్ధి దశ', 'en': 'Fruit / Boll Formation Stage', 'hi': 'फल विकास अवस्था'},
    {'id': 'maturity', 'te': 'కోతకు ముందు దశ', 'en': 'Pre-Harvest Maturity Stage', 'hi': 'परिपक्वता अवस्था'},
  ];

  static const List<Map<String, String>> _soilOptions = [
    {'id': 'black_soil', 'te': 'నల్లరేగడి నేలలు', 'en': 'Black Cotton Soil', 'hi': 'काली मिट्टी'},
    {'id': 'red_soil', 'te': 'ఎర్ర నేలలు / గరప నేలలు', 'en': 'Red Sandy Loam Soil', 'hi': 'लाल बलुई दोमट मिट्टी'},
    {'id': 'clay_soil', 'te': 'బంకమన్ను నేలలు', 'en': 'Clayey Loam Soil', 'hi': 'चिकनी दोमट मिट्टी'},
    {'id': 'alluvial_soil', 'te': 'ఒండ్రు నేలలు', 'en': 'Alluvial Soil', 'hi': 'जलोढ़ मिट्टी'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final recs = AgriDataService.fertilizerRecommendations;
    final lang = appState.currentLanguage;
    final activeRec = recs[_selectedNutrientIdx];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang == 'te'
              ? 'ఎరువుల యాజమాన్యం'
              : (lang == 'hi' ? 'उर्वरक प्रबंधन' : 'Fertilizer Calculator'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Advisory Banner Distinguishing Disease vs Deficiency
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFCD34D)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 22, color: Color(0xFF92400E)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang == 'te'
                              ? 'ముఖ్యమైన శాస్త్రీయ నియమం'
                              : (lang == 'hi' ? 'महत्वपूर्ण वैज्ञानिक नियम' : 'Important Scientific Rule'),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF92400E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lang == 'te'
                              ? 'రోగం లేదా పురుగు ఆశించినప్పుడు నేరుగా ఎరువులు వేయకూడదు. పోషక లోపాలు మాత్రమే ఇక్కడ పరిశీలించండి.'
                              : (lang == 'hi'
                                  ? 'कीट या रोग लगने पर सीधे खाद न डालें। यहाँ केवल पोषक तत्वों की कमी की जांच करें।'
                                  : 'Do not apply fertilizers directly when crops are attacked by pests or diseases. Use this tool for nutrient deficiencies only.'),
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF78350F),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Selectors Section
            Text(
              lang == 'te'
                  ? 'ఖచ్చితమైన పోషక గణన'
                  : (lang == 'hi' ? 'सटीक पोषक तत्व गणना' : 'Accurate Nutrient Calculator'),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),

            // 1. Crop Selector
            _buildDropdown(
              label: lang == 'te' ? '1. పంటను ఎంచుకోండి' : (lang == 'hi' ? '1. फसल चुनें' : '1. Select Crop'),
              value: _selectedCrop,
              items: _cropOptions,
              onChanged: (val) => setState(() => _selectedCrop = val!),
              icon: Icons.eco_rounded,
              lang: lang,
            ),
            const SizedBox(height: 14),

            // 2. Growth Stage
            _buildDropdown(
              label: lang == 'te' ? '2. పంట ప్రస్తుత దశ' : (lang == 'hi' ? '2. फसल की वर्तमान अवस्था' : '2. Growth Stage'),
              value: _selectedStage,
              items: _stageOptions,
              onChanged: (val) => setState(() => _selectedStage = val!),
              icon: Icons.spa_rounded,
              lang: lang,
            ),
            const SizedBox(height: 14),

            // 3. Soil Type
            _buildDropdown(
              label: lang == 'te' ? '3. మీ నేల రకం' : (lang == 'hi' ? '3. मिट्टी का प्रकार' : '3. Soil Type'),
              value: _selectedSoil,
              items: _soilOptions,
              onChanged: (val) => setState(() => _selectedSoil = val!),
              icon: Icons.landscape_rounded,
              lang: lang,
            ),
            const SizedBox(height: 20),

            // 4. Observed Nutrient Deficiency Buttons
            Text(
              lang == 'te'
                  ? '4. మీరు గమనించిన పోషక లోపం:'
                  : (lang == 'hi' ? '4. देखी गई पोषक तत्व की कमी:' : '4. Observed Nutrient Deficiency:'),
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recs.length,
                separatorBuilder: (_, index) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final r = recs[idx];
                  final isSelected = _selectedNutrientIdx == idx;
                  return ChoiceChip(
                    label: Text('${r.nutrientSymbol} • ${r.getLocalizedNutrient(lang)}'),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 12,
                    ),
                    onSelected: (_) => setState(() => _selectedNutrientIdx = idx),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Recommendation Card
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF16241C) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.primaryLight,
                  width: 1.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
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
                          child: Text(
                            activeRec.nutrientSymbol,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeRec.getLocalizedNutrient(lang),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Dosage
                    _buildResultRow(
                      lang == 'te' ? 'సిఫార్సు చేసిన మోతాదు:' : (lang == 'hi' ? 'अनुशंसित मात्रा:' : 'Recommended Dose:'),
                      activeRec.getDosage(lang),
                      isHighlight: true,
                    ),
                    const SizedBox(height: 12),

                    // Commercial Fertilizer
                    _buildResultRow(
                      lang == 'te' ? 'వాడవలసిన ఎరువు:' : (lang == 'hi' ? 'अनुशंसित उर्वरक:' : 'Commercial Fertilizer:'),
                      activeRec.getCommercialFertilizer(lang),
                    ),
                    const SizedBox(height: 12),

                    // Application Timing
                    _buildResultRow(
                      lang == 'te' ? 'వేయవలసిన సరైన సమయం:' : (lang == 'hi' ? 'सही समय:' : 'Application Timing:'),
                      activeRec.getApplicationTiming(lang),
                    ),
                    const SizedBox(height: 12),

                    // Application Method
                    _buildResultRow(
                      lang == 'te' ? 'వేసే విధానం:' : (lang == 'hi' ? 'प्रयोग विधि:' : 'Application Method:'),
                      activeRec.getApplicationMethod(lang),
                    ),
                    const SizedBox(height: 12),

                    // Deficiency Symptoms
                    _buildResultRow(
                      lang == 'te' ? 'లోప లక్షణాలు:' : (lang == 'hi' ? 'कमी के लक्षण:' : 'Deficiency Symptoms:'),
                      activeRec.getDeficiencySymptoms(lang),
                    ),
                    const SizedBox(height: 12),

                    // Organic Alternative
                    _buildResultRow(
                      lang == 'te' ? 'సేంద్రియ ప్రత్యామ్నాయం:' : (lang == 'hi' ? 'जैविक विकल्प:' : 'Organic Option:'),
                      activeRec.getOrganicAlternative(lang),
                    ),
                    const SizedBox(height: 12),

                    // Precautions
                    _buildResultRow(
                      lang == 'te' ? 'తీసుకోవలసిన జాగ్రత్తలు:' : (lang == 'hi' ? 'आवश्यक सावधानियां:' : 'Precautions:'),
                      activeRec.getPrecautions(lang),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Statutory Disclaimer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2822) : const Color(0xFFF1F5F1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                lang == 'te'
                    ? 'గమనిక: ఈ సిఫార్సులు ICAR మరియు వ్యవసాయ విశ్వవిద్యాలయ సాధారణ మార్గదర్శకాలు మాత్రమే. భూసార పరీక్ష ఫలితాల ఆధారంగా మోతాదును సర్దుబాటు చేసుకోవాలి.'
                    : (lang == 'hi'
                        ? 'नोट: ये सिफारिशें ICAR और कृषि विश्वविद्यालय के सामान्य दिशा-निर्देश हैं। मृदा परीक्षण कार्ड के अनुसार मात्रा समायोजित करें।'
                        : 'Note: These recommendations are general ICAR & Agri University guidelines. Fine-tune quantities as per your Soil Health Card test results.'),
                style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<Map<String, String>> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    required String lang,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E3025)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: items.map((item) {
                final displayLabel = item[lang] ?? item['en'] ?? '';
                return DropdownMenuItem(
                  value: item['id'],
                  child: Row(
                    children: [
                      Icon(icon, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          displayLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultRow(String title, String value, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isHighlight ? AppColors.primary : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 15 : 13,
            fontWeight: isHighlight ? FontWeight.w900 : FontWeight.w500,
            color: isHighlight ? AppColors.primaryMedium : null,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
