import 'package:flutter/material.dart';

enum ExpenseCategory {
  seeds,
  fertilizer,
  pesticides,
  tractor,
  labour,
  irrigation,
  transport,
  other,
  harvestRevenue,
}

class FarmExpenseItem {
  final String id;
  final String title;
  final ExpenseCategory category;
  final double amount;
  final DateTime date;
  final String cropName;
  final bool isIncome;
  final String notes;

  const FarmExpenseItem({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.cropName,
    this.isIncome = false,
    this.notes = '',
  });

  String categoryLabelFor(String lang) {
    switch (category) {
      case ExpenseCategory.seeds:
        return lang == 'te' ? 'విత్తనాలు' : (lang == 'hi' ? 'बीज' : 'Seeds');
      case ExpenseCategory.fertilizer:
        return lang == 'te' ? 'ఎరువులు' : (lang == 'hi' ? 'उर्वरक' : 'Fertilizer');
      case ExpenseCategory.pesticides:
        return lang == 'te' ? 'పురుగుమందులు' : (lang == 'hi' ? 'कीटनाशक' : 'Pesticides');
      case ExpenseCategory.tractor:
        return lang == 'te' ? 'యంత్రాలు & ట్రాక్టర్' : (lang == 'hi' ? 'मशीनरी एवं ट्रैक्टर' : 'Machinery & Tractor');
      case ExpenseCategory.labour:
        return lang == 'te' ? 'కూలీలు' : (lang == 'hi' ? 'मजदूरी' : 'Labour');
      case ExpenseCategory.irrigation:
        return lang == 'te' ? 'నీటిపారుదల' : (lang == 'hi' ? 'सिंचाई' : 'Irrigation');
      case ExpenseCategory.transport:
        return lang == 'te' ? 'రవాణా' : (lang == 'hi' ? 'परिवहन' : 'Transport');
      case ExpenseCategory.harvestRevenue:
        return lang == 'te' ? 'దిగుబడి రాబడి' : (lang == 'hi' ? 'फसल बिक्री आय' : 'Crop Revenue');
      case ExpenseCategory.other:
        return lang == 'te' ? 'ఇతర' : (lang == 'hi' ? 'अन्य' : 'Other');
    }
  }

  String get categoryLabel => categoryLabelFor('en');

  IconData get icon {
    switch (category) {
      case ExpenseCategory.seeds:
        return Icons.spa_rounded;
      case ExpenseCategory.fertilizer:
        return Icons.science_rounded;
      case ExpenseCategory.pesticides:
        return Icons.pest_control_rounded;
      case ExpenseCategory.tractor:
        return Icons.agriculture_rounded;
      case ExpenseCategory.labour:
        return Icons.groups_rounded;
      case ExpenseCategory.irrigation:
        return Icons.water_drop_rounded;
      case ExpenseCategory.transport:
        return Icons.local_shipping_rounded;
      case ExpenseCategory.harvestRevenue:
        return Icons.currency_rupee_rounded;
      case ExpenseCategory.other:
        return Icons.inventory_2_rounded;
    }
  }

  String get categoryIcon => '';
}
