import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/policy/policy_form_provider.dart';
import '../../provider/policy/policy_provider.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import '../../widgets/sfo_common/sfo_background.dart';
import '../../widgets/sfo_common/sfo_section_header.dart';
import '../../widgets/settings/policy_card.dart';
import '../../utils/theme/theme.dart';
import '../../models/policy/policy_model.dart';
import 'policy_form_screen.dart';

class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final policyProvider = context.watch<PolicyProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: SFOHeader(
        title: "Policies & Warranties",
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<PolicyFormProvider>().init(null);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PolicyFormScreen()),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add Policy"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkSurface,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              ),
            ),
          ),
        ],
      ),
      body: SFOBackground(
        child: policyProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.all(16.r),
                children: [
                  Text(
                    "Manage your service terms and conditions",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildSection(context, "Warranty Policies", PolicyType.warranty),
                  SizedBox(height: 24.h),
                  _buildSection(context, "Return Policies", PolicyType.returnPolicy),
                  SizedBox(height: 24.h),
                  _buildSection(context, "Service Policies", PolicyType.service),
                  SizedBox(height: 40.h),
                ],
              ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, PolicyType type) {
    final policies = context.read<PolicyProvider>().getPoliciesByType(type);
    
    if (policies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SFOSectionHeader(title: title),
        SizedBox(height: 12.h),
        ...policies.map((policy) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: PolicyCard(
                policy: policy,
                onEdit: () {
                  context.read<PolicyFormProvider>().init(policy);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PolicyFormScreen(policy: policy),
                    ),
                  );
                },
                onDelete: () => _showDeleteDialog(context, policy),
              ),
            )),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, Policy policy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Policy"),
        content: Text("Are you sure you want to delete '${policy.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<PolicyProvider>().deletePolicy(policy.id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
