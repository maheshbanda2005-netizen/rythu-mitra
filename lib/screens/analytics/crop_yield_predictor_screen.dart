import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_service.dart';
import '../../services/kaggle_crop_yield_service.dart';

class CropYieldPredictorScreen extends StatefulWidget {
  final String? initialCropName;

  const CropYieldPredictorScreen({super.key, this.initialCropName});

  @override
  State<CropYieldPredictorScreen> createState() => _CropYieldPredictorScreenState();
}

class _CropYieldPredictorScreenState extends State<CropYieldPredictorScreen> {
  late String _selectedCrop;
  String _selectedSoil = 'Loam';
  double _rainfallMm = 650;
  double _tempC = 28;
  bool _fertilizerUsed = true;
  bool _irrigationUsed = true;
  String _weatherCondition = 'Sunny';
  int _daysToHarvest = 110;

  final List<String> _crops = ['Cotton', 'Rice', 'Maize', 'Soybean', 'Wheat', 'Barley'];
  final List<String> _soils = ['Loam', 'Silt', 'Clay', 'Sandy', 'Peaty', 'Chalky'];
  final List<String> _weathers = ['Sunny', 'Cloudy', 'Rainy'];

  @override
  void initState() {
    super.initState();
    _selectedCrop = _crops.first;
    if (widget.initialCropName != null) {
      final match = KaggleCropYieldService.getBenchmarkForCrop(widget.initialCropName!);
      if (match != null && _crops.contains(match.cropName)) {
        _selectedCrop = match.cropName;
      }
    }
  }

  String _getLocalizedCrop(String crop, String lang) {
    switch (crop) {
      case 'Cotton':
        return lang == 'te' ? 'పత్తి (Cotton)' : (lang == 'hi' ? 'कपास (Cotton)' : 'Cotton');
      case 'Rice':
        return lang == 'te' ? 'వరి (Paddy / Rice)' : (lang == 'hi' ? 'धान (Rice)' : 'Rice (Paddy)');
      case 'Maize':
        return lang == 'te' ? 'మొక్కజొన్న (Maize)' : (lang == 'hi' ? 'मक्का (Maize)' : 'Maize');
      case 'Soybean':
        return lang == 'te' ? 'సోయాబీన్ (Soybean)' : (lang == 'hi' ? 'सोयाबीन (Soybean)' : 'Soybean');
      case 'Wheat':
        return lang == 'te' ? 'గోధుమ (Wheat)' : (lang == 'hi' ? 'गेहूं (Wheat)' : 'Wheat');
      case 'Barley':
        return lang == 'te' ? 'బార్లీ (Barley)' : (lang == 'hi' ? 'जौ (Barley)' : 'Barley');
      default:
        return crop;
    }
  }

  String _getLocalizedSoil(String soil, String lang) {
    switch (soil) {
      case 'Loam':
        return lang == 'te' ? 'ఒండ్రు నేల (Loam)' : 'Loam Soil';
      case 'Clay':
        return lang == 'te' ? 'నల్లరేగడి / బంకమన్ను (Clay)' : 'Clay / Black Soil';
      case 'Sandy':
        return lang == 'te' ? 'ఇసుక గరప నేల (Sandy)' : 'Sandy Loam';
      case 'Silt':
        return lang == 'te' ? 'సిల్ట్ నేల (Silt)' : 'Silt Soil';
      case 'Peaty':
        return lang == 'te' ? 'సేంద్రియ నేల (Peaty)' : 'Peaty Soil';
      case 'Chalky':
        return lang == 'te' ? 'సున్నపు నేల (Chalky)' : 'Chalky Soil';
      default:
        return soil;
    }
  }

