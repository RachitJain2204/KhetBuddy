import 'package:flutter/material.dart';
import '../../constants/colors.dart';
// Data model
class YieldDataPoint {
  final String year;
  final double value;
  final bool isHighlighted;   // dark green bar (best historical year)
  final bool isMaxPotential;  // yellow bar (with recommendations)

  const YieldDataPoint({
    required this.year,
    required this.value,
    this.isHighlighted = false,
    this.isMaxPotential = false,
  });
}

class YieldForecastCard extends StatelessWidget {
  final String cropName;
  final double minYield;
  final double avgYield;
  final double maxYield;
  final List<YieldDataPoint> historicalData;

  const YieldForecastCard({
    super.key,
    this.cropName = 'Wheat',
    this.minYield = 10.5,
    this.avgYield = 17.5,
    this.maxYield = 23.63,
    this.historicalData = const [
      YieldDataPoint(year: '\'22', value: 16.7),
      YieldDataPoint(year: '\'23', value: 16.8),
      YieldDataPoint(year: '\'24', value: 19.9, isHighlighted: true),
      YieldDataPoint(year: '\'25', value: 16.9),
      YieldDataPoint(year: '\'26', value: 16.5),
      YieldDataPoint(year: 'Max', value: 23.6, isMaxPotential: true),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: AppColors.yieldAvg, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.trending_up_rounded, color: AppColors.yieldAvg, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  '$cropName — Yield Forecast',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Min / Avg / Max stat boxes
            Row(
              children: [
                Expanded(
                  child: _YieldStatBox(
                    label: 'MINIMUM',
                    value: '$minYield tonnes',
                    sublabel: 'Poor conditions',
                    color: AppColors.yieldMin,
                    bgColor: AppColors.yieldMinBg,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _YieldStatBox(
                    label: 'AVERAGE',
                    value: '$avgYield tonnes',
                    sublabel: 'Normal growth',
                    color: AppColors.yieldAvg,
                    bgColor: AppColors.yieldAvgBg,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _YieldStatBox(
                    label: 'MAXIMUM',
                    value: '$maxYield tonnes',
                    sublabel: 'Optimized',
                    color: AppColors.yieldMax,
                    bgColor: AppColors.yieldMaxBg,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Gradient slider bar
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.yieldMin, AppColors.yieldAvg, AppColors.yieldMax],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // Thumb at ~35% position (avg on the scale)
                FractionallySizedBox(
                  widthFactor: 0.35,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.yieldAvg,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Disclaimer box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline, size: 14, color: AppColors.hintText),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Based on regional data and current soil conditions. Actual yields may vary with weather patterns.',
                      style: TextStyle(fontSize: 12, color: AppColors.hintText, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Chart label
            const Text(
              'HISTORICAL VS POTENTIAL YIELD',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.hintText,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),

            // Bar chart
            _YieldBarChart(data: historicalData),
            const SizedBox(height: 12),

            // Legend
            Row(
              children: const [
                _LegendDot(color: AppColors.yieldMax, label: 'Historical Yield'),
                SizedBox(width: 16),
                _LegendDot(color: AppColors.yieldAvg, label: 'With Recommendations'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────────────────

class _YieldStatBox extends StatelessWidget {
  final String label;
  final String value;
  final String sublabel;
  final Color color;
  final Color bgColor;

  const _YieldStatBox({
    required this.label,
    required this.value,
    required this.sublabel,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(sublabel, style: const TextStyle(fontSize: 11, color: AppColors.hintText)),
        ],
      ),
    );
  }
}

class _YieldBarChart extends StatelessWidget {
  final List<YieldDataPoint> data;

  const _YieldBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxVal = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((point) {
          Color barColor;
          if (point.isMaxPotential) {
            barColor = AppColors.yieldAvg;
          } else if (point.isHighlighted) {
            barColor = AppColors.yieldMax;
          } else {
            barColor = const Color(0xFFCCCCCC);
          }

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    point.value.toString(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: point.isMaxPotential ? AppColors.yieldAvg : AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 80 * (point.value / maxVal),
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    point.year,
                    style: TextStyle(
                      fontSize: 11,
                      color: point.isMaxPotential ? AppColors.yieldAvg : AppColors.hintText,
                      fontWeight: point.isMaxPotential ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.hintText)),
      ],
    );
  }
}