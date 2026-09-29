import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/marketplace_model.dart';
import '../../services/agri_data_service.dart';
import '../../services/app_state_service.dart';

class AgriMarketplaceScreen extends StatefulWidget {
  const AgriMarketplaceScreen({super.key});

  @override
  State<AgriMarketplaceScreen> createState() => _AgriMarketplaceScreenState();
}

class _AgriMarketplaceScreenState extends State<AgriMarketplaceScreen> {
  String _selectedCategory = 'All';

  static const List<Map<String, String>> _categories = [
    {'id': 'All', 'te': 'అన్నీ', 'en': 'All', 'hi': 'सभी'},
    {'id': 'Seeds', 'te': 'విత్తనాలు', 'en': 'Seeds', 'hi': 'बीज'},
    {'id': 'Fertilizers', 'te': 'ఎరువులు', 'en': 'Fertilizers', 'hi': 'उर्वरक'},
    {'id': 'Organic', 'te': 'సేంద్రీయ', 'en': 'Organic', 'hi': 'जैविक'},
    {'id': 'Irrigation', 'te': 'నీటిపారుదల', 'en': 'Irrigation', 'hi': 'सिंचाई'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;
    final products = AgriDataService.marketplaceProducts;

    final filtered = _selectedCategory == 'All'
        ? products
        : products.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('marketplaceTitle')),
      ),
      body: Column(
        children: [
          // Filter Bar
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              itemCount: _categories.length,
              separatorBuilder: (_, index) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final cat = _categories[idx];
                final catId = cat['id']!;
                final isSelected = _selectedCategory == catId;
                final catLabel = cat[lang] ?? cat['en'] ?? catId;

                return ChoiceChip(
                  label: Text(catLabel),
                  selected: isSelected,
                  selectedColor: const Color(0xFF0891B2),
                  backgroundColor: isDark ? const Color(0xFF1E3024) : Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => _selectedCategory = catId),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Product List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (_, index) => const SizedBox(height: 14),
              itemBuilder: (context, idx) {
                final p = filtered[idx];
                return _buildProductCard(context, p, isDark, lang);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, MarketProduct p, bool isDark, String lang) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16241C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(p.icon, size: 28, color: const Color(0xFF0891B2)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.getLocalizedTitle(lang),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
                        ),
                      ),
                      if (p.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF0891B2)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${p.getLocalizedSeller(lang)} • ${p.getLocalizedLocation(lang)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.5, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '₹${p.price.toInt()} / ${p.getLocalizedUnit(lang)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${p.getLocalizedSeller(lang)}: ${p.phone}')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0891B2),
                          minimumSize: const Size(0, 34),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          context.tr('marketplaceCart'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
