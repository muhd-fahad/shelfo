import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_divider.dart';

import '../../provider/reports/report_provider.dart';

class ProfitTab extends StatelessWidget {
  const ProfitTab({super.key});

  @override
  Widget build(BuildContext context) {
    final reportProvider = context.watch<ReportProvider>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfitMarginHero(reportProvider: reportProvider),
          SizedBox(height: AppSpacing.lg),
          _ProfitSummaryRow(reportProvider: reportProvider),
          SizedBox(height: AppSpacing.lg),
          const _ProductProfitabilityHeader(),
          SizedBox(height: AppSpacing.md),
          _ProductProfitabilityTable(reportProvider: reportProvider),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _ProfitMarginHero extends StatelessWidget {
  final ReportProvider reportProvider;

  const _ProfitMarginHero({required this.reportProvider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.xl,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Net Profit Margin",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.trending_up, color: AppColors.white.withValues(alpha: 0.8), size: 20.sp),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            reportProvider.netProfitMargin,
            style: theme.textTheme.displaySmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: AppRadius.pill,
            ),
            child: Text(
              "Based on ${reportProvider.totalRevenue} revenue",
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfitSummaryRow extends StatelessWidget {
  final ReportProvider reportProvider;

  const _ProfitSummaryRow({required this.reportProvider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: "Cost of Goods",
            value: reportProvider.costOfGoods,
            icon: Icons.shopping_bag_outlined,
            color: AppColors.info,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _SummaryCard(
            title: "Expenses",
            value: reportProvider.operatingExpenses,
            icon: Icons.account_balance_wallet_outlined,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SFOCard(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14.sp, color: color),
            ),
            SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle != null) ...[
          SizedBox(height: 2.h),
          Text(
            subtitle!,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 9.sp,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProductProfitabilityHeader extends StatelessWidget {
  const _ProductProfitabilityHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Product Profitability",
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}

class _ProductProfitabilityTable extends StatelessWidget {
  final ReportProvider reportProvider;

  const _ProductProfitabilityTable({required this.reportProvider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final products = reportProvider.profitProducts;

    return SFOCard(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 12.r),
          child: Row(
            children: [
              SizedBox(width: 32.r + 12.w),
              Expanded(
                child: Text(
                  "Product",
                  style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 65.w,
                child: Text(
                  "Cost",
                  textAlign: TextAlign.right,
                  style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                width: 65.w,
                child: Text(
                  "Selling",
                  textAlign: TextAlign.right,
                  style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SFODivider(),
        if (products.isEmpty)
          Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: Text(
                "No products found",
                style: theme.textTheme.bodyMedium,
              ),
            ),
          )
        else
          ...products.asMap().entries.map((entry) {
            final product = entry.value;
            final isLast = entry.key == products.length - 1;
            return Column(
              children: [
                _ProfitProductItem(
                  name: product['name'],
                  sku: product['sku'],
                  cost: product['cost'],
                  selling: product['selling'],
                ),
                if (!isLast) const SFODivider(),
              ],
            );
          }),
      ],
    );
  }
}

class _ProfitProductItem extends StatelessWidget {
  final String name;
  final String sku;
  final String cost;
  final String selling;

  const _ProfitProductItem({
    required this.name,
    required this.sku,
    required this.cost,
    required this.selling,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: AppRadius.sm,
            ),
            child: Icon(Icons.inventory_2_outlined, size: 16.sp, color: colorScheme.onSurfaceVariant),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  sku,
                  style: theme.textTheme.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 65.w,
            child: Text(
              cost,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall,
            ),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 65.w,
            child: Text(
              selling,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
