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

    return SizedBox(
      height: 180.h,
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
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  if (value >= 0 && value < 7) {
                    return Text(
                      days[value.toInt()],
                      style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10.sp),
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
              spots: reportProvider.getWeeklySalesSpots(),
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
              spots: reportProvider.getWeeklyProfitSpots(),
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
        ),
      ),
    );
  }
}
