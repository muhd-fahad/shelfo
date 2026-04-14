import 'package:flutter/material.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_divider.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_switch_tile.dart';
import 'package:shelfo/widgets/sfo_common/sfo_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Settings",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Configure your store preferences",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              const SFOSectionHeader(title: "General"),
              const SizedBox(height: 12),
              SFOCard(children: [
                SFOTile(
                  icon: Icons.store_outlined,
                  title: "Business Information",
                  subtitle: "Store name, address, currency",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.businessDetails);
                  },
                ),
                const SFODivider(),
                SFOTile(
                  icon: Icons.category_outlined,
                  title: "Product Categories",
                  subtitle: "Manage inventory categories",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.categoriesSettings);
                  },
                ),
                const SFODivider(),
                SFOTile(
                  icon: Icons.receipt_long_outlined,
                  title: "Tax & Invoice",
                  subtitle: "Tax rates, invoice numbering",
                  onTap: () {},
                ),
                const SFODivider(),
                SFOTile(
                  icon: Icons.history_outlined,
                  title: "Sales History",
                  onTap: () {},
                ),
                const SFODivider(),
                SFOTile(
                  icon: Icons.bar_chart_outlined,
                  title: "Reports & Analysis",
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 32),
              const SFOSectionHeader(title: "Module Configuration"),
              const SizedBox(height: 12),
              SFOCard(children: [
                SFOSwitchTile(
                  title: "POS Terminal",
                  subtitle: "Enable Point of Sale interface for fast billing",
                  value: true,
                  onChanged: (v) {},
                ),
                const SFODivider(),
                SFOSwitchTile(
                  title: "Service & Repairs",
                  subtitle: "Track repair jobs, technicians, and service history",
                  value: true,
                  onChanged: (v) {},
                ),
                const SFODivider(),
                SFOSwitchTile(
                  title: "Warranty Management",
                  subtitle: "Track product warranties and policies",
                  value: true,
                  onChanged: (v) {},
                ),
                const SFODivider(),
                SFOSwitchTile(
                  title: "Loyalty Program",
                  subtitle: "Enable customer points and rewards",
                  value: true,
                  onChanged: (v) {},
                ),
                const SFODivider(),
                SFOSwitchTile(
                  title: "Multi-Warehouse",
                  subtitle: "Manage stock across multiple locations",
                  value: false,
                  onChanged: (v) {},
                ),
              ]),

              const SizedBox(height: 32),
              const SFOSectionHeader(title: "System"),
              const SizedBox(height: 12),
              SFOCard(children: [
                SFOTile(
                  icon: Icons.storage_outlined,
                  title: "Backup & Restore",
                  subtitle: "Export data, import backups",
                  onTap: () {},
                ),
                const SFODivider(),
                SFOTile(
                  icon: Icons.settings_suggest_outlined,
                  title: "App Preferences",
                  subtitle: "Theme, language, sounds",
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