  double _getMspPricePerQuintal(String crop) {
    switch (crop) {
      case 'Cotton':
        return 7521;
      case 'Rice':
        return 2300;
      case 'Maize':
        return 2225;
      case 'Soybean':
        return 4892;
      case 'Wheat':
        return 2275;
      case 'Barley':
        return 1850;
      default:
        return 2500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;

    final input = YieldPredictionInput(
      cropName: _selectedCrop,
      soilType: _selectedSoil,
      rainfallMm: _rainfallMm,
      temperatureC: _tempC,
      fertilizerUsed: _fertilizerUsed,
      irrigationUsed: _irrigationUsed,
      weatherCondition: _weatherCondition,
      daysToHarvest: _daysToHarvest,
    );

    final result = KaggleCropYieldService.predictYield(input);
    final benchmark = KaggleCropYieldService.benchmarks[_selectedCrop];
    final msp = _getMspPricePerQuintal(_selectedCrop);
    final estRevenue = (result.yieldQuintalsPerAcre * msp).round();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang == 'te'
              ? 'AI దిగుబడి అంచనా (Kaggle)'
              : (lang == 'hi' ? 'एआई फसल पैदावार अनुमान' : 'AI Crop Yield Predictor'),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Kaggle Dataset Citation Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.dataset_rounded, color: Color(0xFF38BDF8), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Kaggle Verified Dataset',
                            style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('1M Rows', style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'samuelotiattakorah/agriculture-crop-yield',
                        style: TextStyle(color: Colors.white70, fontSize: 10.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Main Prediction Result Hero Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF14301D), const Color(0xFF0C2013)]
                    : [const Color(0xFF166534), const Color(0xFF14532D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF166534).withValues(alpha: 0.35),
                  blurRadius: 18,
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
                      lang == 'te' ? 'అంచనా వేసిన దిగుబడి (Yield):' : 'Estimated Crop Yield:',
                      style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${result.efficiencyGrade} Efficiency',
                        style: const TextStyle(color: Color(0xFF86EFAC), fontSize: 11, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Big Yield Value
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${result.yieldQuintalsPerAcre}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lang == 'te' ? 'క్వింటాళ్లు / ఎకరా' : 'Quintals / Acre',
                      style: const TextStyle(color: Color(0xFFA7F3D0), fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Text(
                  '≈ ${result.yieldTonsPerHectare} Metric Tons / Hectare',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12.5),
                ),
                const SizedBox(height: 16),

                // Comparison against Kaggle Benchmark
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        result.percentageVersusAverage >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                        color: result.percentageVersusAverage >= 0 ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          lang == 'te'
                              ? 'జాతీయ సగటు (18.8 క్విం.) కంటే ${result.percentageVersusAverage >= 0 ? '+' : ''}${result.percentageVersusAverage}% ${result.percentageVersusAverage >= 0 ? 'అధికం' : 'తక్కువ'}'
                              : '${result.percentageVersusAverage >= 0 ? '+' : ''}${result.percentageVersusAverage}% vs National 1M Avg (18.8 Qtl)',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Estimated Revenue at Mandi Rate
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang == 'te' ? 'అంచనా మార్కెట్ ఆదాయం (MSP):' : 'Est. Gross Revenue:',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      '₹${estRevenue.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} / ఎకరా',
                      style: const TextStyle(color: Color(0xFFFDE047), fontSize: 15, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Input Controls Section
          Text(
            lang == 'te' ? 'మీ పొలం వివరాలను ఎంచుకోండి:' : 'Enter Your Farm Parameters:',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),

          // Crop Selector
          _buildDropdownTile(
            label: lang == 'te' ? 'పంట (Crop)' : 'Crop',
            value: _selectedCrop,
            items: _crops.map((c) => DropdownMenuItem(value: c, child: Text(_getLocalizedCrop(c, lang)))).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCrop = val);
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Soil Selector
          _buildDropdownTile(
            label: lang == 'te' ? 'నేల రకం (Soil Type)' : 'Soil Type',
            value: _selectedSoil,
            items: _soils.map((s) => DropdownMenuItem(value: s, child: Text(_getLocalizedSoil(s, lang)))).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedSoil = val);
            },
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Weather Condition Selector
          _buildDropdownTile(
            label: lang == 'te' ? 'వాతావరణం (Weather)' : 'Weather',
            value: _weatherCondition,
            items: _weathers.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _weatherCondition = val);
            },
            isDark: isDark,
          ),
          const SizedBox(height: 14),

          // Fertilizer Switch
          _buildSwitchTile(
            title: lang == 'te' ? 'రసాయనిక / సేంద్రియ ఎరువులు వాడారా?' : 'Fertilizer Applied?',
            subtitle: lang == 'te' ? '+6.1 క్వింటాళ్లు / ఎకరా దిగుబడి పెరుగుదల' : '+6.1 Qtl/Acre boost from dataset',
            value: _fertilizerUsed,
            activeColor: const Color(0xFF16A34A),
            onChanged: (val) => setState(() => _fertilizerUsed = val),
            isDark: isDark,
          ),
          const SizedBox(height: 10),

          // Irrigation Switch
          _buildSwitchTile(
            title: lang == 'te' ? 'సమయానుకూల నీటిపారుదల (Irrigation) ఉందా?' : 'Irrigation Facility Used?',
            subtitle: lang == 'te' ? '+4.8 క్వింటాళ్లు / ఎకరా అదనపు లాభం' : '+4.8 Qtl/Acre irrigation advantage',
            value: _irrigationUsed,
            activeColor: const Color(0xFF0284C7),
            onChanged: (val) => setState(() => _irrigationUsed = val),
            isDark: isDark,
          ),
          const SizedBox(height: 14),

          // Rainfall Slider
          _buildSliderCard(
            title: lang == 'te' ? 'అంచనా వర్షపాతం (Rainfall mm)' : 'Expected Rainfall (mm)',
            value: _rainfallMm,
            min: 150,
            max: 1200,
            unit: 'mm',
            onChanged: (v) => setState(() => _rainfallMm = v),
            isDark: isDark,
            activeColor: const Color(0xFF0284C7),
          ),
          const SizedBox(height: 12),

          // Temperature Slider
          _buildSliderCard(
            title: lang == 'te' ? 'సగటు ఉష్ణోగ్రత (°C)' : 'Average Temperature (°C)',
            value: _tempC,
            min: 16,
            max: 42,
            unit: '°C',
            onChanged: (v) => setState(() => _tempC = v),
            isDark: isDark,
            activeColor: const Color(0xFFEA580C),
          ),
          const SizedBox(height: 12),

          // Days to Harvest Slider
          _buildSliderCard(
            title: lang == 'te' ? 'పంట కాలం / కోత సమయం (Days)' : 'Days to Harvest',
            value: _daysToHarvest.toDouble(),
            min: 75,
            max: 180,
            unit: 'days',
            onChanged: (v) => setState(() => _daysToHarvest = v.round()),
            isDark: isDark,
            activeColor: const Color(0xFF8B5CF6),
          ),
          const SizedBox(height: 20),

          // Agronomic Insights from AI
          Text(
            lang == 'te' ? 'శాస్త్రీయ పరిశీలనలు (Agronomic Insights):' : 'Key Agronomic Insights:',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ...(lang == 'te' ? result.agronomicInsightsTe : result.agronomicInsightsEn).map((insight) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E3025) : const Color(0xFFF1F7F1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF2E4B39) : const Color(0xFFCDE2CF),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      insight,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),

          // Dataset benchmark card
          if (benchmark != null)
            Container(
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
                  Text(
                    '$_selectedCrop — 1M Kaggle Records Breakdown',
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sample Records Analyzed:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      Text(benchmark.recordCount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'),
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Average Days to Harvest:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      Text('${benchmark.avgDaysToHarvest} days', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fertilizer Boost Gain:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      Text('+${benchmark.fertilizerBoostTonsPerHa} T/Ha (+${benchmark.fertilizerPercentageGain}%)',
                          style: const TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.w800, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: items,
              onChanged: onChanged,
              dropdownColor: isDark ? const Color(0xFF16241C) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Color activeColor,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.black54)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: activeColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderCard({
    required String title,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
    required bool isDark,
    required Color activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              Text(
                '${value.round()} $unit',
                style: TextStyle(color: activeColor, fontSize: 14, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            activeColor: activeColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
