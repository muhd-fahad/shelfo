import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/report_provider.dart';
import 'package:shelfo/utils/theme/app_constants/colors.dart';

class CategoryDistributionChart extends StatelessWidget {
  const CategoryDistributionChart({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<ReportProvider>();
    final theme = Theme.of(context);

    return SizedBox(
      height: 150.h,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: 180,
              sectionsSpace: 4,
              centerSpaceRadius: 60.r,
              sections: _getHalfPieSections(reportProvider),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Text(
                  "Total",
                  style: theme.textTheme.labelSmall,
                ),
                Text(
                  reportProvider.inventoryValue,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getHalfPieSections(ReportProvider provider) {
    final cats = provider.categories;
    if (cats.isEmpty) return [];

    final List<Color> colors = [
      AppColors.success,
      AppColors.info,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];

    List<PieChartSectionData> sections = [];
    double totalValue = 0;
    for (var cat in cats) {
      totalValue += cat['value'];
    }

    final activeCats = cats.where((c) => c['value'] > 0).toList();

    if (activeCats.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey.withValues(alpha: 0.2),
          value: 1,
          radius: 20.r,
          showTitle: false,
          cornerRadius: 10.r,
        ),
        PieChartSectionData(
          color: Colors.transparent,
          value: 1,
          radius: 20.r,
          showTitle: false,
        ),
      ];
    }

    for (int i = 0; i < activeCats.length; i++) {
      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: activeCats[i]['value'],
          title: '',
          radius: 20.r,
          showTitle: false,
          cornerRadius: 10.r,
        ),
      );
    }

    sections.add(
      PieChartSectionData(
        color: Colors.transparent,
        value: totalValue,
        title: '',
        radius: 20.r,
        showTitle: false,
      ),
    );

    return sections;
  }
}
