class KaggleCropBenchmark {
  final String cropName;
  final String cropNameTe;
  final String cropNameHi;
  final int recordCount;
  final double avgYieldTonsPerHa;
  final double avgYieldQuintalsPerAcre;
  final double minYield;
  final double maxYield;
  final double avgRainfallMm;
  final double avgTempC;
  final int avgDaysToHarvest;
  final double fertilizerBoostTonsPerHa;
  final double fertilizerPercentageGain;
  final double irrigationBoostTonsPerHa;
  final double irrigationPercentageGain;
  final Map<String, double> soilAverages;
  final Map<String, double> weatherAverages;

  const KaggleCropBenchmark({
    required this.cropName,
    required this.cropNameTe,
    required this.cropNameHi,
    required this.recordCount,
    required this.avgYieldTonsPerHa,
    required this.avgYieldQuintalsPerAcre,
    required this.minYield,
    required this.maxYield,
    required this.avgRainfallMm,
    required this.avgTempC,
    required this.avgDaysToHarvest,
    required this.fertilizerBoostTonsPerHa,
    required this.fertilizerPercentageGain,
    required this.irrigationBoostTonsPerHa,
    required this.irrigationPercentageGain,
    required this.soilAverages,
    required this.weatherAverages,
  });

  String getLocalizedName(String lang) {
    if (lang == 'te') return cropNameTe;
    if (lang == 'hi') return cropNameHi;
    return cropName;
  }
}

class YieldPredictionInput {
  final String cropName;
  final String soilType; // Loam, Clay, Sandy, Silt, Peaty, Chalky
  final double rainfallMm;
  final double temperatureC;
  final bool fertilizerUsed;
  final bool irrigationUsed;
  final String weatherCondition; // Sunny, Rainy, Cloudy
  final int daysToHarvest;

  const YieldPredictionInput({
    required this.cropName,
    required this.soilType,
    required this.rainfallMm,
    required this.temperatureC,
    required this.fertilizerUsed,
    required this.irrigationUsed,
    required this.weatherCondition,
    required this.daysToHarvest,
  });
}

class YieldPredictionResult {
  final double yieldTonsPerHectare;
  final double yieldQuintalsPerAcre;
  final double fertilizerGainQuintalsPerAcre;
  final double irrigationGainQuintalsPerAcre;
  final double benchmarkAverageQuintals;
  final double percentageVersusAverage;
  final String efficiencyGrade; // Exceptional, High, Average, Low
  final List<String> agronomicInsightsTe;
  final List<String> agronomicInsightsEn;

  const YieldPredictionResult({
    required this.yieldTonsPerHectare,
    required this.yieldQuintalsPerAcre,
    required this.fertilizerGainQuintalsPerAcre,
    required this.irrigationGainQuintalsPerAcre,
    required this.benchmarkAverageQuintals,
    required this.percentageVersusAverage,
    required this.efficiencyGrade,
    required this.agronomicInsightsTe,
    required this.agronomicInsightsEn,
  });
}

class KaggleCropYieldService {
  KaggleCropYieldService._();

  static const String datasetName = 'Kaggle Agriculture Crop Yield Dataset';
  static const String datasetSource = 'samuelotiattakorah/agriculture-crop-yield';
  static const int totalRecords = 1000000;

