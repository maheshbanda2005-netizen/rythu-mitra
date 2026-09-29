import '../models/diagnosis_model.dart';

class AIDiagnosisService {
  AIDiagnosisService._();

  static final List<DiagnosisReport> sampleDiagnoses = [
    const DiagnosisReport(
      id: 'diag_cotton_curl',
      cropName: 'Cotton',
      issueNameEn: 'Cotton Leaf Curl & Sucking Pest Attack (Aphids/Jassids)',
      issueNameTe: 'పత్తి ఆకు ముడుత & రసం పీల్చే పురుగుల దాడి',
      issueNameHi: 'कपास पत्ती मरोड़ एवं रस चूसक कीट प्रकोप',
      category: DiagnosisCategory.pest,
      confidenceScore: 0.94,
      confidenceLevel: 'Likely',
      symptomsEn: 'Downward curling and crinkling of tender leaves, sticky honey-dew on leaf undersides, stunted internodes.',
      symptomsTe: 'లేత ఆకులు కిందికి ముడుచుకుపోవడం, ఆకుల వెనుక జిగురు పదార్థం, పెరుగుదల లోపించడం, పూత రాలిపోవడం.',
      causesEn: 'Heavy infestation of Jassids (Amrasca biguttula) and Whiteflies (Bemisia tabaci) transmitting leaf curl virus under humid dry conditions.',
      causesTe: 'వాతావరణంలో అధిక ఉష్ణోగ్రత మరియు తేమ ఉన్నప్పుడు పచ్చదోమ, తెల్లదోమ ఉధృతి వల్ల ఈ వైరస్ వ్యాపిస్తుంది.',
      chemicalManagementEn: 'Spray Flonicamid 50 WG @ 60g/acre or Acetamiprid 20 SP @ 40g/acre mixed with 200L water during morning or late afternoon.',
      chemicalManagementTe: 'ఎకరాకు 60 గ్రాముల ఫ్లోనికామిడ్ 50 WG లేదా 40 గ్రాముల ఎసిటామిప్రిడ్ 20 SP ను 200 లీటర్ల నీటిలో కలిపి పిచికారీ చేయండి.',
      organicManagementEn: 'Spray 5% Neem Seed Kernel Extract (NSKE) or Neem Oil (10,000 ppm) @ 2ml/liter. Erect yellow sticky traps (10 per acre).',
      organicManagementTe: 'ఎకరాకు 10 పసుపు రంగు జిగురు బోర్డులు ఏర్పాటు చేయండి. వేపనూనె (10,000 ppm) లీటరు నీటికి 2 మి.లీ కలిపి పిచికారీ చేయండి.',
      preventionEn: 'Avoid excessive application of chemical nitrogen (urea). Maintain balanced potash nutrition and destroy weed hosts around field bunds.',
      preventionTe: 'అధిక నత్రజని (యూరియా) వాడకాన్ని తగ్గించండి. గట్ల వెంబడి కలుపు మొక్కలను తొలగించండి.',
      isNutrientDeficiencySuspected: true,
      suspectedNutrient: 'Zinc (Zn) and Magnesium (Mg) stress observed in lower canopy',
      sampleImageUri: 'assets/images/diseases/cotton_curl.jpg',
    ),
    const DiagnosisReport(
      id: 'diag_paddy_blast',
      cropName: 'Paddy',
      issueNameEn: 'Rice Blast (Magnaporthe oryzae)',
      issueNameTe: 'వరి అగ్గితెగులు (మెడవిరుపు తెగులు)',
      issueNameHi: 'धान का झुलसा रोग (ब्लास्ट)',
      category: DiagnosisCategory.fungalDisease,
      confidenceScore: 0.96,
      confidenceLevel: 'Confirmed',
      symptomsEn: 'Spindle or eye-shaped lesions with brown borders and grey-whitish centers on leaf blades. Neck turns black in severe cases.',
      symptomsTe: 'ఆకులపై కంటి ఆకారంలో ఇరువైపులా మొనదేలిన గోధుమ రంగు అంచులు, మధ్యలో బూడిద రంగు మచ్చలు. తీవ్రత ఎక్కువైతే మెడవిరుపు వస్తుంది.',
      causesEn: 'Fungal pathogen favored by cloudy weather, intermittent drizzles, night temperatures below 20°C, and heavy nitrogen application.',
      causesTe: 'మబ్బులతో కూడిన వాతావరణం, మంచు కురవడం, అధిక నత్రజని వాడకం వల్ల ఈ శిలీంధ్రం వేగంగా వ్యాపిస్తుంది.',
      chemicalManagementEn: 'Spray Tricyclazole 75% WP @ 0.6g/liter (120g/acre) or Isoprothiolane 40% EC @ 1.5ml/liter with hollow cone nozzle.',
      chemicalManagementTe: 'లీటరు నీటికి 0.6 గ్రాముల ట్రైసైక్లాజోల్ 75% WP (ఎకరాకు 120 గ్రాములు) లేదా కాసుగామైసిన్ 2.5 మి.లీ కలిపి పిచికారీ చేయండి.',
      organicManagementEn: 'Foliar spray of Pseudomonas fluorescens @ 5g/liter or fermented butter-milk (pullati majjiga) diluted 1:10.',
      organicManagementTe: 'లీటరు నీటికి 5 గ్రాముల సూడోమోనాస్ ఫ్లోరోసెన్స్ కలిపి పిచికారీ చేయండి. పుల్లటి మజ్జిగ ద్రావణం సమర్థవంతంగా పనిచేస్తుంది.',
      preventionEn: 'Treat seed with Carbendazim 2g/kg seed before sowing. Avoid standing water drainage from infected fields into healthy fields.',
      preventionTe: 'విత్తన శుద్ధి తప్పనిసరిగా చేయండి. వ్యాధి సోకిన మడి నుండి నీరు ఇతర మడులలోకి పోకుండా చూడండి.',
      isNutrientDeficiencySuspected: false,
      sampleImageUri: 'assets/images/diseases/paddy_blast.jpg',
    ),
    const DiagnosisReport(
      id: 'diag_chilli_thrips',
      cropName: 'Chilli',
      issueNameEn: 'Chilli Black Thrips & Leaf Curl Mites',
      issueNameTe: 'మిరపలో నల్ల తామర పురుగులు & నల్లి',
      issueNameHi: 'मिर्च में थ्रिप्स एवं माइट्स प्रकोप',
      category: DiagnosisCategory.pest,
      confidenceScore: 0.91,
      confidenceLevel: 'Likely',
      symptomsEn: 'Upward boat-shaped curling of leaves, silvery shiny patches, bronzing on under-surface, flower shedding and scarred pods.',
      symptomsTe: 'ఆకులు పైకి దోనె ఆకారంలో ముడుచుకుపోవడం, వెనుక భాగంలో వెండి రంగు మెరుపు, ఆకులు పెళుసుగా మారడం, పూత విపరీతంగా రాలిపోవడం.',
      causesEn: 'Invasive black thrips (Thrips parvispinus) feeding on sap from flowers and leaves during dry spells.',
      causesTe: 'వేడి పొడి వాతావరణంలో నల్ల తామర పురుగుల సంఖ్య విపరీతంగా పెరిగి పూత మరియు లేత చిగుళ్ళను నాశనం చేస్తాయి.',
      chemicalManagementEn: 'Spray Spinetoram 11.7 SC @ 1ml/liter or Diafenthiuron 50 WP @ 1.25g/liter. Rotate chemicals to avoid resistance.',
      chemicalManagementTe: 'లీటరు నీటికి 1 మి.లీ స్పైనిటోరం 11.7 SC లేదా 1.25 గ్రాముల డయాఫెంతియురాన్ 50 WP కలిపి పిచికారీ చేయండి.',
      organicManagementEn: 'Install 25 Blue sticky traps per acre for thrips. Spray Agni-Astra or 5% Dashaparni kashayam weekly.',
      organicManagementTe: 'ఎకరాకు 25 నీలిరంగు జిగురు అట్టలు పెట్టండి. అగ్నిఅస్త్రం లేదా దశపర్ణి కషాయం పిచికారీ చేయండి.',
      preventionEn: 'Grow 2-3 border rows of maize or sorghum as wind-break and natural trap crop.',
      preventionTe: 'చేను చుట్టూ 2-3 వరుసల్లో జొన్న లేదా మొక్కజొన్నను సరిహద్దు పంటగా వేయండి.',
      isNutrientDeficiencySuspected: true,
      suspectedNutrient: 'Boron (B) deficiency indicated by brittle leaf veins and flower drop',
      sampleImageUri: 'assets/images/diseases/chilli_thrips.jpg',
    ),
    const DiagnosisReport(
      id: 'diag_tomato_blight',
      cropName: 'Tomato',
      issueNameEn: 'Early Blight (Alternaria solani)',
      issueNameTe: 'టమోటా ముందస్తు మాడు తెగులు',
      issueNameHi: 'टमाटर का अगेती झुलसा',
      category: DiagnosisCategory.fungalDisease,
      confidenceScore: 0.88,
      confidenceLevel: 'Likely',
      symptomsEn: 'Target-board or concentric ring spots on older leaves surrounded by yellow halo. Sunken dark spots on fruit stem end.',
      symptomsTe: 'కింది ఆకులపై వలయాకార (టార్గెట్ బోర్డ్) గోధుమ రంగు మచ్చలు, మచ్చల చుట్టూ పసుపు రంగు వలయం, కాయలపై నల్లటి మచ్చలు.',
      causesEn: 'Soil-borne fungal spores splashed by irrigation water or rain during warm, wet periods.',
      causesTe: 'భూమిలో ఉండే శిలీంధ్ర బీజాలు నీటి బిందువుల ద్వారా ఆకులపైకి చేరి వ్యాధిని కలుగజేస్తాయి.',
      chemicalManagementEn: 'Spray Mancozeb 75 WP @ 2.5g/liter or Chlorothalonil 75 WP @ 2g/liter at first appearance of spots.',
      chemicalManagementTe: 'లీటరు నీటికి 2.5 గ్రాముల మాంకోజెబ్ 75 WP లేదా అజాక్సిస్ట్రోబిన్ 1 మి.లీ కలిపి పిచికారీ చేయండి.',
      organicManagementEn: 'Copper hydroxide spray or Trichoderma viride enriched farmyard manure applied at root zone.',
      organicManagementTe: 'ట్రైకోడెర్మా విరిడే కల్చర్ ను పశువుల ఎరువుతో కలిపి మొదళ్ళ వద్ద వేయండి.',
      preventionEn: 'Mulch soil surface with straw or silver plastic film to prevent soil splash on lower foliage. Prune bottom leaves touching soil.',
      preventionTe: 'భూమిని తాకుతున్న కింది ఆకులను కత్తిరించి తీసివేయండి. మల్చింగ్ షీట్ ఉపయోగించండి.',
      isNutrientDeficiencySuspected: false,
      sampleImageUri: 'assets/images/diseases/tomato_blight.jpg',
    ),
  ];

  static Future<DiagnosisReport> analyzeCropImage(String cropHint) async {
    // Simulate AI inference time
    await Future.delayed(const Duration(milliseconds: 1400));
    final lower = cropHint.toLowerCase();
    if (lower.contains('paddy') || lower.contains('వరి') || lower.contains('rice')) {
      return sampleDiagnoses[1];
    } else if (lower.contains('chilli') || lower.contains('మిరప') || lower.contains('mirchi')) {
      return sampleDiagnoses[2];
    } else if (lower.contains('tomato') || lower.contains('టమోటా')) {
      return sampleDiagnoses[3];
    }
    return sampleDiagnoses[0]; // Cotton
  }
}
