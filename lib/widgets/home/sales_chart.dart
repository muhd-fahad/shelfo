import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/report_provider.dart';
import '../../utils/theme/theme.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final reportProvider = context.watch<ReportProvider>();
    final spots = reportProvider.getWeeklySalesSpots();
    final labels = reportProvider.getChartLabels();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        shape: RoundedSuperellipseBorder(
          borderRadius: AppRadius.lg,
          side: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sales Trends",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildPeriodDropdown(context, reportProvider),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 120.h,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                   leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: labels.length > 10 ? 5 : 1,
                        getTitlesWidget: (value, meta) {
                           int index = value.toInt();
                           if (index >= 0 && index < labels.length) {
                             return Text(
                               labels[index],
                               style: TextStyle(
                                 color: theme.colorScheme.onSurfaceVariant,
                                 fontSize: 9.sp,
                               ),
                             );
                           }
                           return const Text('');
                        },
                      ),
                   ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots.isEmpty ? [const FlSpot(0, 0)] : spots,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => theme.colorScheme.surface,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '₹${barSpot.y.toInt()}',
                          theme.textTheme.labelSmall!.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodDropdown(BuildContext context, ReportProvider provider) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<ReportPeriod>(
      initialValue: provider.selectedPeriod,
      onSelected: provider.setPeriod,
      itemBuilder: (context) => [
        ReportPeriod.last7Days,
        ReportPeriod.last30Days,
        ReportPeriod.thisMonth,
      ].map((p) => PopupMenuItem(
            value: p,
            child: Text(p.label),
          ))
      .toList(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Text(provider.selectedPeriod.label, style: TextStyle(fontSize: 10.sp, color: colorScheme.onSurfaceVariant)),
            Icon(Icons.keyboard_arrow_down, size: 12.sp, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
