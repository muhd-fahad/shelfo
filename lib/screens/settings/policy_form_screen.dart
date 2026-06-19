import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';
import '../../provider/policy/policy_form_provider.dart';
import '../../provider/policy/policy_provider.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import '../../widgets/sfo_common/sfo_background.dart';
import '../../widgets/sfo_common/sfo_input_field.dart';
import '../../widgets/sfo_common/sfo_dropdown.dart';
import '../../utils/theme/theme.dart';
import '../../models/policy/policy_model.dart';

class PolicyFormScreen extends StatelessWidget {
  final Policy? policy;

  const PolicyFormScreen({super.key, this.policy});

  @override
  Widget build(BuildContext context) {
    final formProvider = context.watch<PolicyFormProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: SFOHeader(
        title: policy == null ? "New Policy" : "Edit Policy",
      ),
      body: SFOBackground(
        child: SFOResponsive(
          mobile: _buildForm(context, formProvider, theme),
          desktop: SFOResponsive.constrained(_buildForm(context, formProvider, theme)),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, PolicyFormProvider formProvider, ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: ShapeDecoration(
          color: theme.cardTheme.color,
          shape: theme.cardTheme.shape!,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SFOInputField(
              label: "Policy Name",
              hint: "e.g. Standard 1-Year Warranty",
              controller: formProvider.nameController,
            ),
            SizedBox(height: 16.h),
            SFODropdown<PolicyType>(
              label: "Type",
              value: formProvider.selectedType,
              items: PolicyType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.label),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) formProvider.setType(value);
              },
            ),
            SizedBox(height: 16.h),
            SFOInputField(
              label: "Duration (Days)",
              hint: "30",
              controller: formProvider.durationController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.h),
            SFOInputField(
              label: "Description",
              hint: "Brief description of what this policy covers...",
              controller: formProvider.descriptionController,
              maxLines: 4,
            ),
            SizedBox(height: 24.h),
            Text(
              "Conditions",
              style: theme.textTheme.titleSmall,
            ),
            SizedBox(height: 12.h),
            ...List.generate(formProvider.conditionControllers.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  children: [
                    Expanded(
                      child: SFOInputField(
                        label: "Condition ${index + 1}",
                        hint: "Enter condition...",
                        controller: formProvider.conditionControllers[index],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: IconButton(
                        onPressed: () => formProvider.removeCondition(index),
                        icon: const Icon(Icons.close, color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: formProvider.addCondition,
              icon: const Icon(Icons.add),
              label: const Text("Add Condition"),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Switch(
                  value: formProvider.isActive,
                  onChanged: formProvider.toggleActive,
                ),
                SizedBox(width: 12.w),
                const Text("Policy Active"),
              ],
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final newPolicy = Policy(
                    id: policy?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    name: formProvider.nameController.text,
                    type: formProvider.selectedType,
                    durationDays: int.tryParse(formProvider.durationController.text) ?? 30,
                    description: formProvider.descriptionController.text,
                    conditions: formProvider.conditionControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
                    isActive: formProvider.isActive,
                    createdAt: policy?.createdAt ?? DateTime.now(),
                  );

                  if (policy == null) {
                    await context.read<PolicyProvider>().addPolicy(newPolicy);
                  } else {
                    await context.read<PolicyProvider>().updatePolicy(newPolicy);
                  }
                  navigator.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkSurface,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: Text(policy == null ? "Create Policy" : "Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
