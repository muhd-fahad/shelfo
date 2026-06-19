import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/utils/theme/app_constants/spacing.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_divider.dart';

import '../../provider/reports/report_provider.dart';

class ProfitTab extends StatelessWidget {
  const ProfitTab({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<ReportProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Net Profit Margin",
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  reportProvider.netProfitMargin,
                  style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Based on ${reportProvider.totalRevenue} revenue",
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),
          SFOCard(
            padding: EdgeInsets.all(16.r),
            children: [
              Text(
                "Total Cost of Goods",
                style: theme.textTheme.labelSmall,
              ),
              SizedBox(height: 4.h),
              Text(
                reportProvider.costOfGoods,
                style: theme.textTheme.headlineSmall,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          SFOCard(
            padding: EdgeInsets.all(16.r),
            children: [
              Text(
                "Operating Expenses",
                style: theme.textTheme.labelSmall,
              ),
              SizedBox(height: 4.h),
              Text(
                reportProvider.operatingExpenses,
                style: theme.textTheme.headlineSmall,
              ),
              SizedBox(height: 4.h),
              Text(
                reportProvider.operatingExpenses == "₹ 0" ? "No expenses recorded" : "Total expenses for period",
                style: theme.textTheme.labelSmall?.copyWith(fontSize: 10.sp),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          SFOCard(
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  children: [
                    Expanded(child: Text("Product", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold))),
                    Text("Cost\nPrice", textAlign: TextAlign.center, style: TextStyle(fontSize: 10.sp, color: colorScheme.onSurfaceVariant)),
                    SizedBox(width: 24.w),
                    Text("Selling\nPrice", textAlign: TextAlign.center, style: TextStyle(fontSize: 10.sp, color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              const SFODivider(),
              ...reportProvider.profitProducts.expand((product) => [
                _buildProfitProductItem(context, product['name'], product['sku'], product['cost'], product['selling']),
                if (reportProvider.profitProducts.last != product) const SFODivider(),
              ]),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildProfitProductItem(BuildContext context, String name, String sku, String cost, String selling) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.image_outlined, size: 16.sp, color: colorScheme.onSurfaceVariant),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
                Text(sku, style: TextStyle(fontSize: 10.sp, color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Text(cost, style: TextStyle(fontSize: 12.sp)),
          SizedBox(width: 24.w),
          Text(selling, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
