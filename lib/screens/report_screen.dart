import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shelfo/utils/theme/app_constants/colors.dart';
import 'package:shelfo/utils/theme/app_constants/spacing.dart';
import 'package:shelfo/widgets/reports/inventory_tab.dart';
import 'package:shelfo/widgets/reports/overview_tab.dart';
import 'package:shelfo/widgets/reports/profit_tab.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const SFOHeader(title: "Reports & Analysis"),
        body: SFOBackground(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
              const Expanded(
                child: TabBarView(
                  children: [
                    OverviewTab(),
                    ProfitTab(),
                    InventoryTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
