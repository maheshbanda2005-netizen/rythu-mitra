enum DiagnosisCategory {
  pest,
  fungalDisease,
  bacterialDisease,
  nutrientDeficiency,
  waterStress,
  healthy,
}

class DiagnosisReport {
  final String id;
  final String cropName;
  final String issueNameEn;
  final String issueNameTe;
  final String issueNameHi;
  final DiagnosisCategory category;
  final double confidenceScore; // 0.0 to 1.0 (e.g., 0.94)
  final String confidenceLevel; // "Confirmed", "Likely", "Possible"
  final String symptomsEn;
  final String symptomsTe;
  final String causesEn;
  final String causesTe;
  final String chemicalManagementEn;
  final String chemicalManagementTe;
  final String organicManagementEn;
  final String organicManagementTe;
  final String preventionEn;
  final String preventionTe;
  final bool isNutrientDeficiencySuspected;
  final String? suspectedNutrient;
  final String sampleImageUri;

  const DiagnosisReport({
    required this.id,
    required this.cropName,
    required this.issueNameEn,
    required this.issueNameTe,
    required this.issueNameHi,
    required this.category,
    required this.confidenceScore,
    required this.confidenceLevel,
    required this.symptomsEn,
    required this.symptomsTe,
    required this.causesEn,
    required this.causesTe,
    required this.chemicalManagementEn,
    required this.chemicalManagementTe,
    required this.organicManagementEn,
    required this.organicManagementTe,
    required this.preventionEn,
    required this.preventionTe,
    required this.isNutrientDeficiencySuspected,
    this.suspectedNutrient,
    required this.sampleImageUri,
  });

  String getLocalizedIssue(String lang) {
    if (lang == 'te') return issueNameTe;
    if (lang == 'hi') return issueNameHi;
    return issueNameEn;
  }

  String getLocalizedSymptoms(String lang) {
    if (lang == 'te') return symptomsTe;
    return symptomsEn;
  }

  String getLocalizedChemical(String lang) {
    if (lang == 'te') return chemicalManagementTe;
    return chemicalManagementEn;
  }

  String getLocalizedOrganic(String lang) {
    if (lang == 'te') return organicManagementTe;
    return organicManagementEn;
  }

  String getLocalizedPrevention(String lang) {
    if (lang == 'te') return preventionTe;
    return preventionEn;
  }

  String getLocalizedCauses(String lang) {
    if (lang == 'te') return causesTe;
    return causesEn;
  }
}
