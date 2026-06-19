import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/utils/theme/app_constants/colors.dart';
import 'package:shelfo/widgets/reports/inventory_tab.dart';
import 'package:shelfo/widgets/reports/overview_tab.dart';
import 'package:shelfo/widgets/reports/profit_tab.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';

import '../../provider/reports/report_provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final reportProvider = context.watch<ReportProvider>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: SFOHeader(
          title: "Reports & Analysis",
          actions: [
            _buildPeriodDropdown(context, reportProvider),
            SizedBox(width: 16.w),
          ],
        ),
        body: SFOBackground(
          child: SFOResponsive(
            mobile: _buildContent(context, theme, colorScheme, 16.w),
            desktop: _buildContent(context, theme, colorScheme, 32.w, isLarge: true),
          ),
        ),
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
        onSelected: (period) async {
          if (period == ReportPeriod.custom) {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              initialDateRange: provider.customRange,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: AppColors.primary,
                        ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              provider.setCustomRange(picked);
            }
          } else {
            provider.setPeriod(period);
          }
        },
        itemBuilder: (context) => ReportPeriod.values
            .map((p) => PopupMenuItem(
                  value: p,
                  child: Text(p.label),
                ))
            .toList(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              provider.selectedPeriod == ReportPeriod.custom && provider.customRange != null
                  ? "${DateFormat('MMM dd').format(provider.customRange!.start)} - ${DateFormat('MMM dd').format(provider.customRange!.end)}"
                  : provider.selectedPeriod.label,
              style: TextStyle(fontSize: 11.sp, color: colorScheme.onSurfaceVariant),
            ),
            Icon(Icons.keyboard_arrow_down, size: 14.sp, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    double horizontalPadding, {
    bool isLarge = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: isLarge ? const BoxConstraints(maxWidth: 600) : null,
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  dividerColor: Colors.transparent,
                  labelColor: colorScheme.primary,
                  unselectedLabelColor: colorScheme.onSurfaceVariant,
                  labelStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: "Overview"),
                    Tab(text: "Profit"),
                    Tab(text: "Inventory"),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              OverviewTab(),
              ProfitTab(),
              InventoryTab(),
            ],
          ),
        ),
      ],
    );
  }
}