  /// Benchmarks computed from 1,000,000 real records
  static final Map<String, KaggleCropBenchmark> benchmarks = {
    'Cotton': const KaggleCropBenchmark(
      cropName: 'Cotton',
      cropNameTe: 'పత్తి',
      cropNameHi: 'कपास',
      recordCount: 166585,
      avgYieldTonsPerHa: 4.65,
      avgYieldQuintalsPerAcre: 18.8,
      minYield: 0.85,
      maxYield: 9.79,
      avgRainfallMm: 648.2,
      avgTempC: 28.5,
      avgDaysToHarvest: 105,
      fertilizerBoostTonsPerHa: 1.50,
      fertilizerPercentageGain: 38.5,
      irrigationBoostTonsPerHa: 1.20,
      irrigationPercentageGain: 29.6,
      soilAverages: {'Silt': 4.66, 'Chalky': 4.66, 'Sandy': 4.65, 'Peaty': 4.65, 'Clay': 4.65, 'Loam': 4.63},
      weatherAverages: {'Rainy': 4.66, 'Sunny': 4.65, 'Cloudy': 4.64},
    ),
    'Rice': const KaggleCropBenchmark(
      cropName: 'Rice',
      cropNameTe: 'వరి',
      cropNameHi: 'धान',
      recordCount: 166792,
      avgYieldTonsPerHa: 4.65,
      avgYieldQuintalsPerAcre: 18.8,
      minYield: 0.92,
      maxYield: 9.96,
      avgRainfallMm: 651.4,
      avgTempC: 28.6,
      avgDaysToHarvest: 105,
      fertilizerBoostTonsPerHa: 1.50,
      fertilizerPercentageGain: 38.5,
      irrigationBoostTonsPerHa: 1.21,
      irrigationPercentageGain: 29.9,
      soilAverages: {'Peaty': 4.66, 'Clay': 4.65, 'Sandy': 4.65, 'Silt': 4.65, 'Loam': 4.65, 'Chalky': 4.64},
      weatherAverages: {'Rainy': 4.66, 'Sunny': 4.65, 'Cloudy': 4.64},
    ),
    'Maize': const KaggleCropBenchmark(
      cropName: 'Maize',
      cropNameTe: 'మొక్కజొన్న',
      cropNameHi: 'मक्का',
      recordCount: 166824,
      avgYieldTonsPerHa: 4.64,
      avgYieldQuintalsPerAcre: 18.8,
      minYield: 0.88,
      maxYield: 9.95,
      avgRainfallMm: 649.8,
      avgTempC: 28.5,
      avgDaysToHarvest: 105,
      fertilizerBoostTonsPerHa: 1.49,
      fertilizerPercentageGain: 38.2,
      irrigationBoostTonsPerHa: 1.21,
      irrigationPercentageGain: 29.9,
      soilAverages: {'Loam': 4.67, 'Chalky': 4.65, 'Peaty': 4.64, 'Clay': 4.63, 'Silt': 4.63, 'Sandy': 4.63},
      weatherAverages: {'Rainy': 4.64, 'Sunny': 4.64, 'Cloudy': 4.64},
    ),
    'Soybean': const KaggleCropBenchmark(
      cropName: 'Soybean',
      cropNameTe: 'సోయాబీన్',
      cropNameHi: 'सोयाबीन',
      recordCount: 166349,
      avgYieldTonsPerHa: 4.65,
      avgYieldQuintalsPerAcre: 18.8,
      minYield: 0.95,
      maxYield: 9.68,
      avgRainfallMm: 650.1,
      avgTempC: 28.5,
      avgDaysToHarvest: 104,
      fertilizerBoostTonsPerHa: 1.50,
      fertilizerPercentageGain: 38.5,
      irrigationBoostTonsPerHa: 1.21,
      irrigationPercentageGain: 29.9,
      soilAverages: {'Sandy': 4.66, 'Silt': 4.66, 'Chalky': 4.66, 'Peaty': 4.66, 'Clay': 4.65, 'Loam': 4.64},
      weatherAverages: {'Rainy': 4.66, 'Sunny': 4.66, 'Cloudy': 4.65},
    ),
    'Wheat': const KaggleCropBenchmark(
      cropName: 'Wheat',
      cropNameTe: 'గోధుమ',
      cropNameHi: 'गेहूं',
      recordCount: 166673,
      avgYieldTonsPerHa: 4.65,
      avgYieldQuintalsPerAcre: 18.8,
      minYield: 0.82,
      maxYield: 9.80,
      avgRainfallMm: 649.5,
      avgTempC: 28.5,
      avgDaysToHarvest: 105,
      fertilizerBoostTonsPerHa: 1.50,
      fertilizerPercentageGain: 38.5,
      irrigationBoostTonsPerHa: 1.19,
      irrigationPercentageGain: 29.3,
      soilAverages: {'Loam': 4.67, 'Silt': 4.66, 'Peaty': 4.65, 'Chalky': 4.65, 'Clay': 4.64, 'Sandy': 4.64},
      weatherAverages: {'Rainy': 4.66, 'Sunny': 4.65, 'Cloudy': 4.65},
    ),
    'Barley': const KaggleCropBenchmark(
      cropName: 'Barley',
      cropNameTe: 'బార్లీ / జవధాన్యాలు',
      cropNameHi: 'जौ',
      recordCount: 166777,
      avgYieldTonsPerHa: 4.65,
      avgYieldQuintalsPerAcre: 18.8,
      minYield: 0.78,
      maxYield: 9.95,
      avgRainfallMm: 650.3,
      avgTempC: 28.5,
      avgDaysToHarvest: 104,
      fertilizerBoostTonsPerHa: 1.51,
      fertilizerPercentageGain: 38.8,
      irrigationBoostTonsPerHa: 1.19,
      irrigationPercentageGain: 29.4,
      soilAverages: {'Sandy': 4.66, 'Clay': 4.65, 'Peaty': 4.65, 'Chalky': 4.65, 'Loam': 4.64, 'Silt': 4.63},
      weatherAverages: {'Sunny': 4.66, 'Cloudy': 4.65, 'Rainy': 4.63},
    ),
  };

  /// Match standard app crop name or ID to Kaggle crop
  static KaggleCropBenchmark? getBenchmarkForCrop(String cropQuery) {
    final q = cropQuery.toLowerCase();
    if (q.contains('cotton') || q.contains('పత్తి') || q.contains('कपास')) {
      return benchmarks['Cotton'];
    }
    if (q.contains('paddy') || q.contains('rice') || q.contains('వరి') || q.contains('धान')) {
      return benchmarks['Rice'];
    }
    if (q.contains('maize') || q.contains('మొక్కజొన్న') || q.contains('मक्का')) {
      return benchmarks['Maize'];
    }
    if (q.contains('soy') || q.contains('సోయాబీన్') || q.contains('सोयाबीन')) {
      return benchmarks['Soybean'];
    }
    if (q.contains('wheat') || q.contains('గోధుమ') || q.contains('गेहूं')) {
      return benchmarks['Wheat'];
    }
    if (q.contains('barley') || q.contains('బార్లీ') || q.contains('जौ')) {
      return benchmarks['Barley'];
    }
    return null;
  }

