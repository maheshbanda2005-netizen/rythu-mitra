import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../services/app_state_service.dart';
import '../auth/login_screen.dart';

class LanguageScreen extends StatefulWidget {
  final bool isFromSettings;

  const LanguageScreen({super.key, this.isFromSettings = false});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String _selectedLang;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppStateService>(context, listen: false);
    _selectedLang = appState.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();

    final languages = [
      {
        'code': 'te',
        'title': 'తెలుగు',
        'sub': _selectedLang == 'te'
            ? 'రైతు సోదరుల కోసం ప్రత్యేకంగా రూపొందించబడింది'
            : (_selectedLang == 'hi'
                ? 'तेलुगु भाषी किसानों के लिए विशेष रूप से निर्मित'
                : 'Designed specifically for Telugu-speaking farmers'),
        'icon': Icons.spa_rounded,
        'greeting': 'నమస్కారం రైతు గారు',
      },
      {
        'code': 'en',
        'title': 'English',
        'sub': _selectedLang == 'te'
            ? 'స్మార్ట్ వ్యవసాయ సలహాలు & మార్కెట్ సమాచారం'
            : (_selectedLang == 'hi'
                ? 'स्मार्ट कृषि सहायक एवं मंडी जानकारी'
                : 'Smart agricultural assistant & market intelligence'),
        'icon': Icons.language_rounded,
        'greeting': 'Welcome Farmer',
      },
      {
        'code': 'hi',
        'title': 'हिन्दी',
        'sub': _selectedLang == 'te'
            ? 'భారతీయ రైతులకు నిజమైన డిజిటల్ తోడు'
            : (_selectedLang == 'hi'
                ? 'भारतीय किसानों का सच्चा डिजिटल साथी'
                : 'Digital companion for Indian farmers'),
        'icon': Icons.translate_rounded,
        'greeting': 'नमस्ते किसान भाई',
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isFromSettings)
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.pop(context),
                )
              else
                const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.translate_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _selectedLang == 'te'
                    ? 'మీ భాషను ఎంచుకోండి'
                    : (_selectedLang == 'hi'
                        ? 'अपनी भाषा चुनें'
                        : 'Select Your Language'),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _selectedLang == 'te'
                    ? 'మీరు తర్వాత ఎప్పుడైనా ప్రొఫైల్ నుండి భాషను మార్చుకోవచ్చు.'
                    : (_selectedLang == 'hi'
                        ? 'आप बाद में भी सेटिंग्स से भाषा बदल सकते हैं।'
                        : 'You can change your preferred language anytime in settings.'),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 32),
              // Language Cards
              Expanded(
                child: ListView.separated(
                  itemCount: languages.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final code = lang['code'] as String;
                    final isSelected = _selectedLang == code;

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedLang = code);
                        appState.setLanguage(code);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? AppColors.primaryContainerDark
                                  : const Color(0xFFEFF7F0))
                              : (isDark ? const Color(0xFF16241C) : Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryLight
                                : (isDark
                                    ? const Color(0xFF263D30)
                                    : const Color(0xFFE2EBE0)),
                            width: isSelected ? 2.2 : 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.12)
                                  : Colors.black.withValues(alpha: 0.03),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                lang['icon'] as IconData,
                                color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : Colors.black54),
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang['title'] as String,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: isSelected
                                          ? (isDark ? Colors.white : AppColors.primary)
                                          : (isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimaryLight),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    lang['sub'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.withValues(alpha: 0.4),
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Continue Button
              ElevatedButton(
                onPressed: () {
                  appState.setLanguage(_selectedLang);
                  if (widget.isFromSettings) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  _selectedLang == 'te'
                      ? 'ముందుకు సాగండి →'
                      : (_selectedLang == 'hi' ? 'आगे बढ़ें →' : 'Continue →'),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
