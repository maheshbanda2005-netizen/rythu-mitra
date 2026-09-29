import 'package:flutter/material.dart';
import 'crop_model.dart';

class CropPortalModel {
  final String id;
  final String nameEn;
  final String nameTe;
  final String nameHi;
  final String badgeEn;
  final String badgeTe;
  final String descriptionEn;
  final String descriptionTe;
  final String descriptionHi;
  final IconData icon;
  final Color themeColor;
  final String Function(CropModel crop, String lang) urlBuilder;

  const CropPortalModel({
    required this.id,
    required this.nameEn,
    required this.nameTe,
    required this.nameHi,
    required this.badgeEn,
    required this.badgeTe,
    required this.descriptionEn,
    required this.descriptionTe,
    required this.descriptionHi,
    required this.icon,
    required this.themeColor,
    required this.urlBuilder,
  });

  String getLocalizedName(String lang) {
    if (lang == 'te') return nameTe;
    if (lang == 'hi') return nameHi;
    return nameEn;
  }

  String getLocalizedBadge(String lang) {
    if (lang == 'te') return badgeTe;
    return badgeEn;
  }

  String getLocalizedDescription(String lang) {
    if (lang == 'te') return descriptionTe;
    if (lang == 'hi') return descriptionHi;
    return descriptionEn;
  }

  String buildUrl(CropModel crop, String lang) => urlBuilder(crop, lang);

