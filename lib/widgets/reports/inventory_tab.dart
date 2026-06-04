import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/report_provider.dart';
import 'package:shelfo/utils/theme/app_constants/spacing.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_divider.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';

class InventoryTab extends StatelessWidget {
  const InventoryTab({super.key});

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
          ...reportProvider.inventoryStats.map((stat) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: _buildInventoryStatCard(context, stat['title'], stat['value'], stat['icon'], stat['color']),
          )),
          SizedBox(height: AppSpacing.lg),
          const SFOSectionHeader(title: "Inventory Health Check"),
          SizedBox(height: AppSpacing.sm),
          Text("Low Stock Alerts", style: theme.textTheme.bodySmall),
          SizedBox(height: AppSpacing.md),
          SFOCard(
            children: reportProvider.lowStockItems.isEmpty 
              ? [const Padding(padding: EdgeInsets.all(24), child: Center(child: Text("No low stock alerts")))]
              : reportProvider.lowStockItems.expand((item) => [
              _buildLowStockItem(context, item['name'], item['status'], item['subtitle'], item['color']),
              if (reportProvider.lowStockItems.last != item) const SFODivider(),
            ]).toList(),
          ),
          SizedBox(height: AppSpacing.lg),
          const SFOSectionHeader(title: "Category Distribution"),
          SizedBox(height: AppSpacing.md),
          SFOCard(
            padding: EdgeInsets.all(16.r),
            children: reportProvider.categories.isEmpty
              ? [const Center(child: Text("No categories found"))]
              : reportProvider.categories.expand((cat) => [
              _buildCategoryProgress(context, cat['label'], cat['value'] / (reportProvider.totalItems == 0 ? 1 : reportProvider.totalItems), cat['count'], colorScheme.primary),
              if (reportProvider.categories.last != cat) SizedBox(height: 12.h),
            ]).toList(),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildInventoryStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final colorScheme = Theme.of(context).colorScheme;
    return SFOCard(
      padding: EdgeInsets.all(16.r),
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 11.sp, color: colorScheme.onSurfaceVariant)),
                Text(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLowStockItem(BuildContext context, String name, String status, String subtitle, Color statusColor) {
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
            child: Icon(Icons.inventory_2_outlined, size: 16.sp, color: colorScheme.onSurfaceVariant),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
                Text(subtitle, style: TextStyle(fontSize: 10.sp, color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Text(
            status,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: statusColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryProgress(BuildContext context, String label, double value, String count, Color color) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 11.sp, color: colorScheme.onSurfaceVariant)),
            Text(count, style: TextStyle(fontSize: 11.sp, color: colorScheme.onSurfaceVariant)),
          ],
        ),
        SizedBox(height: 4.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: colorScheme.surface,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6.h,
          ),
        ),
      ],
    );
  }
}
