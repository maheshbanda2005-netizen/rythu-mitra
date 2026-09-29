import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/market_model.dart';
import '../../services/app_state_service.dart';
import 'widgets/recharts_market_graph.dart';

class PriceChartSheet extends StatelessWidget {
  final MarketPriceModel marketItem;

  const PriceChartSheet({super.key, required this.marketItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131F17) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: ListView(
            controller: scrollCtrl,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          marketItem.getLocalizedCrop(lang),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lang == 'te'
                              ? '${marketItem.getLocalizedMandi(lang)} • 30 రోజుల ధరల వివరాలు'
                              : (lang == 'hi'
                                  ? '${marketItem.getLocalizedMandi(lang)} • 30 दिनों का रुझान'
                                  : '${marketItem.getLocalizedMandi(lang)} • 30-Day Trend'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '₹${marketItem.modalPrice.toInt()}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Recharts Dual-Series Interactive Chart
              RechartsMarketGraph(
                marketItem: marketItem,
                isCompact: false,
                lang: 'te',
              ),
              const SizedBox(height: 20),

              // KPI Summary
              Row(
                children: [
                  _buildStatCard('30-Day Lowest', '₹${marketItem.minPrice.toInt()}', Colors.red),
                  const SizedBox(width: 10),
                  _buildStatCard('30-Day Highest', '₹${marketItem.maxPrice.toInt()}', Colors.green),
                  const SizedBox(width: 10),
                  _buildStatCard('Today Average', '₹${marketItem.modalPrice.toInt()}', AppColors.primary),
                ],
              ),
              const SizedBox(height: 20),

              // Market Advisory
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2822) : const Color(0xFFF1F5F1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.lightbulb_outline_rounded, size: 20, color: Color(0xFFEAB308)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'మార్కెట్ సలహా: పత్తి ధరలు ఈ వారం స్థిరంగా లేదా స్వల్పంగా పెరిగే అవకాశం ఉంది. నాణ్యత (తేమ 8-10% ఉండేలా) చూసుకుని యార్డుకు తీసుకురావడం ఉత్తమం.',
                        style: TextStyle(fontSize: 12.5, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, Color col) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: col.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: col.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 10.5, color: col, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 14, color: col, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}
