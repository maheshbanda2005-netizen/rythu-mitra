import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../localization/app_localizations.dart';
import '../../services/app_state_service.dart';
import '../../services/agri_data_service.dart';
import '../../screens/crops/crop_detail_screen.dart';
import '../../screens/voice/voice_assistant_screen.dart';

class SearchHeader extends StatelessWidget {
  final String placeholder;
  final VoidCallback? onVoiceTap;

  const SearchHeader({
    super.key,
    required this.placeholder,
    this.onVoiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _openSearchDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1B2C21) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? const Color(0xFF284433) : const Color(0xFFDCE6DB),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: AppColors.primaryLight,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                placeholder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                ),
              ),
            ),
            Container(
              height: 24,
              width: 1,
              color: isDark ? const Color(0xFF2E4D3B) : const Color(0xFFE2ECE0),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            GestureDetector(
              onTap: () {
                if (onVoiceTap != null) {
                  onVoiceTap!();
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VoiceAssistantScreen()),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSearchDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _SearchBottomSheet(),
    );
  }
}

class _SearchBottomSheet extends StatefulWidget {
  const _SearchBottomSheet();

  @override
  State<_SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<_SearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;

    final recentSearches = lang == 'te'
        ? [
            {'icon': Icons.grass_rounded, 'label': 'వరి సాగు', 'query': 'వరి సాగు'},
            {'icon': Icons.spa_rounded, 'label': 'పత్తి ఎరువులు', 'query': 'పత్తి ఎరువులు'},
            {'icon': Icons.pest_control_rounded, 'label': 'గులాబీ రంగు పురుగు', 'query': 'గులాబీ రంగు పురుగు'},
            {'icon': Icons.currency_rupee_rounded, 'label': 'నేటి పత్తి ధర', 'query': 'పత్తి ధర'},
            {'icon': Icons.account_balance_rounded, 'label': 'రైతు భరోసా పథకం', 'query': 'రైతు భరోసా'},
          ]
        : (lang == 'hi'
            ? [
                {'icon': Icons.grass_rounded, 'label': 'धान की खेती', 'query': 'धान की खेती'},
                {'icon': Icons.spa_rounded, 'label': 'कपास खाद', 'query': 'कपास खाद'},
                {'icon': Icons.pest_control_rounded, 'label': 'गुलाबी सुंडी कीट', 'query': 'गुलाबी सुंडी'},
                {'icon': Icons.currency_rupee_rounded, 'label': 'आज कपास का भाव', 'query': 'कपास भाव'},
                {'icon': Icons.account_balance_rounded, 'label': 'रैतु भरोसा योजना', 'query': 'रैतु भरोसा'},
              ]
            : [
                {'icon': Icons.grass_rounded, 'label': 'Paddy Cultivation', 'query': 'Paddy'},
                {'icon': Icons.spa_rounded, 'label': 'Cotton Fertilizer', 'query': 'Cotton'},
                {'icon': Icons.pest_control_rounded, 'label': 'Pink Bollworm Pest', 'query': 'Pink Bollworm'},
                {'icon': Icons.currency_rupee_rounded, 'label': 'Cotton Market Price', 'query': 'Cotton Price'},
                {'icon': Icons.account_balance_rounded, 'label': 'Rythu Bharosa Scheme', 'query': 'Rythu Bharosa'},
              ]);

    final crops = AgriDataService.crops;
    final filteredCrops = _query.isEmpty
        ? crops
        : crops.where((c) =>
            c.nameEn.toLowerCase().contains(_query.toLowerCase()) ||
            c.nameTe.toLowerCase().contains(_query.toLowerCase()) ||
            c.nameHi.toLowerCase().contains(_query.toLowerCase()) ||
            c.category.toLowerCase().contains(_query.toLowerCase())).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131F17) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              // Search Input Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (val) => setState(() => _query = val),
                        decoration: InputDecoration(
                          hintText: context.tr('searchPlaceholder'),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _query = '');
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const VoiceAssistantScreen()),
                        );
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mic_rounded, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    if (_query.isEmpty) ...[
                      Text(
                        lang == 'te'
                            ? 'ఇటీవలి & ప్రాచుర్యం పొందిన శోధనలు'
                            : (lang == 'hi'
                                ? 'हाल की एवं लोकप्रिय खोजें'
                                : 'Recent & Popular Searches'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: recentSearches.map((item) {
                          return ActionChip(
                            avatar: Icon(item['icon'] as IconData, size: 16, color: AppColors.primary),
                            label: Text(item['label'] as String, style: const TextStyle(fontSize: 12)),
                            onPressed: () {
                              _searchController.text = item['query'] as String;
                              setState(() => _query = _searchController.text);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],
                    Text(
                      _query.isEmpty
                          ? (lang == 'te'
                              ? 'అన్ని పంటలు & సాగు మార్గదర్శకాలు'
                              : (lang == 'hi'
                                  ? 'सभी फसलें एवं कृषि मार्गदर्शिका'
                                  : 'All Crops & Cultivation Guides'))
                          : (lang == 'te'
                              ? 'శోధన ఫలితాలు (${filteredCrops.length})'
                              : (lang == 'hi'
                                  ? 'खोज परिणाम (${filteredCrops.length})'
                                  : 'Search Results (${filteredCrops.length})')),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    ...filteredCrops.map((crop) {
                      return Material(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          leading: Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(crop.icon, color: AppColors.primary, size: 22),
                          ),
                          title: Text(
                            crop.getLocalizedName(lang),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          subtitle: Text('${crop.getLocalizedCategory(lang)} • ${crop.getLocalizedDuration(lang)}'),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CropDetailScreen(crop: crop),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
