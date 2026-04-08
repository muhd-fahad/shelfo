import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';

import '../widgets/divider_widget.dart';
import '../widgets/section_header_widget.dart';
import '../widgets/settings/settings_switch_tile_widget.dart';
import '../widgets/settings/settings_card_widget.dart';
import '../widgets/settings/settings_list_tile_widget.dart';

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

              sectionHeaderWidget("General", isDark),
              const SizedBox(height: 12),
              settingsCardWidget([
                settingsListTile(
                  icon: Icons.store_outlined,
                  title: "Business Information",
                  subtitle: "Store name, address, currency",
                  isDark: isDark,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.businessDetails);
                  },
                ),
                dividerWidget(isDark),
                settingsListTile(
                  icon: Icons.receipt_long_outlined,
                  title: "Tax & Invoice",
                  subtitle: "Tax rates, invoice numbering",
                  isDark: isDark,
                  onTap: () {},
                ),
                dividerWidget(isDark),
                settingsListTile(
                  icon: Icons.history_outlined,
                  title: "Sales History",
                  isDark: isDark,
                  onTap: () {},
                ),
                dividerWidget(isDark),
                settingsListTile(
                  icon: Icons.bar_chart_outlined,
                  title: "Reports & Analysis",
                  isDark: isDark,
                  onTap: () {},
                ),
              ], isDark),

              const SizedBox(height: 32),
              sectionHeaderWidget("Module Configuration", isDark),
              const SizedBox(height: 12),
              settingsCardWidget([
                settingsSwitchTile(
                  title: "POS Terminal",
                  subtitle: "Enable Point of Sale interface for fast billing",
                  value: true,
                  isDark: isDark,
                  onChanged: (v) {},
                ),
                dividerWidget(isDark),
                settingsSwitchTile(
                  title: "Service & Repairs",
                  subtitle: "Track repair jobs, technicians, and service history",
                  value: true,
                  isDark: isDark,
                  onChanged: (v) {},
                ),
                dividerWidget(isDark),
                settingsSwitchTile(
                  title: "Warranty Management",
                  subtitle: "Track product warranties and policies",
                  value: true,
                  isDark: isDark,
                  onChanged: (v) {},
                ),
                dividerWidget(isDark),
                settingsSwitchTile(
                  title: "Loyalty Program",
                  subtitle: "Enable customer points and rewards",
                  value: true,
                  isDark: isDark,
                  onChanged: (v) {},
                ),
                dividerWidget(isDark),
                settingsSwitchTile(
                  title: "Multi-Warehouse",
                  subtitle: "Manage stock across multiple locations",
                  value: false,
                  isDark: isDark,
                  onChanged: (v) {},
                ),
              ], isDark),

              const SizedBox(height: 32),
              sectionHeaderWidget("System", isDark),
              const SizedBox(height: 12),
              settingsCardWidget([
                settingsListTile(
                  icon: Icons.storage_outlined,
                  title: "Backup & Restore",
                  subtitle: "Export data, import backups",
                  isDark: isDark,
                  onTap: () {},
                ),
                dividerWidget(isDark),
                settingsListTile(
                  icon: Icons.settings_suggest_outlined,
                  title: "App Preferences",
                  subtitle: "Theme, language, sounds",
                  isDark: isDark,
                  onTap: () {},
                ),
              ], isDark),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
