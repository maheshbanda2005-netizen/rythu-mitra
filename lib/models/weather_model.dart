import 'package:flutter/material.dart';

class DailyForecast {
  final String dayName;
  final int tempMax;
  final int tempMin;
  final int rainChance;
  final String condition;
  final String iconEmoji;
  final IconData? iconData;

  const DailyForecast({
    required this.dayName,
    required this.tempMax,
    required this.tempMin,
    required this.rainChance,
    required this.condition,
    required this.iconEmoji,
    this.iconData,
  });

  IconData get icon {
    if (iconData != null) return iconData!;
    final cond = condition.toLowerCase();
    if (cond.contains('thunder') || cond.contains('తుఫాను')) return Icons.thunderstorm_rounded;
    if (cond.contains('rain') || cond.contains('వర్షం') || rainChance >= 50) return Icons.grain_rounded;
    if (cond.contains('cloud') || cond.contains('మేఘ')) return Icons.cloud_rounded;
    if (cond.contains('clear') || cond.contains('నిర్మలం')) return Icons.wb_sunny_rounded;
    if (cond.contains('sun') || cond.contains('ఎండ')) return Icons.wb_sunny_rounded;
    return Icons.wb_cloudy_rounded;
  }
}

class WeatherModel {
  final String location;
  final String? locationTe;
  final String? locationHi;
  final int currentTemp;
  final String condition;
  final String? conditionTe;
  final String? conditionHi;
  final String iconEmoji;
  final IconData? iconData;
  final int humidity;
  final int windSpeedKmH;
  final int rainProbability;
  final String advisoryEn;
  final String advisoryTe;
  final String advisoryHi;
  final List<DailyForecast> weeklyForecast;

  const WeatherModel({
    required this.location,
    this.locationTe,
    this.locationHi,
    required this.currentTemp,
    required this.condition,
    this.conditionTe,
    this.conditionHi,
    required this.iconEmoji,
    this.iconData,
    required this.humidity,
    required this.windSpeedKmH,
    required this.rainProbability,
    required this.advisoryEn,
    required this.advisoryTe,
    required this.advisoryHi,
    required this.weeklyForecast,
  });

  String getLocalizedLocation(String lang) {
    if (lang == 'te') return locationTe ?? location;
    if (lang == 'hi') return locationHi ?? location;
    return location;
  }

  String getLocalizedCondition(String lang) {
    if (lang == 'te') return conditionTe ?? condition;
    if (lang == 'hi') return conditionHi ?? condition;
    return condition;
  }

  IconData get icon {
    if (iconData != null) return iconData!;
    final cond = condition.toLowerCase();
    if (cond.contains('thunder')) return Icons.thunderstorm_rounded;
    if (cond.contains('rain') || cond.contains('వర్ష') || rainProbability >= 50) return Icons.grain_rounded;
    if (cond.contains('cloud') || cond.contains('మేఘ')) return Icons.cloud_rounded;
    if (cond.contains('clear') || cond.contains('sun')) return Icons.wb_sunny_rounded;
    return Icons.wb_cloudy_rounded;
  }

  String getLocalizedAdvisory(String lang) {
    if (lang == 'te') return advisoryTe;
    if (lang == 'hi') return advisoryHi;
    return advisoryEn;
  }
}
