import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/service_job/service_job_model.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_badge.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';
import 'package:shelfo/screens/service_job/service_job_form_screen.dart';

import '../../provider/business/business_provider.dart';
import '../../provider/customer/customer_provider.dart';
import '../../provider/service_job/service_job_provider.dart';
import '../../widgets/sfo_common/sfo_header.dart';

class ServiceJobDetailsScreen extends StatelessWidget {
  const ServiceJobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final job = ModalRoute.of(context)!.settings.arguments as ServiceJob;
    final theme = Theme.of(context);
    final provider = context.watch<ServiceJobProvider>();
    final customerProvider = context.read<CustomerProvider>();
    final currency = context.watch<BusinessProvider>().selectedCurrency;

    // Refresh job data from provider in case it was updated
    final currentJob = provider.jobs.where((j) => j.id == job.id).firstOrNull ?? job;
    final customer = customerProvider.customers.where((c) => c.name == currentJob.customerName).firstOrNull;

    return Scaffold(
      appBar: SFOHeader(
        title: "Job Details",
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ServiceJobFormScreen(job: currentJob)),
            ),
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.edit_outlined, size: 20.r),
            ),
          ),
          IconButton(
            onPressed: () => _showDeleteDialog(context, provider, currentJob),
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.errorLight),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.delete_outline, size: 20.r, color: AppColors.error),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SFOBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              // Header Card
              SFOCard(
                padding: EdgeInsets.all(16.r),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56.r,
                        height: 56.r,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainer,
                          borderRadius: AppRadius.md,
                        ),
                        child: Icon(_getDeviceIcon(currentJob.deviceType), size: 28.r, color: theme.colorScheme.onSurfaceVariant),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(currentJob.deviceName, style: theme.textTheme.titleLarge),
                            Text("${currentJob.brand} • ${currentJob.serialNumber}", style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      SFOBadge(
                        label: _getStatusLabel(currentJob.status),
                        bgColor: _getStatusColor(currentJob.status).withValues(alpha: 0.1),
                        textColor: _getStatusColor(currentJob.status),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _StatusStepper(status: currentJob.status),
                  SizedBox(height: 24.h),
                  if (currentJob.status != ServiceJobStatus.completed && currentJob.status != ServiceJobStatus.cancelled)
                    SFOButton(
                      text: "Advance Status",
                      icon: Icons.arrow_forward,
                      onPressed: () => provider.advanceStatus(currentJob),
                      backgroundColor: const Color(0xFF1E293B),
                    ),
                ],
              ),
              SizedBox(height: 16.h),

              // Customer Details
              _DetailSection(
                title: "Customer Details",
                icon: Icons.person_outline,
                children: [
                  _InfoLabel(label: "Name", value: currentJob.customerName),
                  if (customer != null) _InfoLabel(label: "Phone", value: customer.phone ?? "N/A"),
                  _InfoLabel(label: "Received Date", value: _formatDate(currentJob.createdAt)),
                ],
              ),
              SizedBox(height: 16.h),

              // Job Info
              _DetailSection(
                title: "Job Info",
                icon: Icons.description_outlined,
                children: [
                  _InfoLabel(label: "Reported Issue", value: currentJob.reportedIssue),
                  _InfoLabel(label: "Diagnosis", value: currentJob.diagnosis),
                  _InfoLabel(label: "Assigned To", value: currentJob.assignedTo ?? "Unassigned"),
                ],
              ),
              SizedBox(height: 16.h),

              // Costs & Billing
              _DetailSection(
                title: "Costs & Billing",
                icon: Icons.payments_outlined,
                children: [
                  Row(
                    children: [
                      Expanded(child: _CostCard(label: "Labor", value: CurrencyFormatter.format(currentJob.laborCost, currency))),
                      SizedBox(width: 8.w),
                      Expanded(child: _CostCard(label: "Parts", value: CurrencyFormatter.format(currentJob.totalPartsCost, currency))),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _CostCard(
                          label: "Total", 
                          value: CurrencyFormatter.format(currentJob.totalCost, currency),
                          bgColor: AppColors.success.withValues(alpha: 0.05),
                          textColor: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  if (currentJob.isWarranty)
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.05),
                        borderRadius: AppRadius.md,
                        border: Border.all(color: AppColors.success.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: AppColors.success, size: 20.r),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              "Warranty Applied - Customer will not be charged",
                              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.success, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ServiceJobProvider provider, ServiceJob job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Job"),
        content: const Text("Are you sure you want to delete this service job? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final nav = Navigator.of(context);
              await provider.deleteJob(job.id);
              nav.pop(); // close dialog
              nav.pop(); // go back from details
            }, 
            child: const Text("Delete", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'phone': return Icons.smartphone;
      case 'laptop': return Icons.laptop_mac;
      case 'tablet': return Icons.tablet_android;
      case 'audio': return Icons.headphones;
      default: return Icons.devices_other;
    }
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

  Color _getStatusColor(ServiceJobStatus status) {
    switch (status) {
      case ServiceJobStatus.received: return Colors.blue;
      case ServiceJobStatus.diagnosing: return Colors.orange;
      case ServiceJobStatus.inRepair: return Colors.indigo;
      case ServiceJobStatus.ready: return AppColors.success;
      case ServiceJobStatus.completed: return AppColors.textSecondary;
      case ServiceJobStatus.cancelled: return AppColors.error;
    }
  }

  String _formatDate(DateTime date) {
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}

class _StatusStepper extends StatelessWidget {
  final ServiceJobStatus status;

  const _StatusStepper({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      ServiceJobStatus.received,
      ServiceJobStatus.diagnosing,
      ServiceJobStatus.inRepair,
      ServiceJobStatus.ready,
      ServiceJobStatus.completed,
    ];
    
    int currentIndex = steps.indexOf(status);
    if (currentIndex == -1 && status == ServiceJobStatus.cancelled) currentIndex = -1;

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          bool isCompleted = stepIndex < currentIndex || status == ServiceJobStatus.completed;
          bool isCurrent = stepIndex == currentIndex;

          return Container(
            width: 12.r,
            height: 12.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted || isCurrent ? AppColors.success : Colors.grey.withValues(alpha: 0.3),
              border: isCurrent ? Border.all(color: AppColors.success.withValues(alpha: 0.3), width: 4.r) : null,
            ),
          );
        } else {
          int lineIndex = index ~/ 2;
          bool isCompleted = lineIndex < currentIndex || status == ServiceJobStatus.completed;

          return Expanded(
            child: Container(
              height: 2.h,
              color: isCompleted ? AppColors.success : Colors.grey.withValues(alpha: 0.3),
            ),
          );
        }
      }),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _DetailSection({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return SFOCard(
      padding: EdgeInsets.all(16.r),
      children: [
        Row(
          children: [
            SFOSectionHeader(title: title),
          ],
        ),
        SizedBox(height: 16.h),
        ...children,
      ],
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLabel({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6))),
          SizedBox(height: 4.h),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _CostCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? bgColor;
  final Color? textColor;

  const _CostCard({required this.label, required this.value, this.bgColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: bgColor ?? theme.colorScheme.surface,
        borderRadius: AppRadius.md,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          SizedBox(height: 4.h),
          Text(
            value, 
            style: theme.textTheme.titleSmall?.copyWith(
              color: textColor ?? theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
