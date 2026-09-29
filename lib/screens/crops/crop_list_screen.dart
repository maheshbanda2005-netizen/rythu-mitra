import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/crop_model.dart';
import '../../services/agri_data_service.dart';
import '../../services/app_state_service.dart';
import 'crop_detail_screen.dart';

class CropListScreen extends StatefulWidget {
  const CropListScreen({super.key});

  @override
  State<CropListScreen> createState() => _CropListScreenState();
}

class _CropListScreenState extends State<CropListScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _filterKeys = [
    'allFilter',
    'kharifFilter',
    'rabiFilter',
    'commercialFilter',
    'summerFilter',
    'vegetableFilter',
  ];

  final Map<String, String> _filterToCategory = {
    'allFilter': 'All',
    'kharifFilter': 'Kharif',
    'rabiFilter': 'Rabi',
    'commercialFilter': 'Commercial',
    'summerFilter': 'Summer',
    'vegetableFilter': 'Vegetables',
  };

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;
    final crops = AgriDataService.crops;

    final targetCategory = _filterToCategory[_selectedFilter] ?? 'All';

    final filteredCrops = crops.where((c) {
      final matchesFilter = targetCategory == 'All' || c.category == targetCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          c.nameEn.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.nameTe.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.soilTypeEn.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.soilTypeTe.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('cropGuide')),
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: context.tr('searchPlaceholder'),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          // Category Filter Chips (100% Pure Single Language)
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              itemCount: _filterKeys.length,
              separatorBuilder: (_, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filterKey = _filterKeys[index];
                final isSelected = _selectedFilter == filterKey;
                final label = context.tr(filterKey);

                return ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: isDark ? const Color(0xFF1E3024) : Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? const Color(0xFF2E4535) : const Color(0xFFD8E2D6)),
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedFilter = filterKey);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Crop Cards List
          Expanded(
            child: filteredCrops.isEmpty
                ? Center(
                    child: Text(
                      '${context.tr('filter')}: "$_searchQuery"',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    itemCount: filteredCrops.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final crop = filteredCrops[index];
                      return _buildCropCard(context, crop, isDark, lang);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropCard(BuildContext context, CropModel crop, bool isDark, String lang) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CropDetailScreen(crop: crop)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            crop.imageUrl,
                            width: 58,
                            height: 58,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 58,
                              height: 58,
                              color: AppColors.primaryContainer,
                              alignment: Alignment.center,
                              child: Icon(crop.icon, color: AppColors.primary, size: 28),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(crop.icon, color: AppColors.primary, size: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            crop.getLocalizedName(lang),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            crop.getLocalizedSoil(lang),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1B2E20) : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        crop.getLocalizedCategory(lang),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Quick info chips
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E3025) : const Color(0xFFF6FAF6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildMiniInfo(
                          Icons.schedule_rounded,
                          context.tr('durationLabel'),
                          crop.getLocalizedDuration(lang),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: isDark ? Colors.white12 : Colors.black12,
                      ),
                      Expanded(
                        child: _buildMiniInfo(
                          Icons.water_drop_outlined,
                          context.tr('waterLabel'),
                          crop.getLocalizedWater(lang),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: isDark ? Colors.white12 : Colors.black12,
                      ),
                      Expanded(
                        child: _buildMiniInfo(
                          Icons.trending_up_rounded,
                          context.tr('yieldLabel'),
                          crop.getLocalizedYield(lang),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${context.tr('costLabel')}: ${crop.getLocalizedCost(lang)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.tr('viewDetails'),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryMedium,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primaryMedium),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniInfo(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10.5, color: Colors.grey[600], fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
