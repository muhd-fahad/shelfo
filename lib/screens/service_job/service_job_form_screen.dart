import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/service_job/service_job_model.dart';
import 'package:shelfo/provider/service_job_provider.dart';
import 'package:shelfo/provider/customer_provider.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_dropdown.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';

class ServiceJobFormScreen extends StatefulWidget {
  final ServiceJob? job;
  const ServiceJobFormScreen({super.key, this.job});

  @override
  State<ServiceJobFormScreen> createState() => _ServiceJobFormScreenState();
}

class _ServiceJobFormScreenState extends State<ServiceJobFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late String _customerName;
  late String _deviceName;
  late String _deviceType;
  late String _brand;
  late String _serialNumber;
  late String _reportedIssue;
  late ServiceJobPriority _priority;
  late ServiceJobStatus _status;
  late double _laborCost;
  late List<double> _partsCosts;
  late bool _isWarranty;

  @override
  void initState() {
    super.initState();
    final job = widget.job;
    _customerName = job?.customerName ?? "";
    _deviceName = job?.deviceName ?? "";
    _deviceType = job?.deviceType ?? "Phone";
    _brand = job?.brand ?? "";
    _serialNumber = job?.serialNumber ?? "";
    _reportedIssue = job?.reportedIssue ?? "";
    _priority = job?.priority ?? ServiceJobPriority.normal;
    _status = job?.status ?? ServiceJobStatus.received;
    _laborCost = job?.laborCost ?? 0.0;
    _partsCosts = job?.partsCosts != null ? List.from(job!.partsCosts) : [0.0];
    _isWarranty = job?.isWarranty ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<CustomerProvider>();
    final jobProvider = context.read<ServiceJobProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? "New Service Job" : "Edit Job"),
      ),
      body: SFOBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SFOCard(
              padding: const EdgeInsets.all(20),
              children: [
                const SFOSectionHeader(title: "Customer"),
                const SizedBox(height: 12),
                SFODropdown<String>(
                  value: _customerName.isEmpty ? null : _customerName,
                  hint: "Select a customer...",
                  label: "Select Customer",
                  items: customerProvider.customers.map((c) => DropdownMenuItem(
                    value: c.name,
                    child: Text(c.name),
                  )).toList(),
                  onChanged: (val) => setState(() => _customerName = val ?? ""),
                ),

                const SizedBox(height: 24),
                const SFOSectionHeader(title: "Device Details"),
                const SizedBox(height: 12),
                SFOInputField(
                  label: "Device Name",
                  hint: "e.g. iPhone 13 Pro",
                  isRequired: true,
                  initialValue: _deviceName,
                  onChanged: (val) => _deviceName = val,
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 16),
                SFODropdown<String>(
                  label: "Type",
                  value: _deviceType,
                  items: const [
                    DropdownMenuItem(value: "Phone", child: Text("Phone")),
                    DropdownMenuItem(value: "Laptop", child: Text("Laptop")),
                    DropdownMenuItem(value: "Tablet", child: Text("Tablet")),
                    DropdownMenuItem(value: "Audio", child: Text("Audio")),
                    DropdownMenuItem(value: "Other", child: Text("Other")),
                  ],
                  onChanged: (val) => setState(() => _deviceType = val!),
                ),
                const SizedBox(height: 16),
                SFOInputField(
                  label: "Brand",
                  hint: "Apple, Samsung...",
                  initialValue: _brand,
                  onChanged: (val) => _brand = val,
                ),
                const SizedBox(height: 16),
                SFOInputField(
                  label: "Serial Number",
                  hint: "e.g. SN123456",
                  initialValue: _serialNumber,
                  onChanged: (val) => _serialNumber = val,
                ),

                const SizedBox(height: 24),
                const SFOSectionHeader(title: "Diagnosis & Status"),
                const SizedBox(height: 12),
                SFOInputField(
                  label: "Reported Issue",
                  hint: "Describe the problem...",
                  isRequired: true,
                  maxLines: 3,
                  initialValue: _reportedIssue,
                  onChanged: (val) => _reportedIssue = val,
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 16),
                SFODropdown<ServiceJobPriority>(
                  label: "Priority",
                  value: _priority,
                  items: const [
                    DropdownMenuItem(value: ServiceJobPriority.low, child: Text("Low")),
                    DropdownMenuItem(value: ServiceJobPriority.normal, child: Text("Normal")),
                    DropdownMenuItem(value: ServiceJobPriority.high, child: Text("High")),
                  ],
                  onChanged: (val) => setState(() => _priority = val!),
                ),
                const SizedBox(height: 16),
                SFODropdown<ServiceJobStatus>(
                  label: "Status",
                  value: _status,
                  items: ServiceJobStatus.values.map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(_getStatusLabel(s)),
                  )).toList(),
                  onChanged: (val) => setState(() => _status = val!),
                ),

                const SizedBox(height: 24),
                const SFOSectionHeader(title: "Costs"),
                const SizedBox(height: 12),
                SFOInputField(
                  label: "Labor Cost",
                  hint: "0",
                  keyboardType: TextInputType.number,
                  initialValue: _laborCost.toString(),
                  onChanged: (val) => _laborCost = double.tryParse(val) ?? 0.0,
                ),
                const SizedBox(height: 16),
                ..._partsCosts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final value = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SFOInputField(
                            label: index == 0 ? "Parts Cost" : "",
                            hint: "0",
                            keyboardType: TextInputType.number,
                            initialValue: value.toString(),
                            onChanged: (val) => _partsCosts[index] = double.tryParse(val) ?? 0.0,
                          ),
                        ),
                        if (index > 0) IconButton(
                          onPressed: () => setState(() => _partsCosts.removeAt(index)),
                          icon: const Icon(Icons.close, color: AppColors.error, size: 20),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () => setState(() => _partsCosts.add(0.0)),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("Add Part Cost"),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),

                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _isWarranty,
                  onChanged: (val) => setState(() => _isWarranty = val!),
                  title: Text(
                    "Apply Warranty (Zero charge to customer)",
                    style: theme.textTheme.bodySmall,
                  ),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primary,
                ),

                const SizedBox(height: 32),
                SFOButton(
                  text: widget.job == null ? "Create Job" : "Save Changes",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_customerName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select a customer")),
                        );
                        return;
                      }

                      final job = widget.job?.copyWith(
                        customerName: _customerName,
                        deviceName: _deviceName,
                        deviceType: _deviceType,
                        brand: _brand,
                        serialNumber: _serialNumber,
                        reportedIssue: _reportedIssue,
                        priority: _priority,
                        status: _status,
                        laborCost: _laborCost,
                        partsCosts: _partsCosts,
                        isWarranty: _isWarranty,
                      ) ?? ServiceJob(
                        id: jobProvider.getNextJobId(),
                        customerName: _customerName,
                        deviceName: _deviceName,
                        deviceType: _deviceType,
                        brand: _brand,
                        serialNumber: _serialNumber,
                        reportedIssue: _reportedIssue,
                        diagnosis: "Pending",
                        priority: _priority,
                        status: _status,
                        laborCost: _laborCost,
                        partsCosts: _partsCosts,
                        isWarranty: _isWarranty,
                        dueDate: DateTime.now().add(const Duration(days: 3)),
                        createdAt: DateTime.now(),
                      );

                      if (widget.job == null) {
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
