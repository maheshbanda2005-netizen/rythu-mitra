import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_service.dart';
import 'app_strings.dart';

class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static AppLocalizations of(BuildContext context) {
    final appState = Provider.of<AppStateService>(context, listen: false);
    return AppLocalizations(appState.currentLanguage);
  }

  String tr(String key) {
    return AppStrings.get(key, languageCode);
  }
}

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    try {
      final appState = watch<AppStateService>();
      return AppStrings.get(key, appState.currentLanguage);
    } catch (_) {
      try {
        final appState = read<AppStateService>();
        return AppStrings.get(key, appState.currentLanguage);
      } catch (_) {
        return AppStrings.get(key, 'te');
      }
    }
  }

  String trRead(String key) {
    try {
      final appState = read<AppStateService>();
      return AppStrings.get(key, appState.currentLanguage);
    } catch (_) {
      return AppStrings.get(key, 'te');
    }
  }
}
