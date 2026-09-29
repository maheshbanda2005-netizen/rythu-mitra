class GovtSchemeModel {
  final String id;
  final String nameEn;
  final String nameTe;
  final String nameHi;
  final String departmentEn;
  final String departmentTe;
  final String departmentHi;
  final String level; // 'State' or 'Central'
  final String state; // 'Telangana' or 'All India'
  final String categoryKey; // financial, crop, soil, machinery, irrigation, insurance, loan, organic, dairy, women
  final String badgeTextEn;
  final String badgeTextTe;
  final String badgeTextHi;
  final String benefitEn;
  final String benefitTe;
  final String benefitHi;
  final List<String> eligibilityEn;
  final List<String> eligibilityTe;
  final List<String> eligibilityHi;
  final List<String> requiredDocumentsEn;
  final List<String> requiredDocumentsTe;
  final List<String> requiredDocumentsHi;
  final List<String> applicationStepsEn;
  final List<String> applicationStepsTe;
  final List<String> applicationStepsHi;
  final String officialPortalUrl;
  final String helplineNumber;
  final String lastVerifiedDate;
  final int? deadlineDays; // null if continuous
  final String? subsidyPercent;
  final List<String> applicableCrops;

  const GovtSchemeModel({
    required this.id,
    required this.nameEn,
    required this.nameTe,
    required this.nameHi,
    required this.departmentEn,
    required this.departmentTe,
    required this.departmentHi,
    required this.level,
    required this.state,
    required this.categoryKey,
    required this.badgeTextEn,
    required this.badgeTextTe,
    required this.badgeTextHi,
    required this.benefitEn,
    required this.benefitTe,
    required this.benefitHi,
    required this.eligibilityEn,
    required this.eligibilityTe,
    required this.eligibilityHi,
    required this.requiredDocumentsEn,
    required this.requiredDocumentsTe,
    required this.requiredDocumentsHi,
    required this.applicationStepsEn,
    required this.applicationStepsTe,
    required this.applicationStepsHi,
    required this.officialPortalUrl,
    required this.helplineNumber,
    required this.lastVerifiedDate,
    this.deadlineDays,
    this.subsidyPercent,
    this.applicableCrops = const ['All'],
  });

  String getLocalizedName(String lang) {
    if (lang == 'te') return nameTe;
    if (lang == 'hi') return nameHi;
    return nameEn;
  }

  String getLocalizedDepartment(String lang) {
    if (lang == 'te') return departmentTe;
    if (lang == 'hi') return departmentHi;
    return departmentEn;
  }

  String getLocalizedBadge(String lang) {
    if (lang == 'te') return badgeTextTe;
    if (lang == 'hi') return badgeTextHi;
    return badgeTextEn;
  }

  String getLocalizedBenefits(String lang) {
    if (lang == 'te') return benefitTe;
    if (lang == 'hi') return benefitHi;
    return benefitEn;
  }

  List<String> getLocalizedEligibility(String lang) {
    if (lang == 'te') return eligibilityTe;
    if (lang == 'hi') return eligibilityHi;
    return eligibilityEn;
  }

  List<String> getLocalizedDocuments(String lang) {
    if (lang == 'te') return requiredDocumentsTe;
    if (lang == 'hi') return requiredDocumentsHi;
    return requiredDocumentsEn;
  }

  List<String> getLocalizedSteps(String lang) {
    if (lang == 'te') return applicationStepsTe;
    if (lang == 'hi') return applicationStepsHi;
    return applicationStepsEn;
  }

  String getLocalizedCategory(String lang) {
    switch (categoryKey) {
      case 'financial':
        return lang == 'te' ? 'ఆర్థిక సాయం' : (lang == 'hi' ? 'वित्तीय सहायता' : 'Financial Aid');
      case 'crop':
        return lang == 'te' ? 'పంట మద్దతు' : (lang == 'hi' ? 'फसल सहायता' : 'Crop Support');
      case 'soil':
        return lang == 'te' ? 'నేల & ఎరువులు' : (lang == 'hi' ? 'मृदा एवं उर्वरक' : 'Soil & Fertilizer');
      case 'machinery':
        return lang == 'te' ? 'యంత్రాల సబ్సిడీ' : (lang == 'hi' ? 'कृषि यंत्र सब्सिडी' : 'Machinery Subsidy');
      case 'irrigation':
        return lang == 'te' ? 'సాగునీరు & డ్రిప్' : (lang == 'hi' ? 'सिंचाई एवं ड्रिप' : 'Irrigation');
      case 'insurance':
        return lang == 'te' ? 'పంట బీమా' : (lang == 'hi' ? 'फसल बीमा' : 'Crop Insurance');
      case 'loan':
        return lang == 'te' ? 'వ్యవసాయ రుణాలు' : (lang == 'hi' ? 'कृषि ऋण' : 'Agri Loans');
      case 'organic':
        return lang == 'te' ? 'సేంద్రియ వ్యవసాయం' : (lang == 'hi' ? 'जैविक खेती' : 'Organic Farming');
      case 'dairy':
        return lang == 'te' ? 'పాడి & పశుసంవర్ధక' : (lang == 'hi' ? 'डेयरी व पशुपालन' : 'Dairy & Livestock');
      case 'women':
        return lang == 'te' ? 'మహిళా రైతులు' : (lang == 'hi' ? 'महिला किसान' : 'Women Farmers');
      default:
        return categoryKey;
    }
  }
}
