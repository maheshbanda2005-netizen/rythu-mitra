import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../services/app_state_service.dart';
import '../language/language_screen.dart';
import '../emergency/emergency_screen.dart';
import '../expenses/farm_expenses_screen.dart';
import '../calendar/farm_calendar_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('profile')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // Farmer Avatar & Name Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF16241C) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.primaryContainer,
                    child: const Icon(Icons.person_rounded, size: 40, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appState.farmerName,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '+91 98480 12345',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${lang == 'te' ? 'పట్టాదారు పాస్‌బుక్' : (lang == 'hi' ? 'पट्टा पासबुक' : 'Passbook ID')}: T28140029',
                              style: TextStyle(fontSize: 11.5, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Farm Details Stats Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E3025) : const Color(0xFFF4F9F4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildProfileMetric(
                      lang == 'te' ? 'మొత్తం భూమి' : (lang == 'hi' ? 'कुल भूमि' : 'Total Land'),
                      '${appState.farmAreaAcres} ${lang == 'te' ? 'ఎకరాలు' : (lang == 'hi' ? 'एकड़' : 'Acres')}',
                    ),
                  ),
                  Container(width: 1, height: 28, color: Colors.grey.withValues(alpha: 0.3)),
                  Expanded(
                    child: _buildProfileMetric(
                      lang == 'te' ? 'ప్రస్తుత పంట' : (lang == 'hi' ? 'वर्तमान फसल' : 'Active Crop'),
                      appState.activeCrop,
                    ),
                  ),
                  Container(width: 1, height: 28, color: Colors.grey.withValues(alpha: 0.3)),
                  Expanded(
                    child: _buildProfileMetric(
                      lang == 'te' ? 'మండలం' : (lang == 'hi' ? 'मंडल' : 'Mandal'),
                      lang == 'te' ? 'వరంగల్ రూరల్' : (lang == 'hi' ? 'वारंगल ग्रामीण' : 'Warangal Rural'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings & Actions Menu List
            _buildMenuTile(
              icon: Icons.translate_rounded,
              title: lang == 'te' ? 'భాషను మార్చండి' : (lang == 'hi' ? 'भाषा बदलें' : 'Change Language'),
              subtitle: lang == 'te' ? 'తెలుగు' : (lang == 'hi' ? 'हिन्दी' : 'English'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LanguageScreen(isFromSettings: true)),
                );
              },
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.dark_mode_rounded,
              title: lang == 'te' ? 'డార్క్ మోడ్' : (lang == 'hi' ? 'डार्क थीम' : 'Dark Theme'),
              subtitle: appState.isDarkMode
                  ? (lang == 'te' ? 'ఆన్ చేయబడింది' : (lang == 'hi' ? 'सक्रिय' : 'Enabled'))
                  : (lang == 'te' ? 'లైట్ మోడ్' : (lang == 'hi' ? 'लाइट थीम' : 'Light Theme')),
              trailing: Switch(
                value: appState.isDarkMode,
                activeThumbColor: AppColors.primaryLight,
                onChanged: (_) => appState.toggleTheme(),
              ),
              onTap: () => appState.toggleTheme(),
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.calendar_month_rounded,
              title: lang == 'te' ? 'నా పంట క్యాలెండర్' : (lang == 'hi' ? 'मेरा फसल कैलेंडर' : 'Farm Calendar'),
              subtitle: lang == 'te' ? 'రోజువారీ వ్యవసాయ కార్యకలాపాలు' : (lang == 'hi' ? 'दैनिक कृषि गतिविधियां' : 'Daily farming cultivation schedule'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FarmCalendarScreen()));
              },
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.account_balance_wallet_rounded,
              title: lang == 'te' ? 'ఖర్చుల రికార్డు' : (lang == 'hi' ? 'कृषि व्यय रिकॉर्ड' : 'Farm Expenses'),
              subtitle: lang == 'te' ? 'పెట్టుబడి మరియు లాభాల లెక్కలు' : (lang == 'hi' ? 'लागत और लाभ का हिसाब' : 'Cost & profit management'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FarmExpensesScreen()));
              },
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.emergency_rounded,
              title: lang == 'te' ? 'అత్యవసర కిసాన్ హెల్ప్‌లైన్' : (lang == 'hi' ? 'आपातकालीन किसान हेल्पलाइन' : 'Emergency Kisan Helpline'),
              subtitle: lang == 'te' ? '1551 & వ్యవసాయ అధికారులు' : (lang == 'hi' ? '1551 एवं कृषि अधिकारी' : '1551 & Agriculture Officers'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyScreen()));
              },
              isDark: isDark,
            ),
            _buildMenuTile(
              icon: Icons.privacy_tip_outlined,
              title: lang == 'te' ? 'గోప్యత & నిబంధనలు' : (lang == 'hi' ? 'गोपनीयता नीति' : 'Privacy Policy'),
              subtitle: lang == 'te' ? 'మీ డేటా పూర్తిగా సురక్షితం' : (lang == 'hi' ? 'आपका डेटा पूर्णतः सुरक्षित है' : 'Your farm data is encrypted & safe'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      lang == 'te'
                          ? 'రైతు మిత్ర మీ వ్యవసాయ డేటాను సురక్షితంగా భద్రపరుస్తుంది.'
                          : (lang == 'hi'
                              ? 'रायथू मित्र आपके कृषि डेटा को सुरक्षित रखता है।'
                              : 'Rythu Mitra protects your farm data securely.'),
                    ),
                  ),
                );
              },
              isDark: isDark,
            ),
            const SizedBox(height: 14),

            // Logout Button
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
              label: Text(
                lang == 'te' ? 'లాగ్ అవుట్' : (lang == 'hi' ? 'लॉग आउट' : 'Sign Out'),
                style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFCA5A5)),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMetric(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
          ),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          subtitle: Text(subtitle, style: TextStyle(fontSize: 11.5, color: Colors.grey[600])),
          trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: onTap,
        ),
      ),
    );
  }
}
