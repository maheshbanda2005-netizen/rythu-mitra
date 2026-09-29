import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/equipment_model.dart';
import '../../services/agri_data_service.dart';
import '../../services/app_state_service.dart';

class EquipmentRentalScreen extends StatefulWidget {
  const EquipmentRentalScreen({super.key});

  @override
  State<EquipmentRentalScreen> createState() => _EquipmentRentalScreenState();
}

class _EquipmentRentalScreenState extends State<EquipmentRentalScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Tractor',
    'Drone',
    'Harvester',
    'Sprayer',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final list = AgriDataService.rentalEquipment;
    final lang = context.watch<AppStateService>().currentLanguage;

    final filtered = _selectedCategory == 'All'
        ? list
        : list.where((e) => e.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('equipmentTitle')),
      ),
      body: Column(
        children: [
          // Filter Chips
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              itemCount: _categories.length,
              separatorBuilder: (_, index) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final c = _categories[idx];
                final isSelected = _selectedCategory == c;

                return ChoiceChip(
                  label: Text(c),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: isDark ? const Color(0xFF1E3024) : Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => _selectedCategory = c),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Equipment List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (_, index) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final eq = filtered[idx];
                return _buildEquipmentCard(context, eq, isDark, lang);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentCard(BuildContext context, EquipmentRentalItem eq, bool isDark, String lang) {
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
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(eq.icon, size: 26, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eq.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                          const SizedBox(width: 2),
                          Text('${eq.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          Text('• ${eq.location} (${eq.distanceKm} km)', style: TextStyle(fontSize: 11.5, color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Rental Rates
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F3325) : const Color(0xFFF4F9F4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 'te' ? 'గంటకు అద్దె' : (lang == 'hi' ? 'प्रति घंटा किराया' : 'Hourly Rate'),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 2),
                      Text('₹${eq.ratePerHour.toInt()} / hr', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.primary)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        lang == 'te' ? 'రోజుకు అద్దె' : (lang == 'hi' ? 'प्रति दिन किराया' : 'Daily Rate'),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 2),
                      Text('₹${eq.ratePerDay.toInt()} / day', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      lang == 'te' ? 'అందుబాటులో ఉంది' : (lang == 'hi' ? 'उपलब्ध है' : 'Available Now'),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Calling owner: ${eq.ownerName} (${eq.phone})')),
                    );
                  },
                  icon: const Icon(Icons.call_rounded, size: 16),
                  label: Text(lang == 'te' ? 'యజమానికి కాల్ చేయండి' : (lang == 'hi' ? 'मालिक को कॉल करें' : 'Call Owner')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(0, 42),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
