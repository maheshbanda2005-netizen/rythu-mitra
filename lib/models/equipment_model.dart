import 'package:flutter/material.dart';

class EquipmentRentalItem {
  final String id;
  final String title;
  final String? titleTe;
  final String? titleHi;
  final String category; // Tractor, Sprayer, Harvester, Drone, Tiller
  final String ownerName;
  final String? ownerNameTe;
  final String? ownerNameHi;
  final String phone;
  final String location;
  final String? locationTe;
  final String? locationHi;
  final double distanceKm;
  final double ratePerHour;
  final double ratePerDay;
  final bool isAvailable;
  final double rating;
  final String iconEmoji;

  const EquipmentRentalItem({
    required this.id,
    required this.title,
    this.titleTe,
    this.titleHi,
    required this.category,
    required this.ownerName,
    this.ownerNameTe,
    this.ownerNameHi,
    required this.phone,
    required this.location,
    this.locationTe,
    this.locationHi,
    required this.distanceKm,
    required this.ratePerHour,
    required this.ratePerDay,
    required this.isAvailable,
    required this.rating,
    required this.iconEmoji,
  });

  String getLocalizedTitle(String lang) {
    if (lang == 'te') return titleTe ?? title;
    if (lang == 'hi') return titleHi ?? title;
    return title;
  }

  String getLocalizedOwner(String lang) {
    if (lang == 'te') return ownerNameTe ?? ownerName;
    if (lang == 'hi') return ownerNameHi ?? ownerName;
    return ownerName;
  }

  String getLocalizedLocation(String lang) {
    if (lang == 'te') return locationTe ?? location;
    if (lang == 'hi') return locationHi ?? location;
    return location;
  }

  IconData get icon {
    switch (category.toLowerCase()) {
      case 'tractor':
        return Icons.agriculture_rounded;
      case 'drone':
        return Icons.flight_rounded;
      case 'harvester':
        return Icons.precision_manufacturing_rounded;
      case 'sprayer':
        return Icons.shower_rounded;
      case 'tiller':
        return Icons.hardware_rounded;
      default:
        return Icons.agriculture_rounded;
    }
  }
}
