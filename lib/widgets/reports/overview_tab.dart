import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/report_provider.dart';
import 'package:shelfo/utils/theme/app_constants/colors.dart';
import 'package:shelfo/utils/theme/app_constants/spacing.dart';
import 'package:shelfo/widgets/reports/category_distribution_chart.dart';
import 'package:shelfo/widgets/reports/report_metric_card.dart';
import 'package:shelfo/widgets/reports/revenue_profit_chart.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_divider.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<ReportProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.3,
            children: [
              ReportMetricCard(
                title: "Total Revenue",
                value: reportProvider.totalRevenue,
                trend: reportProvider.revenueTrend,
                icon: Icons.attach_money,
                iconColor: AppColors.success,
              ),
              ReportMetricCard(
                title: "Gross Profit",
                value: reportProvider.grossProfit,
                trend: reportProvider.profitTrend,
                icon: Icons.trending_up,
                iconColor: AppColors.info,
              ),
              ReportMetricCard(
                title: "Inventory Value",
                value: reportProvider.inventoryValue,
                subtitle: reportProvider.inventorySubtitle,
                icon: Icons.inventory_2_outlined,
                iconColor: AppColors.warning,
              ),
              ReportMetricCard(
                title: "Active Customers",
                value: reportProvider.activeCustomers,
                trend: reportProvider.customersTrend,
                icon: Icons.people_outline,
                iconColor: Colors.purple,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          SFOCard(
            padding: EdgeInsets.all(16.r),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SFOSectionHeader(title: "Revenue vs Profit"),
                  _buildPeriodDropdown(context, reportProvider),
                ],
              ),
              SizedBox(height: 24.h),
              const RevenueProfitChart(),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(context, "Revenue", AppColors.success),
                  SizedBox(width: 16.w),
                  _buildLegendItem(context, "Profit", AppColors.info),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          SFOCard(
            padding: EdgeInsets.all(16.r),
            children: [
              const SFOSectionHeader(title: "Inventory by Category"),
              SizedBox(height: 24.h),
              const CategoryDistributionChart(),
              SizedBox(height: 8.h),
              _buildDonutLegend(context, reportProvider),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SFOSectionHeader(title: "Top Selling Products"),
              TextButton(
                onPressed: () {},
                child: Text(
                  "View All Sales",
                  style: TextStyle(fontSize: 12.sp, color: AppColors.info),
                ),
              ),
            ],
          ),
          if (reportProvider.topProducts.isEmpty)
            const SFOCard(
              padding: EdgeInsets.all(24),
              children: [Center(child: Text("No sales data available"))],
            )
          else
            SFOCard(
              children: reportProvider.topProducts.expand((product) => [
                _buildProductListItem(context, product['name'], product['sold'], product['revenue']),
                if (reportProvider.topProducts.last != product) const SFODivider(),
              ]).toList(),
            ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildPeriodDropdown(BuildContext context, ReportProvider provider) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: PopupMenuButton<ReportPeriod>(
        initialValue: provider.selectedPeriod,
        onSelected: provider.setPeriod,
        itemBuilder: (context) => ReportPeriod.values
            .map((p) => PopupMenuItem(
                  value: p,
                  child: Text(p.label),
                ))
            .toList(),
        child: Row(
          children: [
            Text(provider.selectedPeriod.label, style: TextStyle(fontSize: 11.sp, color: colorScheme.onSurfaceVariant)),
            Icon(Icons.keyboard_arrow_down, size: 14.sp, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(label, style: TextStyle(fontSize: 10.sp, color: colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildDonutLegend(BuildContext context, ReportProvider provider) {
    final List<Color> colors = [
      AppColors.success,
      AppColors.info,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];
    
    final activeCats = provider.categories.where((c) => c['value'] > 0).toList();

    return Wrap(
      spacing: 12.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.center,
      children: List.generate(activeCats.length, (i) {
          return _buildLegendItem(context, activeCats[i]['label'], colors[i % colors.length]);
      }),
    );
  }

  Widget _buildProductListItem(BuildContext context, String name, String sold, String revenue) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          SizedBox(
            width: 40.w,
            child: Text(sold, textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp)),
          ),
          SizedBox(
            width: 80.w,
            child: Text(revenue, textAlign: TextAlign.right, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 12.w,
            height: 4.h,
            decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(2.r)),
          ),
        ],
      ),
    );
  }
}
