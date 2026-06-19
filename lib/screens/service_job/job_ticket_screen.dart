import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/service_job/service_job_model.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_badge.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_search_bar.dart';
import 'package:shelfo/widgets/sfo_common/sfo_chip.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/widgets/service_job/service_job_filter_sheet.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';

import '../../provider/business/business_provider.dart';
import '../../provider/service_job/service_job_provider.dart';

class JobTicketScreen extends StatelessWidget {
  const JobTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceJobProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const SFOHeader(
        title: "Service Jobs",
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.serviceJobForm),
        label: const Text("New Job"),
        icon: const Icon(Icons.add),
      ),
      body: SFOBackground(
        child: SFOResponsive(
          mobile: _buildContent(context, provider, theme, 1, 16.w),
          tablet: _buildContent(context, provider, theme, 2, 32.w),
          desktop: _buildContent(context, provider, theme, 3, 32.w),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ServiceJobProvider provider,
    ThemeData theme,
    int crossAxisCount,
    double horizontalPadding,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8.h),
          child: SFOSearchBar(
            hintText: "Search jobs, devices, or customers...",
            onChanged: (val) => provider.setSearchQuery(val),
            onFilterTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                ),
                builder: (context) => const ServiceJobFilterSheet(),
              );
            },
          ),
        ),
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.brightness == Brightness.dark ? theme.colorScheme.outlineVariant : AppColors.borderLight,
              ),
            ),
          ),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 4.h),
            scrollDirection: Axis.horizontal,
            itemCount: ServiceJobStatus.values.length + 1,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final isAll = index == 0;
              final status = isAll ? null : ServiceJobStatus.values[index - 1];
              final label = isAll ? "All" : _getStatusLabel(status!);
              final isSelected = isAll ? provider.filterStatuses.isEmpty : provider.filterStatuses.contains(status);

              return Center(
                child: SFOChip(
                  label: label,
                  isSelected: isSelected,
                  onSelected: (val) => provider.toggleFilterStatus(status),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: provider.jobs.isEmpty
              ? Center(
                  child: Text(
                    "No jobs found",
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : crossAxisCount > 1
                  ? GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16.h,
                        crossAxisSpacing: 16.w,
                        mainAxisExtent: 260.h,
                      ),
                      itemCount: provider.jobs.length,
                      itemBuilder: (context, index) {
                        final job = provider.jobs[index];
                        return _JobCard(job: job);
                      },
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      itemCount: provider.jobs.length,
                      itemBuilder: (context, index) {
                        final job = provider.jobs[index];
                        return _JobCard(job: job);
                      },
                    ),
        ),
      ],
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

class _JobCard extends StatelessWidget {
  final ServiceJob job;

  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = context.watch<BusinessProvider>().selectedCurrency;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context, 
        AppRoutes.serviceJobDetails,
        arguments: job,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: SFOCard(
          padding: EdgeInsets.all(16.r),
          children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: AppRadius.md,
                ),
                child: Center(
                  child: Icon(_getDeviceIcon(job.deviceType), size: 24.r, color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.deviceName,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      job.id,
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              SFOBadge(
                label: _getStatusLabel(job.status),
                bgColor: _getStatusColor(job.status).withValues(alpha: 0.1),
                textColor: _getStatusColor(job.status),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _InfoRow(icon: Icons.person_outline, text: job.customerName),
          SizedBox(height: 8.h),
          _InfoRow(icon: Icons.error_outline, text: job.reportedIssue),
          SizedBox(height: 8.h),
          _InfoRow(icon: Icons.calendar_today_outlined, text: "Due: ${_formatDate(job.dueDate)}"),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SFOBadge(
                label: "${_getPriorityLabel(job.priority)} Priority",
                bgColor: _getPriorityColor(job.priority).withValues(alpha: 0.05),
                textColor: _getPriorityColor(job.priority),
              ),
              Text(
                CurrencyFormatter.format(job.totalCost, currency),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
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

  String _getPriorityLabel(ServiceJobPriority priority) {
    switch (priority) {
      case ServiceJobPriority.low: return "Low";
      case ServiceJobPriority.normal: return "Normal";
      case ServiceJobPriority.high: return "High";
    }
  }

  Color _getPriorityColor(ServiceJobPriority priority) {
    switch (priority) {
      case ServiceJobPriority.low: return Colors.blue;
      case ServiceJobPriority.normal: return Colors.indigo;
      case ServiceJobPriority.high: return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18.r, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
