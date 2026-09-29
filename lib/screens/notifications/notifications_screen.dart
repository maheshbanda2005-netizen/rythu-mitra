import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../services/app_state_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();

    final lang = appState.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('notifications')),
        actions: [
          TextButton(
            onPressed: () => appState.markAllNotificationsAsRead(),
            child: Text(context.tr('active'), style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: appState.notifications.isEmpty
          ? Center(
              child: Text(
                lang == 'te'
                    ? 'నోటిఫికేషన్లు ఏమీ లేవు'
                    : (lang == 'hi' ? 'कोई सूचना नहीं है' : 'No notifications yet'),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(18),
              itemCount: appState.notifications.length,
              separatorBuilder: (_, index) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final notif = appState.notifications[idx];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: notif.isRead
                        ? (isDark ? const Color(0xFF16241C) : Colors.white)
                        : (isDark ? const Color(0xFF1F3325) : const Color(0xFFEFF8F0)),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: notif.isRead
                          ? (isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0))
                          : AppColors.primaryLight,
                      width: notif.isRead ? 1 : 1.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: notif.iconColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(notif.icon, color: notif.iconColor, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notif.getTitle(lang),
                                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
                                  ),
                                ),
                                Text(
                                  notif.getTime(lang),
                                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notif.getBody(lang),
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
