import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/service_job/service_job_model.dart';
import '../../provider/service_job_provider.dart';
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
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                        provider.setFilterStatus(null);
                        Navigator.pop(context);
                      },
                      child: const Text("Clear All", style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                Text("Status", 
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold, 
                    color: colorScheme.onSurfaceVariant
                  )
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SFOChip(
                      label: "All",
                      isSelected: provider.filterStatus == null,
                      onSelected: (val) => provider.setFilterStatus(null),
                    ),
                    ...ServiceJobStatus.values.map((status) => SFOChip(
                      label: _getStatusLabel(status),
                      isSelected: provider.filterStatus == status,
                      onSelected: (val) => provider.setFilterStatus(status),
                    )),
                  ],
                ),

                const SizedBox(height: 40),
                SFOButton(
                  text: "Apply Filter",
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 16),
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
