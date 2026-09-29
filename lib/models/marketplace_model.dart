import 'package:flutter/material.dart';

class MarketProduct {
  final String id;
  final String title;
  final String? titleTe;
  final String? titleHi;
  final String category; // Seeds, Fertilizers, Organic, Tools, Irrigation
  final double price;
  final String unit; // per bag (50kg), per liter, per pack
  final String? unitTe;
  final String? unitHi;
  final String sellerName;
  final String? sellerNameTe;
  final String? sellerNameHi;
  final String location;
  final String? locationTe;
  final String? locationHi;
  final double rating;
  final int reviewsCount;
  final bool isVerified;
  final String phone;
  final String iconEmoji;

  const MarketProduct({
    required this.id,
    required this.title,
    this.titleTe,
    this.titleHi,
    required this.category,
    required this.price,
    required this.unit,
    this.unitTe,
    this.unitHi,
    required this.sellerName,
    this.sellerNameTe,
    this.sellerNameHi,
    required this.location,
    this.locationTe,
    this.locationHi,
    required this.rating,
    required this.reviewsCount,
    required this.isVerified,
    required this.phone,
    required this.iconEmoji,
  });

  String getLocalizedTitle(String lang) {
    if (lang == 'te') return titleTe ?? title;
    if (lang == 'hi') return titleHi ?? title;
    return title;
  }

  String getLocalizedSeller(String lang) {
    if (lang == 'te') return sellerNameTe ?? sellerName;
    if (lang == 'hi') return sellerNameHi ?? sellerName;
    return sellerName;
  }

  String getLocalizedUnit(String lang) {
    if (lang == 'te') return unitTe ?? unit;
    if (lang == 'hi') return unitHi ?? unit;
    return unit;
  }

  String getLocalizedLocation(String lang) {
    if (lang == 'te') return locationTe ?? location;
    if (lang == 'hi') return locationHi ?? location;
    return location;
  }

  IconData get icon {
    switch (category.toLowerCase()) {
      case 'seeds':
        return Icons.spa_rounded;
      case 'fertilizers':
        return Icons.science_rounded;
      case 'organic':
        return Icons.eco_rounded;
      case 'tools':
        return Icons.construction_rounded;
      case 'irrigation':
        return Icons.water_drop_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }
}
