import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/service_job/service_job_model.dart';
import '../../provider/service_job/service_job_provider.dart';
import '../../utils/theme/theme.dart';
import '../sfo_common/sfo_button.dart';
import '../sfo_common/sfo_chip.dart';

class ServiceJobFilterSheet extends StatelessWidget {
  const ServiceJobFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<ServiceJobProvider>(
      builder: (context, provider, child) {
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
                      "Filter Jobs",
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        provider.toggleFilterStatus(null);
                        Navigator.pop(context);
                      },
                      child: const Text("Clear All", style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                
                Text("Status", 
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold, 
                    color: colorScheme.onSurfaceVariant
                  )
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    SFOChip(
                      label: "All",
                      isSelected: provider.filterStatuses.isEmpty,
                      onSelected: (val) => provider.toggleFilterStatus(null),
                    ),
                    ...ServiceJobStatus.values.map((status) => SFOChip(
                      label: _getStatusLabel(status),
                      isSelected: provider.filterStatuses.contains(status),
                      onSelected: (val) => provider.toggleFilterStatus(status),
                    )),
                  ],
                ),

                SizedBox(height: 40.h),
                SFOButton(
                  text: "Apply Filter",
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStatusLabel(ServiceJobStatus status) {
    switch (status) {
      case ServiceJobStatus.received: return "Received";
      case ServiceJobStatus.diagnosing: return "Diagnosing";
      case ServiceJobStatus.inRepair: return "In Repair";
      case ServiceJobStatus.ready: return "Ready";
      case ServiceJobStatus.completed: return "Completed";
      case ServiceJobStatus.cancelled: return "Cancelled";
    }
  }
}
