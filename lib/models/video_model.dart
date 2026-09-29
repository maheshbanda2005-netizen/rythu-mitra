class AgriVideoModel {
  final String id;
  final String titleTe;
  final String titleEn;
  final String titleHi;
  final String category; // Cultivation, Fertilizer, Pest Control, Organic, Irrigation
  final String instructorName;
  final String instructorTitle;
  final String duration;
  final String viewsCount;
  final String thumbnailUrl;
  final String videoDescriptionTe;
  final String videoDescriptionEn;
  final String? videoDescriptionHi;
  final List<String> keyTakeawaysTe;
  final List<String>? keyTakeawaysEn;
  final List<String>? keyTakeawaysHi;
  final List<VideoChapter> chapters;
  final String? cropId;
  final String? youtubeUrl;
  final String? sourceOrg;

  const AgriVideoModel({
    required this.id,
    required this.titleTe,
    required this.titleEn,
    required this.titleHi,
    required this.category,
    required this.instructorName,
    required this.instructorTitle,
    required this.duration,
    required this.viewsCount,
    required this.thumbnailUrl,
    required this.videoDescriptionTe,
    required this.videoDescriptionEn,
    this.videoDescriptionHi,
    required this.keyTakeawaysTe,
    this.keyTakeawaysEn,
    this.keyTakeawaysHi,
    required this.chapters,
    this.cropId,
    this.youtubeUrl,
    this.sourceOrg,
  });

  String getEffectiveVideoUrl() {
    if (youtubeUrl != null && youtubeUrl!.isNotEmpty) {
      return youtubeUrl!;
    }
    return 'https://www.youtube.com/results?search_query=${Uri.encodeComponent('$titleTe $titleEn farming')}';
  }

  String getLocalizedTitle(String lang) {
    if (lang == 'te') return titleTe;
    if (lang == 'hi') return titleHi;
    return titleEn;
  }

  String getLocalizedDescription(String lang) {
    if (lang == 'te') return videoDescriptionTe;
    if (lang == 'hi') return videoDescriptionHi ?? videoDescriptionEn;
    return videoDescriptionEn;
  }

  List<String> getLocalizedTakeaways(String lang) {
    if (lang == 'te') return keyTakeawaysTe;
    if (lang == 'hi') return keyTakeawaysHi ?? keyTakeawaysEn ?? keyTakeawaysTe;
    return keyTakeawaysEn ?? keyTakeawaysTe;
  }

  String getLocalizedCategory(String lang) {
    switch (category.toLowerCase()) {
      case 'cultivation':
        return lang == 'te' ? 'సాగు పద్ధతులు' : (lang == 'hi' ? 'फसल उत्पादन' : 'Cultivation');
      case 'fertilizer':
        return lang == 'te' ? 'ఎరువుల యాజమాన్యం' : (lang == 'hi' ? 'उर्वरक प्रबंधन' : 'Fertilizer Management');
      case 'pest control':
        return lang == 'te' ? 'పురుగుల నివారణ' : (lang == 'hi' ? 'कीट नियंत्रण' : 'Pest Control');
      case 'organic':
        return lang == 'te' ? 'సేంద్రియ వ్యవసాయం' : (lang == 'hi' ? 'जैविक खेती' : 'Organic Farming');
      case 'machinery':
        return lang == 'te' ? 'వ్యవసాయ యంత్రాలు' : (lang == 'hi' ? 'कृषि मशीनरी' : 'Farm Machinery');
      case 'irrigation':
        return lang == 'te' ? 'నీటిపారుదల' : (lang == 'hi' ? 'सिंचाई' : 'Irrigation');
      default:
        return category;
    }
  }
}

class VideoChapter {
  final String timestamp;
  final String titleTe;
  final String titleEn;
  final String? titleHi;

  const VideoChapter({
    required this.timestamp,
    required this.titleTe,
    required this.titleEn,
    this.titleHi,
  });

  String getLocalizedTitle(String lang) {
    if (lang == 'te') return titleTe;
    if (lang == 'hi') return titleHi ?? titleEn;
    return titleEn;
  }
}