  /// Default predefined premier agricultural research and official portals
  static List<CropPortalModel> get defaultPortals => [
        CropPortalModel(
          id: 'icar',
          nameEn: 'ICAR Research Portal',
          nameTe: 'ICAR వ్యవసాయ పరిశోధన సంస్థ',
          nameHi: 'आईसीएआर कृषि अनुसंधान पोर्टल',
          badgeEn: 'National Research',
          badgeTe: 'కేంద్ర వ్యవసాయ పరిశోధన',
          descriptionEn: 'Scientific cultivation package, disease diagnosis, and seed varieties.',
          descriptionTe: 'శాస్త్రీయ సాగు విధానం, తెగుళ్ల నివారణ & అధికారిక వంగడాల పరిశోధన సమాచారం.',
          descriptionHi: 'वैज्ञानिक खेती पैकेज, रोग प्रबंधन एवं उन्नत बीज किस्में।',
          icon: Icons.biotech_rounded,
          themeColor: const Color(0xFF0284C7),
          urlBuilder: (crop, lang) =>
              'https://www.google.com/search?q=site:icar.org.in+${Uri.encodeComponent('${crop.nameEn} cultivation package of practices')} OR site:icar-crida.res.in+${Uri.encodeComponent(crop.nameEn)}',
        ),
        CropPortalModel(
          id: 'pjtsau',
          nameEn: 'PJTSAU Agri University',
          nameTe: 'ఆచార్య జయశంకర్ వ్యవసాయ వర్సిటీ',
          nameHi: 'राज्य कृषि विश्वविद्यालय',
          badgeEn: 'State University',
          badgeTe: 'వ్యవసాయ విశ్వవిద్యాలయం',
          descriptionEn: 'Telangana & AP regional agronomy guide (Vyavasaya Darshini).',
          descriptionTe: 'వ్యవసాయ దర్శిని - మన తెలుగు రాష్ట్రాల వాతావరణానికి అనువైన సమగ్ర సాగు సూచనలు.',
          descriptionHi: 'क्षेत्रीय जलवायु अनुकूल सस्य क्रियाएं एवं विश्वविद्यालय संस्तुतियां।',
          icon: Icons.school_rounded,
          themeColor: const Color(0xFF16A34A),
          urlBuilder: (crop, lang) =>
              'https://www.google.com/search?q=site:pjtsau.edu.in+${Uri.encodeComponent('${crop.nameEn} vyavasaya darshini')} OR site:angrau.ac.in+${Uri.encodeComponent(crop.nameEn)}',
        ),
        CropPortalModel(
          id: 'vikaspedia',
          nameEn: 'Vikaspedia Agri Portal',
          nameTe: 'వికాస్‌పీడియా వ్యవసాయ దర్శిని',
          nameHi: 'विकासपीडिया कृषि ज्ञान',
          badgeEn: 'Govt Knowledge Hub',
          badgeTe: 'ప్రభుత్వ సమాచార భాండాగారం',
          descriptionEn: 'Step-by-step crop handbook in pure Telugu, Hindi, and English.',
          descriptionTe: 'విత్తనం నాటిన దగ్గర నుండి కోత వరకు సమగ్ర తెలుగు సాగు గైడ్ & జాగ్రత్తలు.',
          descriptionHi: 'बुवाई से लेकर कटाई तक शुद्ध स्थानीय भाषा में संपूर्ण फसल गाइड।',
          icon: Icons.menu_book_rounded,
          themeColor: const Color(0xFFD97706),
          urlBuilder: (crop, lang) {
            final query = lang == 'te'
                ? '${crop.nameTe} సాగు వికాస్‌పీడియా'
                : (lang == 'hi' ? '${crop.nameHi} की खेती विकासपीडिया' : '${crop.nameEn} cultivation vikaspedia');
            return 'https://www.google.com/search?q=${Uri.encodeComponent(query)}';
          },
        ),
        CropPortalModel(
          id: 'agmarknet',
          nameEn: 'e-NAM & Agmarknet Mandi',
          nameTe: 'మార్కెట్ యార్డ్ లైవ్ ధరలు (Agmarknet)',
          nameHi: 'ई-नाम एवं एगमार्कनेट मंडी भाव',
          badgeEn: 'Live Market Rates',
          badgeTe: 'మార్కెట్ ధరలు & రాబడులు',
          descriptionEn: 'Daily arrivals, minimum, maximum, and modal wholesale prices in nearby APMCs.',
          descriptionTe: 'సమీప వ్యవసాయ మార్కెట్ యార్డుల్లో నేటి కనిష్ట, గరిష్ట మరియు సగటు క్వింటాల్ ధరలు.',
          descriptionHi: 'दैनिक आवक, न्यूनतम, अधिकतम और मॉडल थोक मंडी भाव।',
          icon: Icons.analytics_rounded,
          themeColor: const Color(0xFF7C3AED),
          urlBuilder: (crop, lang) =>
              'https://agmarknet.gov.in/SearchCmmMkt.aspx?Tx_Commodity=${Uri.encodeComponent(crop.nameEn)}&Tx_State=Telangana',
        ),
        CropPortalModel(
          id: 'kisan_suvidha',
          nameEn: 'Kisan Suvidha & Farmer Portal',
          nameTe: 'కిసాన్ సువిధ ప్రభుత్వ పోర్టల్',
          nameHi: 'किसान सुविधा एवं किसान पोर्टल',
          badgeEn: 'Govt of India',
          badgeTe: 'భారత ప్రభుత్వ పోర్టల్',
          descriptionEn: 'Subsidies, crop insurance, certified seeds, and soil health card advisories.',
          descriptionTe: 'ప్రభుత్వ సబ్సిడీలు, పంటల బీమా పథకాలు, సర్టిఫైడ్ విత్తనాలు & మట్టి పరీక్ష సలహాలు.',
          descriptionHi: 'सरकारी अनुदान, फसल बीमा, प्रमाणित बीज एवं मृदा स्वास्थ्य सलाह।',
          icon: Icons.verified_user_rounded,
          themeColor: const Color(0xFF059669),
          urlBuilder: (crop, lang) =>
              'https://kisansuvidha.gov.in/',
        ),
        CropPortalModel(
          id: 'youtube_guides',
          nameEn: 'YouTube Agricultural Extension',
          nameTe: 'యూట్యూబ్ రైతు వీడియోలు (YouTube)',
          nameHi: 'यूट्यूब कृषि विशेषज्ञ वीडियो',
          badgeEn: 'Video Field Demos',
          badgeTe: 'రైతుల ప్రత్యక్ష అనుభవాలు',
          descriptionEn: 'Field demonstrations, successful farmer interviews, and machinery in action.',
          descriptionTe: 'ఆదర్శ రైతుల ప్రత్యక్ష అనుభవాలు, ఆధునిక యంత్రాల వినియోగం & శాస్త్రవేత్తల ప్రసంగాలు.',
          descriptionHi: 'खेत प्रदर्शन, प्रगतिशील किसान साक्षात्कार एवं लाइव वीडियो।',
          icon: Icons.video_collection_rounded,
          themeColor: const Color(0xFFDC2626),
          urlBuilder: (crop, lang) {
            final query = lang == 'te'
                ? '${crop.nameTe} సాగు పద్ధతులు rythu mitra farming'
                : (lang == 'hi' ? '${crop.nameHi} ki kheti kisan guide' : '${crop.nameEn} farming guide India ICAR');
            return 'https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}';
          },
        ),
      ];
}
