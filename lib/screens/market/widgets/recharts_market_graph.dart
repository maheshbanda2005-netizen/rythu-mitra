import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/market_model.dart';

class RechartsMarketGraph extends StatefulWidget {
  final MarketPriceModel marketItem;
  final bool isCompact;
  final String lang;

  const RechartsMarketGraph({
    super.key,
    required this.marketItem,
    this.isCompact = false,
    this.lang = 'te',
  });

  @override
  State<RechartsMarketGraph> createState() => _RechartsMarketGraphState();
}

class _RechartsMarketGraphState extends State<RechartsMarketGraph> {
  int _selectedDays = 30; // 7, 15, or 30

  // Palette matching the HTML specification
  static const Color tealColor = Color(0xFF0D9488); // --color-teal-500
  static const Color pinkColor = Color(0xFFEC4899); // --color-pink-500

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF16241C) : Colors.white;
    final borderColor = isDark ? const Color(0xFF263D30) : const Color(0xFFE5EBE3);
    final gridColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.07);

    // Filter points based on selected period
    final allPoints = widget.marketItem.history;
    final int takeCount = _selectedDays.clamp(1, allPoints.length);
    final points = allPoints.sublist(allPoints.length - takeCount);

    if (points.isEmpty) return const SizedBox.shrink();

    // Generate spots for Mandi Rate (Teal)
    final mandiSpots = <FlSpot>[];
    // Generate spots for Trader Rate (Pink)
    final traderSpots = <FlSpot>[];

    double minY = double.infinity;
    double maxY = -double.infinity;

    final double traderRatio = widget.marketItem.modalPrice > 0
        ? (widget.marketItem.privateRate / widget.marketItem.modalPrice)
        : 0.96;

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final x = i.toDouble();
      final yMandi = p.price;
      // Slight smooth variation for trader rate benchmark
      final yTrader = (p.price * traderRatio) + (((i % 3) - 1) * 10);

      mandiSpots.add(FlSpot(x, yMandi));
      traderSpots.add(FlSpot(x, yTrader));

      if (yMandi < minY) minY = yMandi;
      if (yTrader < minY) minY = yTrader;
      if (yMandi > maxY) maxY = yMandi;
      if (yTrader > maxY) maxY = yTrader;
    }

    final double yPadding = (maxY - minY) * 0.18 + 20;
    final double computedMinY = (minY - yPadding).clamp(0, double.infinity);
    final double computedMaxY = maxY + yPadding;

    return Container(
      padding: EdgeInsets.all(widget.isCompact ? 14 : 18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Title & Toolbar (Legend + Timeframe)
          _buildHeader(isDark),
          SizedBox(height: widget.isCompact ? 12 : 16),

          // Recharts Surface
          SizedBox(
            height: widget.isCompact ? 175 : 230,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (points.length - 1).toDouble(),
                minY: computedMinY,
                maxY: computedMaxY,
                clipData: const FlClipData.none(),
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  getTouchedSpotIndicator: (barData, spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: tealColor.withValues(alpha: 0.8),
                          strokeWidth: 1.2,
                          dashArray: [4, 3],
                        ),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, idx) {
                            final isTeal = bar.color == tealColor;
                            return FlDotCirclePainter(
                              radius: 5,
                              color: isDark ? const Color(0xFF16241C) : Colors.white,
                              strokeColor: isTeal ? tealColor : pinkColor,
                              strokeWidth: 2.5,
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      if (touchedSpots.isEmpty) return [];
                      final idx = touchedSpots.first.spotIndex;
                      final pointDate = (idx >= 0 && idx < points.length)
                          ? points[idx].dateLabel
                          : '';

                      return touchedSpots.map((barSpot) {
                        final isTeal = barSpot.bar.color == tealColor;
                        final label = isTeal
                            ? (widget.lang == 'te' ? 'మండి' : 'Mandi')
                            : (widget.lang == 'te' ? 'వ్యాపారి' : 'Trader');
                        return LineTooltipItem(
                          '$pointDate\n$label: ₹${barSpot.y.toInt()}',
                          TextStyle(
                            color: isTeal ? tealColor : pinkColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: gridColor,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                  getDrawingVerticalLine: (_) => FlLine(
                    color: gridColor,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (val, meta) {
                        if (val == meta.min || val == meta.max) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          '₹${(val / 1000).toStringAsFixed(1)}k',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white38 : Colors.black45,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: (points.length / (widget.isCompact ? 3 : 5)).clamp(1, 10),
                      getTitlesWidget: (val, meta) {
                        final i = val.toInt();
                        if (i < 0 || i >= points.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            points[i].dateLabel,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? Colors.white38 : Colors.black45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // 1. Mandi Price (Teal Series with smooth area gradient & ring dots)
                  LineChartBarData(
                    spots: mandiSpots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: tealColor,
                    barWidth: 2.2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: !widget.isCompact,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3.5,
                          color: isDark ? const Color(0xFF16241C) : Colors.white,
                          strokeColor: tealColor,
                          strokeWidth: 2,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          tealColor.withValues(alpha: 0.28),
                          tealColor.withValues(alpha: 0.02),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // 2. Trader / Goal Rate (Pink Series with dashed line & ring dots)
                  LineChartBarData(
                    spots: traderSpots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: pinkColor,
                    barWidth: 2.0,
                    dashArray: [4, 4], // Dashed stroke
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: !widget.isCompact,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3.5,
                          color: isDark ? const Color(0xFF16241C) : Colors.white,
                          strokeColor: pinkColor,
                          strokeWidth: 2,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final title = widget.lang == 'te'
        ? 'ధరల సరళి'
        : (widget.lang == 'hi' ? 'मूल्य रुझान' : 'Price Overview');
    final mandiLabel = widget.lang == 'te' ? 'మండి రేటు' : (widget.lang == 'hi' ? 'मंडी भाव' : 'Mandi');
    final traderLabel = widget.lang == 'te' ? 'వ్యాపారి రేటు' : (widget.lang == 'hi' ? 'व्यापारी भाव' : 'Trader');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title
        Text(
          title,
          style: TextStyle(
            fontSize: widget.isCompact ? 13 : 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),

        // Legend & Timeframe Toolbar
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mandi Legend (Teal ring dot)
            _buildLegendDot(
              color: tealColor,
              label: mandiLabel,
              isDark: isDark,
            ),
            const SizedBox(width: 8),

            // Trader Legend (Pink ring dot)
            _buildLegendDot(
              color: pinkColor,
              label: traderLabel,
              isDark: isDark,
            ),
            const SizedBox(width: 10),

            // Lightweight Period Switcher (7D / 15D / 30D)
            _buildPeriodSelector(isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendDot({
    required Color color,
    required String label,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? const Color(0xFF16241C) : Colors.white,
            border: Border.all(color: color, width: 2.5),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: widget.isCompact ? 10 : 11.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E3024) : const Color(0xFFF1F5F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [7, 15, 30].map((d) {
          final isSelected = _selectedDays == d;
          return GestureDetector(
            onTap: () {
              if (_selectedDays != d) {
                setState(() => _selectedDays = d);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? const Color(0xFF2E4D3A) : Colors.white)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                '${d}D',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected
                      ? (isDark ? Colors.white : AppColors.primary)
                      : (isDark ? Colors.white54 : Colors.black45),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
