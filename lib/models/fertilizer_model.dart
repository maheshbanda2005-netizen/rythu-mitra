class FertilizerRecommendation {
  final String nutrientNameEn;
  final String nutrientNameTe;
  final String? nutrientNameHi;
  final String nutrientSymbol; // N, P, K, Zn, Fe, S, B, Mg
  final String dosagePerAcre;
  final String? dosagePerAcreTe;
  final String? dosagePerAcreHi;
  final String commercialFertilizer; // e.g., Urea, DAP, MOP, Zinc Sulfate
  final String? commercialFertilizerTe;
  final String? commercialFertilizerHi;
  final String applicationTiming;
  final String? applicationTimingTe;
  final String? applicationTimingHi;
  final String applicationMethod;
  final String? applicationMethodTe;
  final String? applicationMethodHi;
  final String deficiencySymptoms;
  final String? deficiencySymptomsTe;
  final String? deficiencySymptomsHi;
  final String precautions;
  final String? precautionsTe;
  final String? precautionsHi;
  final String organicAlternative;
  final String? organicAlternativeTe;
  final String? organicAlternativeHi;

  const FertilizerRecommendation({
    required this.nutrientNameEn,
    required this.nutrientNameTe,
    this.nutrientNameHi,
    required this.nutrientSymbol,
    required this.dosagePerAcre,
    this.dosagePerAcreTe,
    this.dosagePerAcreHi,
    required this.commercialFertilizer,
    this.commercialFertilizerTe,
    this.commercialFertilizerHi,
    required this.applicationTiming,
    this.applicationTimingTe,
    this.applicationTimingHi,
    required this.applicationMethod,
    this.applicationMethodTe,
    this.applicationMethodHi,
    required this.deficiencySymptoms,
    this.deficiencySymptomsTe,
    this.deficiencySymptomsHi,
    required this.precautions,
    this.precautionsTe,
    this.precautionsHi,
    required this.organicAlternative,
    this.organicAlternativeTe,
    this.organicAlternativeHi,
  });

  String getLocalizedNutrient(String lang) {
    if (lang == 'te') return nutrientNameTe;
    if (lang == 'hi') return nutrientNameHi ?? nutrientNameEn;
    return nutrientNameEn;
  }

  String getDosage(String lang) {
    if (lang == 'te') return dosagePerAcreTe ?? dosagePerAcre;
    if (lang == 'hi') return dosagePerAcreHi ?? dosagePerAcre;
    return dosagePerAcre;
  }

  String getCommercialFertilizer(String lang) {
    if (lang == 'te') return commercialFertilizerTe ?? commercialFertilizer;
    if (lang == 'hi') return commercialFertilizerHi ?? commercialFertilizer;
    return commercialFertilizer;
  }

  String getApplicationTiming(String lang) {
    if (lang == 'te') return applicationTimingTe ?? applicationTiming;
    if (lang == 'hi') return applicationTimingHi ?? applicationTiming;
    return applicationTiming;
  }

  String getApplicationMethod(String lang) {
    if (lang == 'te') return applicationMethodTe ?? applicationMethod;
    if (lang == 'hi') return applicationMethodHi ?? applicationMethod;
    return applicationMethod;
  }

  String getDeficiencySymptoms(String lang) {
    if (lang == 'te') return deficiencySymptomsTe ?? deficiencySymptoms;
    if (lang == 'hi') return deficiencySymptomsHi ?? deficiencySymptoms;
    return deficiencySymptoms;
  }

  String getPrecautions(String lang) {
    if (lang == 'te') return precautionsTe ?? precautions;
    if (lang == 'hi') return precautionsHi ?? precautions;
    return precautions;
  }

  String getOrganicAlternative(String lang) {
    if (lang == 'te') return organicAlternativeTe ?? organicAlternative;
    if (lang == 'hi') return organicAlternativeHi ?? organicAlternative;
    return organicAlternative;
  }
}
