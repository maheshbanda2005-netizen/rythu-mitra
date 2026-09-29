import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../services/ai_diagnosis_service.dart';
import '../../services/app_state_service.dart';
import 'diagnosis_result_screen.dart';
import '../voice/voice_assistant_screen.dart';

class AIDiagnosisScreen extends StatefulWidget {
  const AIDiagnosisScreen({super.key});

  @override
  State<AIDiagnosisScreen> createState() => _AIDiagnosisScreenState();
}

class _AIDiagnosisScreenState extends State<AIDiagnosisScreen>
    with SingleTickerProviderStateMixin {
  bool _isAnalyzing = false;
  String _selectedCropHint = 'Cotton';
  late AnimationController _laserAnimController;

  @override
  void initState() {
    super.initState();
    _laserAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _laserAnimController.dispose();
    super.dispose();
  }

  void _runAnalysis(String cropHint) async {
    setState(() {
      _selectedCropHint = cropHint;
      _isAnalyzing = true;
    });

    final report = await AIDiagnosisService.analyzeCropImage(cropHint);

    if (mounted) {
      setState(() => _isAnalyzing = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DiagnosisResultScreen(report: report),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final lang = context.watch<AppStateService>().currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('diseaseAI')),
      ),
      body: _isAnalyzing
          ? _buildScanningAnimation(isDark)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang == 'te' ? 'పంట ఆరోగ్యాన్ని పరీక్షించండి' : (lang == 'hi' ? 'फसल स्वास्थ्य की जांच करें' : 'Check Your Crop Health'),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lang == 'te'
                        ? 'మీ పంట ఆకు లేదా కాండం ఫోటో తీయండి. AI క్షణాల్లో తెగులును విశ్లేషించి నివారణ చర్యలను సూచిస్తుంది.'
                        : (lang == 'hi'
                            ? 'अपनी फसल की पत्ती या तने की फोटो लें। AI तुरंत कीट और रोग की पहचान कर समाधान देगा।'
                            : 'Snap a photo of the affected leaf or stem. AI instantly detects pests & diseases with remedies.'),
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Camera viewfinder mock area
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF16241C) : const Color(0xFFEFF7F0),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.primaryLight,
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 44,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          lang == 'te'
                              ? 'మంచి వెలుతురులో ఆకు స్పష్టంగా ఉండేలా చూడండి'
                              : (lang == 'hi' ? 'अच्छी रोशनी में पत्ती स्पष्ट दिखाई दे' : 'Ensure good lighting on the leaf'),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang == 'te'
                              ? 'కెమెరాను ఆకు నుండి 10–15 సెం.మీ దూరంలో ఉంచండి'
                              : (lang == 'hi' ? 'कैमरे को पत्ती से 10–15 सेमी दूर रखें' : 'Keep camera 10–15 cm away from leaf'),
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _runAnalysis('Cotton'),
                          icon: const Icon(Icons.photo_camera_rounded),
                          label: Text(lang == 'te' ? 'ఫోటో తీయండి' : (lang == 'hi' ? 'फोटो खींचें' : 'Take Photo')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(0, 52),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _runAnalysis('Paddy'),
                          icon: const Icon(Icons.photo_library_rounded),
                          label: Text(lang == 'te' ? 'గ్యాలరీ నుండి' : (lang == 'hi' ? 'गैलरी से' : 'Upload Photo')),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 52),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Describe Voice Button
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VoiceAssistantScreen()),
                      );
                    },
                    icon: const Icon(Icons.mic_rounded, color: AppColors.primary),
                    label: Text(lang == 'te' ? 'మాటలతో సమస్యను వివరించండి' : (lang == 'hi' ? 'बोलकर समस्या बताएं' : 'Describe Problem with Voice')),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Instant Leaf Diagnosis Samples for Quick Testing
                  Text(
                    lang == 'te' ? 'లేదా నమూనా ఆకులను పరీక్షించండి:' : (lang == 'hi' ? 'या नमूना पत्ती की जांच करें:' : 'Or Try Sample Leaf Diagnosis:'),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  _buildSampleTile(
                    Icons.spa_rounded,
                    lang == 'te' ? 'పత్తి ఆకు ముడుత & రసం పీల్చే పురుగులు' : (lang == 'hi' ? 'कपास पत्ती मरोड़ एवं रस चूसक कीट' : 'Cotton Leaf Curl & Sucking Pests'),
                    'Cotton',
                    '94% Likely',
                    lang,
                  ),
                  const SizedBox(height: 8),
                  _buildSampleTile(
                    Icons.grass_rounded,
                    lang == 'te' ? 'వరి అగ్గితెగులు మచ్చలు' : (lang == 'hi' ? 'धान का झुलसा रोग' : 'Paddy Blast Disease'),
                    'Paddy',
                    '96% Confirmed',
                    lang,
                  ),
                  const SizedBox(height: 8),
                  _buildSampleTile(
                    Icons.local_fire_department_rounded,
                    lang == 'te' ? 'మిరపలో నల్ల తామర పురుగుల ఉధృతి' : (lang == 'hi' ? 'मिर्च में ब्लैक थ्रिप्स का प्रकोप' : 'Chilli Black Thrips Infestation'),
                    'Chilli',
                    '91% Likely',
                    lang,
                  ),
                  const SizedBox(height: 8),
                  _buildSampleTile(
                    Icons.eco_rounded,
                    lang == 'te' ? 'టమోటా ముందస్తు మాడు తెగులు' : (lang == 'hi' ? 'टमाटर अगेती झुलसा' : 'Tomato Early Blight'),
                    'Tomato',
                    '88% Likely',
                    lang,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildSampleTile(IconData icon, String title, String cropHint, String confidence, String lang) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        tileColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF18281E)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        subtitle: Text(
          '${lang == 'te' ? 'AI అంచనా' : (lang == 'hi' ? 'AI सटीकता' : 'AI Confidence')}: $confidence',
          style: const TextStyle(fontSize: 11, color: AppColors.primaryLight),
        ),
        trailing: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
        onTap: () => _runAnalysis(cropHint),
      ),
    );
  }

  Widget _buildScanningAnimation(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF132318) : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primaryLight, width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.eco_rounded, size: 72, color: AppColors.primary),
                ),
              ),
              AnimatedBuilder(
                animation: _laserAnimController,
                builder: (context, child) {
                  return Positioned(
                    top: 10 + (_laserAnimController.value * 170),
                    child: Container(
                      width: 190,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withValues(alpha: 0.8),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'AI $_selectedCropHint పంటను విశ్లేషిస్తోంది...',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Scanning for fungal pathogens, pests & nutrient deficiency...',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          const SizedBox(
            width: 140,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
            ),
          ),
        ],
      ),
    );
  }
}
