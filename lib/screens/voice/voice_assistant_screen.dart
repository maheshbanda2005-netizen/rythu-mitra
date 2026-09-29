import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../services/app_state_service.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  String _activeQuestion = '';
  String _activeAnswer = '';
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _askSample(String question, String answer) {
    setState(() {
      _isListening = true;
      _activeQuestion = question;
      _activeAnswer = '';
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _isListening = false;
          _activeAnswer = answer;
        });
      }
    });
  }

  void _toggleListen(BuildContext context) {
    if (_isListening) {
      setState(() => _isListening = false);
    } else {
      _askSample(context.tr('voiceQ1'), context.tr('voiceA1'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    context.watch<AppStateService>();

    final sampleQueries = [
      {'q': context.tr('voiceQ1'), 'a': context.tr('voiceA1')},
      {'q': context.tr('voiceQ2'), 'a': context.tr('voiceA2')},
      {'q': context.tr('voiceQ3'), 'a': context.tr('voiceA3')},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('voiceScreenTitle')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Header
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic_rounded, color: AppColors.primary, size: 32),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('voiceScreenSub'),
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.tr('voiceLanguageNote'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Answer / Listening / Hint panel
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: _activeAnswer.isNotEmpty
                      ? _buildAnswerBox(isDark)
                      : _isListening
                          ? _buildListeningIndicator(context)
                          : _buildHintBox(context, isDark),
                ),
              ),

              const SizedBox(height: 12),

              // Sample chips
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.tr('voiceSampleTitle'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...sampleQueries.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _askSample(item['q']!, item['a']!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1A2E22) : const Color(0xFFF0FBF2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF2A4535) : const Color(0xFFB7EFCC),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.volume_up_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item['q']!,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const Icon(Icons.play_circle_outline_rounded, size: 18, color: AppColors.primaryMedium),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Microphone button
              GestureDetector(
                onTap: () => _toggleListen(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isListening ? 92 : 80,
                  height: _isListening ? 92 : 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: _isListening ? 0.55 : 0.3),
                        blurRadius: _isListening ? 32 : 18,
                        spreadRadius: _isListening ? 6 : 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                      color: Colors.white,
                      size: _isListening ? 40 : 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerBox(bool isDark) {
    return Container(
      key: const ValueKey('answer'),
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryLight, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.record_voice_over_rounded, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _activeQuestion,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 18),
            Text(
              _activeAnswer,
              style: const TextStyle(fontSize: 13.5, height: 1.55),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListeningIndicator(BuildContext context) {
    return Container(
      key: const ValueKey('listening'),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.tr('voiceListening'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (idx) {
              return AnimatedBuilder(
                animation: _waveController,
                builder: (context, _) {
                  final val = (_waveController.value + (idx * 0.14)) % 1.0;
                  final height = 12.0 + (val * 36.0);
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 5,
                    height: height,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.7 + val * 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHintBox(BuildContext context, bool isDark) {
    return Container(
      key: const ValueKey('hint'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A261E) : const Color(0xFFEFF8EF),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.mic_none_rounded, color: AppColors.primary, size: 40),
          const SizedBox(height: 12),
          Text(
            context.tr('voiceMicHint'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
