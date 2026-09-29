import 'package:flutter/material.dart';

class PriceHistoryPoint {
  final int day;
  final double price;
  final String dateLabel;

  const PriceHistoryPoint({
    required this.day,
    required this.price,
    required this.dateLabel,
  });
}

class MarketPriceModel {
  final String id;
  final String cropNameEn;
  final String cropNameTe;
  final String cropNameHi;
  final String iconEmoji;
  final String mandiName;
  final String? mandiNameTe;
  final String? mandiNameHi;
  final String state;
  final double distanceKm;
  final bool isGovtMandi;
  final double minPrice;
  final double maxPrice;
  final double modalPrice; // Average/most traded
  final double privateRate;
  final double priceChange; // Positive or negative
  final String lastUpdated;
  final List<PriceHistoryPoint> history;

  const MarketPriceModel({
    required this.id,
    required this.cropNameEn,
    required this.cropNameTe,
    required this.cropNameHi,
    required this.iconEmoji,
    required this.mandiName,
    this.mandiNameTe,
    this.mandiNameHi,
    required this.state,
    required this.distanceKm,
    required this.isGovtMandi,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    required this.privateRate,
    required this.priceChange,
    required this.lastUpdated,
    required this.history,
  });

  String getLocalizedCrop(String lang) {
    if (lang == 'te') return cropNameTe;
    if (lang == 'hi') return cropNameHi;
    return cropNameEn;
  }

  String getLocalizedMandi(String lang) {
    if (lang == 'te') return mandiNameTe ?? mandiName;
    if (lang == 'hi') return mandiNameHi ?? mandiName;
    return mandiName;
  }

  IconData get icon {
    final lower = cropNameEn.toLowerCase();
    if (lower.contains('cotton')) return Icons.spa_rounded;
    if (lower.contains('paddy') || lower.contains('rice')) return Icons.grass_rounded;
    if (lower.contains('chilli')) return Icons.local_fire_department_rounded;
    if (lower.contains('maize') || lower.contains('corn')) return Icons.grain_rounded;
    if (lower.contains('tomato')) return Icons.circle_rounded;
    if (lower.contains('turmeric')) return Icons.eco_rounded;
    if (lower.contains('red gram') || lower.contains('gram') || lower.contains('dal')) return Icons.grain_rounded;
    if (lower.contains('soybean') || lower.contains('groundnut')) return Icons.eco_rounded;
    return Icons.agriculture_rounded;
  }
}
