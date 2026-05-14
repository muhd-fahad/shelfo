import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/provider/theme_provider.dart';
import 'package:shelfo/utils/theme/app_constants/spacing.dart';
import 'package:shelfo/widgets/settings/settings_profile_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_divider.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_switch_tile.dart';
import 'package:shelfo/widgets/sfo_common/sfo_tile.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const SFOHeader(title: "Settings")),
      body: SFOBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: AppSpacing.md,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SettingsProfileCard(),
                const SizedBox(height: AppSpacing.sm),
                const SFOSectionHeader(title: "General"),
                SFOCard(
                  children: [
                    SFOTile(
                      icon: Icons.category_outlined,
                      title: "Product Categories",
                      subtitle: "Manage inventory categories",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.categoriesSettings,
                        );
                      },
                    ),
                    const SFODivider(),
                    SFOTile(
                      icon: Icons.branding_watermark_outlined,
                      title: "Product Brands",
                      subtitle: "Manage your product brands",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.brandsSettings);
                      },
                    ),
                    const SFODivider(),
                    SFOTile(
                      icon: Icons.percent_outlined,
                      title: "Tax Configuration",
                      subtitle: "Manage tax rates and calculation",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.taxSettings);
                      },
                    ),
                    const SFODivider(),
                    SFOTile(
                      icon: Icons.receipt_long_outlined,
                      title: "Invoice Settings",
                      subtitle: "Customize receipts and numbering",
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.invoiceDetails);
                      },
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
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const SFOSectionHeader(title: "Module Configuration"),
                SFOCard(
                  children: [
                    SFOSwitchTile(
                      title: "POS Terminal",
                      subtitle: "Enable Point of Sale interface for fast billing",
                      value: true,
                      onChanged: (v) {},
                    ),
                    const SFODivider(),
                    SFOSwitchTile(
                      title: "Service & Repairs",
                      subtitle:
                          "Track repair jobs, technicians, and service history",
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
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const SFOSectionHeader(title: "System"),
                SFOCard(
                  children: [
                    SFOSwitchTile(
                      title: "Dark Mode",
                      subtitle: "Enable dark theme across the application",
                      value: themeProvider.isDarkMode,
                      onChanged: (v) => themeProvider.toggleTheme(v),
                    ),
                    const SFODivider(),
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
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
