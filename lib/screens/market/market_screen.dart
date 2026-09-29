import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/market_model.dart';
import '../../services/agri_data_service.dart';
import '../../services/app_state_service.dart';
import 'price_chart_sheet.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String _selectedFilter = 'Nearby';
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _filters = [
    'Nearby',
    'Mandi (Govt)',
    'Private Buyer',
    'Highest Price',
    'Lowest Price',
  ];

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
    final allPrices = AgriDataService.marketPrices;

    // Filter & Sort logic
    var list = allPrices.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.cropNameEn.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.cropNameTe.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.mandiName.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;

      if (_selectedFilter == 'Mandi (Govt)') return p.isGovtMandi;
      return true;
    }).toList();

    if (_selectedFilter == 'Nearby') {
      list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    } else if (_selectedFilter == 'Highest Price') {
      list.sort((a, b) => b.modalPrice.compareTo(a.modalPrice));
    } else if (_selectedFilter == 'Lowest Price') {
      list.sort((a, b) => a.modalPrice.compareTo(b.modalPrice));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang == 'te' ? 'నేటి మార్కెట్ ధరలు' : "Today's Mandi Market Rates",
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: lang == 'te' ? 'పంట లేదా మార్కెట్ యార్డ్ పేరు వెతకండి...' : 'Search crop or mandi market...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.accentAmber),
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
          // Filter Chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              itemCount: _filters.length,
              separatorBuilder: (_, index) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final f = _filters[idx];
                final isSelected = _selectedFilter == f;

                return ChoiceChip(
                  label: Text(f),
                  selected: isSelected,
                  selectedColor: AppColors.accentAmber,
                  backgroundColor: isDark ? const Color(0xFF1E3024) : Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 12.5,
                  ),
                  onSelected: (_) => setState(() => _selectedFilter = f),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Market Cards List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              itemCount: list.length,
              separatorBuilder: (_, index) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final item = list[idx];
                return _buildMarketCard(context, item, isDark, lang);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketCard(BuildContext context, MarketPriceModel item, bool isDark, String lang) {
    final isPositiveChange = item.priceChange >= 0;

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
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => PriceChartSheet(marketItem: item),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: Crop Name & Change Pill
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(item.icon, size: 24, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.getLocalizedCrop(lang),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  lang == 'te'
                                      ? '${item.getLocalizedMandi(lang)} • ${item.distanceKm} కి.మీ'
                                      : (lang == 'hi'
                                          ? '${item.getLocalizedMandi(lang)} • ${item.distanceKm} किमी दूर'
                                          : '${item.getLocalizedMandi(lang)} • ${item.distanceKm} km away'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11.5, color: Colors.grey[600]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPositiveChange
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isPositiveChange ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                            size: 14,
                            color: isPositiveChange ? AppColors.success : AppColors.danger,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${isPositiveChange ? '+' : ''}₹${item.priceChange.toInt()}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isPositiveChange ? AppColors.success : AppColors.danger,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Main Rate Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1F3325) : const Color(0xFFF4F9F4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang == 'te' ? 'మార్కెట్ యార్డ్ సగటు ధర' : (lang == 'hi' ? 'मंडी मॉडल भाव' : 'Mandi Modal Rate'),
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹${item.modalPrice.toInt()} / ${lang == 'te' ? 'క్వింటాల్' : (lang == 'hi' ? 'क्विंटल' : 'Quintal')}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            lang == 'te' ? 'వ్యాపారి రేటు' : (lang == 'hi' ? 'व्यापारी भाव' : 'Trader Rate'),
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹${item.privateRate.toInt()}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFEC4899),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Min - Max Range and Chart trigger
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'కనిష్ట: ₹${item.minPrice.toInt()}  |  గరిష్ట: ₹${item.maxPrice.toInt()}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.show_chart_rounded, size: 16, color: Color(0xFF0D9488)),
                        const SizedBox(width: 4),
                        Text(
                          lang == 'te' ? 'ధరల గ్రాఫ్ →' : (lang == 'hi' ? 'मूल्य चार्ट →' : 'Price Chart →'),
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D9488),
                          ),
                        ),
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
}
