import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/sale/sales_order_model.dart';
import '../../provider/sales_order_provider.dart';
import '../../utils/theme/theme.dart';
import '../sfo_common/sfo_button.dart';
import '../sfo_common/sfo_input_field.dart';
import '../sfo_common/sfo_chip.dart';

class SalesOrderFilterSheet extends StatelessWidget {
  const SalesOrderFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final orderProvider = context.watch<SalesOrderProvider>();

    final firstDate = DateTime(2020);
    final lastDate = DateTime(2100);

    return Container(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 24.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter Orders",
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    orderProvider.clearFilters();
                    Navigator.pop(context);
                  },
                  child: const Text("Clear All", style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            _buildSectionTitle(theme, colorScheme, "Status"),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: SalesOrderStatus.values.map((status) => SFOChip(
                label: status.name[0].toUpperCase() + status.name.substring(1),
                isSelected: orderProvider.statusFilter == status,
                onSelected: (val) => orderProvider.setStatusFilter(status),
              )).toList(),
            ),
            SizedBox(height: 24.h),

            _buildSectionTitle(theme, colorScheme, "Date Range"),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      DateTime initialDate = orderProvider.startDate ?? DateTime.now();
                      if (initialDate.isBefore(firstDate)) initialDate = firstDate;
                      if (initialDate.isAfter(lastDate)) initialDate = lastDate;

                      final date = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: firstDate,
                        lastDate: lastDate,
                      );
                      if (date != null) {
                        orderProvider.setDateRange(date, orderProvider.endDate);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.outline),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16.r, color: colorScheme.primary),
                          SizedBox(width: 8.w),
                          Text(
                            orderProvider.startDate != null 
                              ? DateFormat('MMM dd, yyyy').format(orderProvider.startDate!)
                              : "Start Date",
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      DateTime initialDate = orderProvider.endDate ?? DateTime.now();
                      if (initialDate.isBefore(firstDate)) initialDate = firstDate;
                      if (initialDate.isAfter(lastDate)) initialDate = lastDate;

                      final date = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: firstDate,
                        lastDate: lastDate,
                      );
                      if (date != null) {
                        orderProvider.setDateRange(orderProvider.startDate, date);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.outline),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16.r, color: colorScheme.primary),
                          SizedBox(width: 8.w),
                          Text(
                            orderProvider.endDate != null 
                              ? DateFormat('MMM dd, yyyy').format(orderProvider.endDate!)
                              : "End Date",
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            _buildSectionTitle(theme, colorScheme, "Amount Range"),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: SFOInputField(
                    label: "Min Amount",
                    hint: "0",
                    controller: orderProvider.minAmountController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: SFOInputField(
                    label: "Max Amount",
                    hint: "99999",
                    controller: orderProvider.maxAmountController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            SizedBox(height: 40.h),
            SFOButton(
              text: "Apply Filter",
              onPressed: () {
                orderProvider.applyAdvancedFilters();
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, ColorScheme colorScheme, String title) {
    return Text(title, 
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.bold, 
        color: colorScheme.onSurfaceVariant
      )
    );
  }
}
