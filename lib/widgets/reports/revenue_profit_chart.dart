import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/report_provider.dart';
import 'package:shelfo/utils/theme/app_constants/colors.dart';

class RevenueProfitChart extends StatelessWidget {
  const RevenueProfitChart({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<ReportProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final labels = reportProvider.getChartLabels();
    final spots = reportProvider.getWeeklySalesSpots();
    final profitSpots = reportProvider.getWeeklyProfitSpots();

    return SizedBox(
      height: 200.h,
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
                reservedSize: 30,
                interval: labels.length > 10 ? 5 : 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < labels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        labels[index],
                        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 9.sp),
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
              spots: spots,
              isCurved: true,
              color: AppColors.success,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.success.withValues(alpha: 0.1),
              ),
            ),
            LineChartBarData(
              spots: profitSpots,
              isCurved: true,
              color: AppColors.info,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.info.withValues(alpha: 0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => colorScheme.surface,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final prefix = barSpot.barIndex == 0 ? "Revenue: " : "Profit: ";
                  return LineTooltipItem(
                    '$prefix₹${barSpot.y.toInt()}',
                    TextStyle(
                      color: barSpot.barIndex == 0 ? AppColors.success : AppColors.info,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
