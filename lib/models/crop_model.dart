import 'package:flutter/material.dart';

class CropModel {
  final String id;
  final String nameEn;
  final String nameTe;
  final String nameHi;
  final String category; // Kharif, Rabi, Summer, Commercial, Vegetable
  final String duration; // e.g. "120–150 days"
  final String soilTypeEn;
  final String soilTypeTe;
  final String waterRequirement; // High, Moderate, Low
  final String expectedYield;
  final String expectedCost;
  final String iconEmoji;
  final IconData? iconData;
  final String colorHex;
  final String imageUrl; // Real suitable agricultural photo URL
  final String audioExplanationTe; // Simplified audio explanation for uneducated farmers
  final List<String> dosList; // What to do (ఏమి చేయాలి)
  final List<String> dontsList; // What NOT to do (ఏమి చేయకూడదు)
  final String overview;
  final String? overviewTe;
  final String? overviewHi;
  final String landPrep;
  final String? landPrepTe;
  final String? landPrepHi;
  final String sowingMethod;
  final String? sowingMethodTe;
  final String? sowingMethodHi;
  final String fertilizerSchedule;
  final String? fertilizerScheduleTe;
  final String? fertilizerScheduleHi;
  final String irrigationGuide;
  final String? irrigationGuideTe;
  final String? irrigationGuideHi;
  final String pestDiseaseGuide;
  final String? pestDiseaseGuideTe;
  final String? pestDiseaseGuideHi;
  final String harvestingStorage;
  final String? harvestingStorageTe;
  final String? harvestingStorageHi;
  final List<String>? dosListEn;
  final List<String>? dosListHi;
  final List<String>? dontsListEn;
  final List<String>? dontsListHi;

  const CropModel({
    required this.id,
    required this.nameEn,
    required this.nameTe,
    required this.nameHi,
    required this.category,
    required this.duration,
    required this.soilTypeEn,
    required this.soilTypeTe,
    required this.waterRequirement,
    required this.expectedYield,
    required this.expectedCost,
    required this.iconEmoji,
    this.iconData,
    required this.colorHex,
    required this.imageUrl,
    required this.audioExplanationTe,
    required this.dosList,
    required this.dontsList,
    this.dosListEn,
    this.dosListHi,
    this.dontsListEn,
    this.dontsListHi,
    required this.overview,
    this.overviewTe,
    this.overviewHi,
    required this.landPrep,
    this.landPrepTe,
    this.landPrepHi,
    required this.sowingMethod,
    this.sowingMethodTe,
    this.sowingMethodHi,
    required this.fertilizerSchedule,
    this.fertilizerScheduleTe,
    this.fertilizerScheduleHi,
    required this.irrigationGuide,
    this.irrigationGuideTe,
    this.irrigationGuideHi,
    required this.pestDiseaseGuide,
    this.pestDiseaseGuideTe,
    this.pestDiseaseGuideHi,
    required this.harvestingStorage,
    this.harvestingStorageTe,
    this.harvestingStorageHi,
  });

  String getLocalizedOverview(String lang) {
    if (lang == 'te') return overviewTe ?? overview;
    if (lang == 'hi') return overviewHi ?? overview;
    return overview;
  }

  String getLocalizedLandPrep(String lang) {
    if (lang == 'te') return landPrepTe ?? landPrep;
    if (lang == 'hi') return landPrepHi ?? landPrep;
    return landPrep;
  }

  String getLocalizedSowing(String lang) {
    if (lang == 'te') return sowingMethodTe ?? sowingMethod;
    if (lang == 'hi') return sowingMethodHi ?? sowingMethod;
    return sowingMethod;
  }

  String getLocalizedFertilizer(String lang) {
    if (lang == 'te') return fertilizerScheduleTe ?? fertilizerSchedule;
    if (lang == 'hi') return fertilizerScheduleHi ?? fertilizerSchedule;
    return fertilizerSchedule;
  }

  String getLocalizedIrrigation(String lang) {
    if (lang == 'te') return irrigationGuideTe ?? irrigationGuide;
    if (lang == 'hi') return irrigationGuideHi ?? irrigationGuide;
    return irrigationGuide;
  }

  String getLocalizedPest(String lang) {
    if (lang == 'te') return pestDiseaseGuideTe ?? pestDiseaseGuide;
    if (lang == 'hi') return pestDiseaseGuideHi ?? pestDiseaseGuide;
    return pestDiseaseGuide;
  }

  String getLocalizedHarvest(String lang) {
    if (lang == 'te') return harvestingStorageTe ?? harvestingStorage;
    if (lang == 'hi') return harvestingStorageHi ?? harvestingStorage;
    return harvestingStorage;
  }

  List<String> getLocalizedDos(String lang) {
    if (lang == 'te') return dosList;
    if (lang == 'hi') return dosListHi ?? dosListEn ?? dosList;
    return dosListEn ?? dosList;
  }

