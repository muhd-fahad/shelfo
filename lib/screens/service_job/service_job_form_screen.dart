import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/service_job/service_job_model.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_dropdown.dart';
import 'package:shelfo/widgets/sfo_common/sfo_selection_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_bottom_sheet.dart';
import 'package:shelfo/widgets/customer/customer_selection_sheet.dart';
import 'package:shelfo/models/customer/customer_model.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';

import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';

import '../../provider/customer/customer_provider.dart';
import '../../provider/service_job/service_job_form_provider.dart';
import '../../provider/service_job/service_job_provider.dart';


class ServiceJobFormScreen extends StatelessWidget {
  final ServiceJob? job;
  const ServiceJobFormScreen({super.key, this.job});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceJobFormProvider(job),
      child: const _ServiceJobFormContent(),
    );
  }
}

class _ServiceJobFormContent extends StatelessWidget {
  const _ServiceJobFormContent();

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<CustomerProvider>();
    final jobProvider = context.read<ServiceJobProvider>();
    final formProvider = context.watch<ServiceJobFormProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: SFOHeader(
        title: formProvider.job == null ? "New Service Job" : "Edit Job",
      ),
      body: SFOBackground(
        child: SFOResponsive(
          mobile: _buildForm(context, customerProvider, jobProvider, formProvider, theme),
          desktop: SFOResponsive.constrained(_buildForm(context, customerProvider, jobProvider, formProvider, theme)),
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    CustomerProvider customerProvider,
    ServiceJobProvider jobProvider,
    ServiceJobFormProvider formProvider,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Form(
        key: formProvider.formKey,
        child: SFOCard(
          padding: EdgeInsets.all(20.r),
          children: [
            const SFOSectionHeader(title: "Customer"),
            SizedBox(height: 12.h),
            SFOSelectionField(
              label: "Select Customer",
              value: formProvider.customerName.isEmpty ? null : formProvider.customerName,
              hint: "Select a customer...",
              onTap: () async {
                final customer = await SFOBottomSheet.show<Customer>(
                  context,
                  title: "Select Customer",
                  child: const CustomerSelectionSheet(),
                );
                if (customer != null) {
                  formProvider.setCustomerName(customer.name);
                }
              },
            ),

            SizedBox(height: 24.h),
            const SFOSectionHeader(title: "Device Details"),
            SizedBox(height: 12.h),
            SFOInputField(
              label: "Device Name",
              hint: "e.g. iPhone 13 Pro",
              isRequired: true,
              initialValue: formProvider.deviceName,
              onChanged: (val) => formProvider.deviceName = val,
            ),
            SizedBox(height: 16.h),
            SFODropdown<String>(
              label: "Type",
              value: formProvider.deviceType,
              items: const [
                DropdownMenuItem(value: "Phone", child: Text("Phone")),
                DropdownMenuItem(value: "Laptop", child: Text("Laptop")),
                DropdownMenuItem(value: "Tablet", child: Text("Tablet")),
                DropdownMenuItem(value: "Audio", child: Text("Audio")),
                DropdownMenuItem(value: "Other", child: Text("Other")),
              ],
              onChanged: (val) => formProvider.setDeviceType(val!),
            ),
            SizedBox(height: 16.h),
            SFOInputField(
              label: "Brand",
              hint: "Apple, Samsung...",
              initialValue: formProvider.brand,
              onChanged: (val) => formProvider.brand = val,
            ),
            SizedBox(height: 16.h),
            SFOInputField(
              label: "Serial Number",
              hint: "e.g. SN123456",
              initialValue: formProvider.serialNumber,
              onChanged: (val) => formProvider.serialNumber = val,
            ),

            SizedBox(height: 24.h),
            const SFOSectionHeader(title: "Diagnosis & Status"),
            SizedBox(height: 12.h),
            SFOInputField(
              label: "Reported Issue",
              hint: "Describe the problem...",
              isRequired: true,
              maxLines: 3,
              initialValue: formProvider.reportedIssue,
              onChanged: (val) => formProvider.reportedIssue = val,
            ),
            SizedBox(height: 16.h),
            SFODropdown<ServiceJobPriority>(
              label: "Priority",
              value: formProvider.priority,
              items: const [
                DropdownMenuItem(value: ServiceJobPriority.low, child: Text("Low")),
                DropdownMenuItem(value: ServiceJobPriority.normal, child: Text("Normal")),
                DropdownMenuItem(value: ServiceJobPriority.high, child: Text("High")),
              ],
              onChanged: (val) => formProvider.setPriority(val!),
            ),
            SizedBox(height: 16.h),
            SFODropdown<ServiceJobStatus>(
              label: "Status",
              value: formProvider.status,
              items: ServiceJobStatus.values
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(_getStatusLabel(s)),
                      ))
                  .toList(),
              onChanged: (val) => formProvider.setStatus(val!),
            ),

            SizedBox(height: 24.h),
            const SFOSectionHeader(title: "Costs"),
            SizedBox(height: 12.h),
            SFOInputField(
              label: "Labor Cost",
              hint: "0",
              keyboardType: TextInputType.number,
              initialValue: formProvider.laborCost.toString(),
              onChanged: (val) => formProvider.setLaborCost(double.tryParse(val) ?? 0.0),
            ),
            SizedBox(height: 16.h),
            ...formProvider.partsCosts.asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: SFOInputField(
                        label: index == 0 ? "Parts Cost" : "",
                        hint: "0",
                        keyboardType: TextInputType.number,
                        initialValue: value.toString(),
                        onChanged: (val) => formProvider.setPartCost(index, double.tryParse(val) ?? 0.0),
                      ),
                    ),
                    if (index > 0)
                      IconButton(
                        onPressed: () => formProvider.removePartCost(index),
                        icon: Icon(Icons.close, color: AppColors.error, size: 20.r),
                      ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: () => formProvider.addPartCost(),
              icon: Icon(Icons.add, size: 16.r),
              label: const Text("Add Part Cost"),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),

            SizedBox(height: 16.h),
            CheckboxListTile(
              value: formProvider.isWarranty,
              onChanged: (val) => formProvider.setWarranty(val!),
              title: Text(
                "Apply Warranty (Zero charge to customer)",
                style: theme.textTheme.bodySmall,
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.primary,
            ),

            SizedBox(height: 32.h),
            SFOButton(
              text: formProvider.job == null ? "Create Job" : "Save Changes",
              onPressed: () async {
                if (formProvider.formKey.currentState!.validate()) {
                  if (formProvider.customerName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a customer")),
                    );
                    return;
                  }

                  final job = formProvider.job?.copyWith(
                        customerName: formProvider.customerName,
                        deviceName: formProvider.deviceName,
                        deviceType: formProvider.deviceType,
                        brand: formProvider.brand,
                        serialNumber: formProvider.serialNumber,
                        reportedIssue: formProvider.reportedIssue,
                        priority: formProvider.priority,
                        status: formProvider.status,
                        laborCost: formProvider.laborCost,
                        partsCosts: formProvider.partsCosts,
                        isWarranty: formProvider.isWarranty,
                      ) ??
                      ServiceJob(
                        id: jobProvider.getNextJobId(),
                        customerName: formProvider.customerName,
                        deviceName: formProvider.deviceName,
                        deviceType: formProvider.deviceType,
                        brand: formProvider.brand,
                        serialNumber: formProvider.serialNumber,
                        reportedIssue: formProvider.reportedIssue,
                        diagnosis: "Pending",
                        priority: formProvider.priority,
                        status: formProvider.status,
                        laborCost: formProvider.laborCost,
                        partsCosts: formProvider.partsCosts,
                        isWarranty: formProvider.isWarranty,
                        dueDate: DateTime.now().add(const Duration(days: 3)),
                        createdAt: DateTime.now(),
                      );

                  if (formProvider.job == null) {
                    await jobProvider.addJob(job);
                  } else {
                    await jobProvider.updateJob(job);
                  }
                  if (context.mounted) Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
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