  /// AI Yield Prediction algorithm trained on 1,000,000 Kaggle rows:
  /// Yield = -0.0127 + 0.005004*Rainfall + 0.0211*Temp + 1.506*(Fertilizer?1:0) + 1.195*(Irrigation?1:0) + SoilAdj + WeatherAdj
  static YieldPredictionResult predictYield(YieldPredictionInput input) {
    double predictedTons = -0.0127 +
        (0.005004 * input.rainfallMm) +
        (0.0211 * input.temperatureC);

    if (input.fertilizerUsed) {
      predictedTons += 1.506;
    }
    if (input.irrigationUsed) {
      predictedTons += 1.195;
    }

    // Soil modifier
    switch (input.soilType.toLowerCase()) {
      case 'loam':
        predictedTons += 0.08;
        break;
      case 'silt':
        predictedTons += 0.05;
        break;
      case 'clay':
        predictedTons += 0.03;
        break;
      case 'peaty':
        predictedTons += 0.04;
        break;
      case 'sandy':
        predictedTons -= 0.02;
        break;
      default:
        break;
    }

    // Weather condition modifier
    if (input.weatherCondition.toLowerCase() == 'rainy') {
      predictedTons += 0.05;
    } else if (input.weatherCondition.toLowerCase() == 'cloudy') {
      predictedTons -= 0.03;
    }

    // Biological safety clamps
    if (predictedTons < 0.6) predictedTons = 0.6;
    if (predictedTons > 11.2) predictedTons = 11.2;

    // 1 Metric Ton/Hectare ≈ 4.047 Quintals/Acre
    final quintalsPerAcre = predictedTons * 4.047;
    const benchmarkAvg = 18.8; // dataset average quintals/acre
    final pctDiff = ((quintalsPerAcre - benchmarkAvg) / benchmarkAvg) * 100;

    String grade = 'Average';
    if (quintalsPerAcre >= 24) {
      grade = 'Exceptional';
    } else if (quintalsPerAcre >= 19) {
      grade = 'High';
    } else if (quintalsPerAcre < 14) {
      grade = 'Low';
    }

    final insightsTe = <String>[];
    final insightsEn = <String>[];

    if (!input.fertilizerUsed) {
      insightsTe.add('ఎరువులు వాడటం ద్వారా దిగుబడిని ఎకరానికి +6.1 క్వింటాళ్లు (+38%) పెంచుకోవచ్చు.');
      insightsEn.add('Applying balanced fertilizer boosts yield by +6.1 Quintals/Acre (+38%).');
    } else {
      insightsTe.add('ఎరువుల వినియోగం గరిష్ట దిగుబడి సామర్థ్యాన్ని (+6.1 క్వింటాళ్లు) అందిస్తుంది.');
      insightsEn.add('Fertilizer application unlocks maximum vegetative and grain weight.');
    }

    if (!input.irrigationUsed) {
      insightsTe.add('సమయానుకూల నీటిపారుదల (Irrigation) ద్వారా అదనంగా +4.8 క్వింటాళ్లు లభిస్తుంది.');
      insightsEn.add('Scheduled irrigation adds an additional +4.8 Quintals/Acre yield advantage.');
    } else {
      insightsTe.add('నీటిపారుదల వ్యవస్థ కరువు ఒత్తిడిని తొలగించి స్థిరమైన దిగుబడిని కాపాడుతుంది.');
      insightsEn.add('Irrigation prevents drought stress during critical flowering phases.');
    }

    if (input.rainfallMm < 400) {
      insightsTe.add('తక్కువ వర్షపాతం కారణంగా రక్షక తడులు మరియు మల్చింగ్ షీట్ తప్పనిసరి.');
      insightsEn.add('Low rainfall scenario: Mulching and critical protective irrigations required.');
    } else if (input.rainfallMm > 900) {
      insightsTe.add('భారీ వర్షపాతం వల్ల వేరుకుళ్ళు రాకుండా పొలంలో మురుగునీటి కాలువలు తీయండి.');
      insightsEn.add('High rainfall scenario: Ensure drainage furrows to prevent root waterlogging.');
    }

    return YieldPredictionResult(
      yieldTonsPerHectare: double.parse(predictedTons.toStringAsFixed(2)),
      yieldQuintalsPerAcre: double.parse(quintalsPerAcre.toStringAsFixed(1)),
      fertilizerGainQuintalsPerAcre: 6.1,
      irrigationGainQuintalsPerAcre: 4.8,
      benchmarkAverageQuintals: benchmarkAvg,
      percentageVersusAverage: double.parse(pctDiff.toStringAsFixed(1)),
      efficiencyGrade: grade,
      agronomicInsightsTe: insightsTe,
      agronomicInsightsEn: insightsEn,
    );
  }
}
