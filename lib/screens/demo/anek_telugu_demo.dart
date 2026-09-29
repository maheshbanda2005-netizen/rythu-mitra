import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Demo screen to showcase Anek Telugu font
class AnekTeluguDemo extends StatelessWidget {
  const AnekTeluguDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Anek Telugu Font Demo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Font title
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anek Telugu Font',
                    style: GoogleFonts.anekTelugu(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'తెలుగు ఫాంట్ డెమో',
                    style: GoogleFonts.anekTelugu(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Different weights
            Text(
              'Font Weights - ఫాంట్ బరువులు',
              style: GoogleFonts.anekTelugu(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),

            _buildWeightSample('Thin (100)', FontWeight.w100, 'తెలుగు భాష'),
            _buildWeightSample('Extra Light (200)', FontWeight.w200, 'తెలుగు భాష'),
            _buildWeightSample('Light (300)', FontWeight.w300, 'తెలుగు భాష'),
            _buildWeightSample('Regular (400)', FontWeight.w400, 'తెలుగు భాష'),
            _buildWeightSample('Medium (500)', FontWeight.w500, 'తెలుగు భాష'),
            _buildWeightSample('Semi Bold (600)', FontWeight.w600, 'తెలుగు భాష'),
            _buildWeightSample('Bold (700)', FontWeight.w700, 'తెలుగు భాష'),
            _buildWeightSample('Extra Bold (800)', FontWeight.w800, 'తెలుగు భాష'),

            const SizedBox(height: 24),

            // Different sizes
            Text(
              'Font Sizes - ఫాంట్ పరిమాణాలు',
              style: GoogleFonts.anekTelugu(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),

            _buildSizeSample('Small (12px)', 12, 'రైతు మిత్ర'),
            _buildSizeSample('Normal (16px)', 16, 'రైతు మిత్ర'),
            _buildSizeSample('Large (20px)', 20, 'రైతు మిత్ర'),
            _buildSizeSample('Extra Large (28px)', 28, 'రైతు మిత్ర'),
            _buildSizeSample('Huge (36px)', 36, 'రైతు మిత్ర'),

            const SizedBox(height: 24),

            // Sample text
            Text(
              'Sample Text - నమూనా టెక్స్ట్',
              style: GoogleFonts.anekTelugu(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Text(
                'రైతు మిత్ర అనేది రైతులకు స్మార్ట్ వ్యవసాయం, మంచి నిర్ణయాలు మరియు మెరుగైన పంట దిగుబడి కోసం సహాయం చేసే అప్లికేషన్. ఇది వాతావరణ సమాచారం, పంట గైడ్, మార్కెట్ ధరలు మరియు పంట రోగాల గుర్తింపు వంటి అనేక సేవలను అందిస్తుంది.',
                style: GoogleFonts.anekTelugu(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimaryLight,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Numbers and mixed content
            Text(
              'Numbers & Mixed Content - సంఖ్యలు & మిశ్రమ కంటెంట్',
              style: GoogleFonts.anekTelugu(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'పంట ధర: ₹2,500 ప్రతి క్వింటాల్',
                    style: GoogleFonts.anekTelugu(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'వర్షపాతం: 75% అవకాశం',
                    style: GoogleFonts.anekTelugu(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ఉష్ణోగ్రత: 32°C',
                    style: GoogleFonts.anekTelugu(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightSample(String label, FontWeight weight, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.anekTelugu(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.anekTelugu(
                fontSize: 18,
                fontWeight: weight,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSample(String label, double size, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.anekTelugu(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.anekTelugu(
                fontSize: size,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}