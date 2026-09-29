import 'package:flutter/material.dart';

enum NotificationType {
  weather,
  market,
  fertilizer,
  pest,
  scheme,
  system,
}

class AppNotificationItem {
  final String id;
  final String title;
  final String body;
  final String time;
  final String? titleTe;
  final String? titleEn;
  final String? titleHi;
  final String? bodyTe;
  final String? bodyEn;
  final String? bodyHi;
  final String? timeTe;
  final String? timeEn;
  final String? timeHi;
  final NotificationType type;
  final bool isRead;
  final String actionRoute;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.titleTe,
    this.titleEn,
    this.titleHi,
    this.bodyTe,
    this.bodyEn,
    this.bodyHi,
    this.timeTe,
    this.timeEn,
    this.timeHi,
    required this.type,
    this.isRead = false,
    this.actionRoute = '',
  });

  String getTitle(String lang) {
    if (lang == 'te') return titleTe ?? title;
    if (lang == 'hi') return titleHi ?? title;
    return titleEn ?? title;
  }

  String getBody(String lang) {
    if (lang == 'te') return bodyTe ?? body;
    if (lang == 'hi') return bodyHi ?? body;
    return bodyEn ?? body;
  }

  String getTime(String lang) {
    if (lang == 'te') return timeTe ?? time;
    if (lang == 'hi') return timeHi ?? time;
    return timeEn ?? time;
  }

  IconData get icon {
    switch (type) {
      case NotificationType.weather:
        return Icons.water_drop_rounded;
      case NotificationType.market:
        return Icons.currency_rupee_rounded;
      case NotificationType.fertilizer:
        return Icons.science_rounded;
      case NotificationType.pest:
        return Icons.pest_control_rounded;
      case NotificationType.scheme:
        return Icons.account_balance_rounded;
      case NotificationType.system:
        return Icons.notifications_rounded;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.weather:
        return const Color(0xFF0284C7);
      case NotificationType.market:
        return const Color(0xFFEAB308);
      case NotificationType.fertilizer:
        return const Color(0xFF9333EA);
      case NotificationType.pest:
        return const Color(0xFFDC2626);
      case NotificationType.scheme:
        return const Color(0xFF2563EB);
      case NotificationType.system:
        return const Color(0xFF16A34A);
    }
  }

  String get iconEmoji => '';
}