  List<String> getLocalizedDonts(String lang) {
    if (lang == 'te') return dontsList;
    if (lang == 'hi') return dontsListHi ?? dontsListEn ?? dontsList;
    return dontsListEn ?? dontsList;
  }

  String getLocalizedName(String lang) {
    if (lang == 'te') return nameTe;
    if (lang == 'hi') return nameHi;
    return nameEn;
  }

  String getLocalizedSoil(String lang) {
    if (lang == 'te') return soilTypeTe;
    if (lang == 'hi') return soilTypeEn; // fallback or hindi soil
    return soilTypeEn;
  }

  String getLocalizedCategory(String lang) {
    switch (category.toLowerCase()) {
      case 'kharif':
        return lang == 'te' ? 'ఖరీఫ్' : (lang == 'hi' ? 'खरीफ' : 'Kharif');
      case 'rabi':
        return lang == 'te' ? 'రబీ' : (lang == 'hi' ? 'रबी' : 'Rabi');
      case 'commercial':
        return lang == 'te' ? 'వాణిజ్య పంట' : (lang == 'hi' ? 'व्यावसायिक' : 'Commercial');
      case 'summer':
        return lang == 'te' ? 'వేసవి' : (lang == 'hi' ? 'ग्रीष्म' : 'Summer');
      case 'vegetables':
      case 'vegetable':
        return lang == 'te' ? 'కూరగాయలు' : (lang == 'hi' ? 'सब्जियां' : 'Vegetables');
      default:
        return category;
    }
  }

  String getLocalizedDuration(String lang) {
    if (lang == 'te') {
      return duration.replaceAll('days', 'రోజులు').replaceAll('Days', 'రోజులు');
    }
    if (lang == 'hi') {
      return duration.replaceAll('days', 'दिन').replaceAll('Days', 'दिन');
    }
    return duration.replaceAll('రోజులు', 'days');
  }

  String getLocalizedWater(String lang) {
    final lower = waterRequirement.toLowerCase();
    if (lower.contains('high') || lower.contains('అధిక')) {
      return lang == 'te' ? 'అధిక నీరు' : (lang == 'hi' ? 'अधिक' : 'High');
    }
    if (lower.contains('low') || lower.contains('తక్కువ')) {
      return lang == 'te' ? 'తక్కువ నీరు' : (lang == 'hi' ? 'कम' : 'Low');
    }
    return lang == 'te' ? 'మధ్యస్థ నీరు' : (lang == 'hi' ? 'मध्यम' : 'Moderate');
  }

  String getLocalizedYield(String lang) {
    if (lang == 'te') {
      return expectedYield
          .replaceAll('Quintals / Acre', 'క్వింటాళ్లు / ఎకరా')
          .replaceAll('quintals/acre', 'క్వింటాళ్లు / ఎకరా')
          .replaceAll('Tons / Acre', 'టన్నులు / ఎకరా')
          .replaceAll('Bags / Acre', 'బస్తాలు / ఎకరా');
    }
    if (lang == 'hi') {
      return expectedYield
          .replaceAll('Quintals / Acre', 'क्विंटल / एकड़')
          .replaceAll('క్వింటాళ్లు / ఎకరా', 'क्विंटल / एकड़');
    }
    return expectedYield
        .replaceAll('క్వింటాళ్లు / ఎకరా', 'Quintals / Acre')
        .replaceAll('టన్నులు / ఎకరా', 'Tons / Acre');
  }

  String getLocalizedCost(String lang) {
    if (lang == 'te') {
      return expectedCost
          .replaceAll('/ Acre', '/ ఎకరా')
          .replaceAll('/ acre', '/ ఎకరా');
    }
    if (lang == 'hi') {
      return expectedCost
          .replaceAll('/ Acre', '/ एकड़')
          .replaceAll('/ ఎకరా', '/ एकड़');
    }
    return expectedCost.replaceAll('/ ఎకరా', '/ Acre');
  }

  IconData get icon {
    if (iconData != null) return iconData!;
    switch (id) {
      case 'c_cotton':
        return Icons.spa_rounded;
      case 'c_paddy':
        return Icons.grass_rounded;
      case 'c_chilli':
        return Icons.local_fire_department_rounded;
      case 'c_maize':
        return Icons.grain_rounded;
      case 'c_redgram':
        return Icons.scatter_plot_rounded;
      case 'c_groundnut':
        return Icons.nature_rounded;
      case 'c_tomato':
        return Icons.circle_rounded;
      case 'c_turmeric':
        return Icons.flare_rounded;
      case 'c_soybean':
        return Icons.spa_outlined;
      case 'c_sugarcane':
        return Icons.view_week_rounded;
      case 'c_onion':
        return Icons.radio_button_checked_rounded;
      case 'c_mango':
        return Icons.park_rounded;
      default:
        return Icons.eco_rounded;
    }
  }
}
