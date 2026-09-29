import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/expense_model.dart';
import '../../services/app_state_service.dart';

class FarmExpensesScreen extends StatefulWidget {
  const FarmExpensesScreen({super.key});

  @override
  State<FarmExpensesScreen> createState() => _FarmExpensesScreenState();
}

class _FarmExpensesScreenState extends State<FarmExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('expenseTracker')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseSheet(context, appState),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(context.tr('addExpense'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Cards
            Row(
              children: [
                _buildKpiCard(
                  title: lang == 'te' ? 'మొత్తం ఖర్చు' : (lang == 'hi' ? 'कुल लागत' : 'Total Cost'),
                  amount: '₹${appState.totalExpenses.toInt()}',
                  col: const Color(0xFFDC2626),
                  icon: Icons.trending_down_rounded,
                ),
                const SizedBox(width: 12),
                _buildKpiCard(
                  title: lang == 'te' ? 'అంచనా రాబడి' : (lang == 'hi' ? 'अनुमानित आय' : 'Expected Revenue'),
                  amount: '₹${appState.estimatedRevenue.toInt()}',
                  col: const Color(0xFF16A34A),
                  icon: Icons.trending_up_rounded,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF15803D), Color(0xFF166534)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF166534).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 'te' ? 'అంచనా నికర లాభం' : (lang == 'hi' ? 'अनुमानित शुद्ध लाभ' : 'Estimated Net Profit'),
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${appState.farmAreaAcres} ${lang == 'te' ? 'ఎకరాల' : (lang == 'hi' ? 'एकड़' : 'Acres')} • ${appState.activeCrop}',
                        style: const TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                  Text(
                    '₹${appState.estimatedNetProfit.toInt()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Expense Categories Breakdown
            Text(
              lang == 'te' ? 'ఖర్చుల వివరాలు' : (lang == 'hi' ? 'व्यय का विवरण' : 'Expense Ledger'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),

            ...appState.expenses.map((exp) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF16241C) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? const Color(0xFF263D30) : const Color(0xFFE2EBE0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(exp.icon, size: 22, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exp.title,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            exp.categoryLabelFor(lang),
                            style: TextStyle(fontSize: 11.5, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${exp.amount.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({required String title, required String amount, required Color col, required IconData icon}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: col.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: col.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 11, color: col, fontWeight: FontWeight.w700)),
                Icon(icon, size: 18, color: col),
              ],
            ),
            const SizedBox(height: 6),
            Text(amount, style: TextStyle(fontSize: 20, color: col, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  void _showAddExpenseSheet(BuildContext context, AppStateService appState) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final lang = appState.currentLanguage;
    ExpenseCategory selectedCat = ExpenseCategory.fertilizer;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF131F17)
                  : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang == 'te' ? 'కొత్త ఖర్చును నమోదు చేయండి' : (lang == 'hi' ? 'नया खर्च दर्ज करें' : 'Record New Expense'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: lang == 'te' ? 'ఖర్చు వివరాలు' : (lang == 'hi' ? 'खर्च का विवरण' : 'Expense Details'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: lang == 'te' ? 'మొత్తం ఖర్చు (రూ.)' : (lang == 'hi' ? 'कुल राशि (₹)' : 'Amount (₹)'),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ExpenseCategory>(
                  initialValue: selectedCat,
                  decoration: InputDecoration(
                    labelText: lang == 'te' ? 'కేటగిరీ' : (lang == 'hi' ? 'श्रेणी' : 'Category'),
                  ),
                  items: ExpenseCategory.values.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat.name),
                    );
                  }).toList(),
                  onChanged: (val) => setSheetState(() => selectedCat = val!),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    final amt = double.tryParse(amountCtrl.text.trim()) ?? 0;
                    if (titleCtrl.text.isNotEmpty && amt > 0) {
                      appState.addExpense(
                        FarmExpenseItem(
                          id: 'e_${DateTime.now().millisecondsSinceEpoch}',
                          title: titleCtrl.text.trim(),
                          category: selectedCat,
                          amount: amt,
                          date: DateTime.now(),
                          cropName: appState.activeCrop,
                        ),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(lang == 'te' ? 'ఖర్చును భద్రపరచండి' : (lang == 'hi' ? 'खर्च सहेजें' : 'Save Expense')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
