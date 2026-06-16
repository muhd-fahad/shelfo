import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/provider/theme_provider.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/settings/settings_profile_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_divider.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_tile.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';
import 'package:shelfo/widgets/sfo_common/sfo_bottom_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: const SFOHeader(title: "Settings"),
      body: SFOBackground(
        child: SafeArea(
          child: SFOResponsive(
            mobile: _buildContent(context, themeProvider, false),
            tablet: _buildContent(context, themeProvider, false),
            desktop: _buildContent(context, themeProvider, true),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDesktop,
  ) {
    final double horizontalPadding = isDesktop ? 32.w : 20.r;

    final generalSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SFOSectionHeader(title: "General"),
        SizedBox(height: AppSpacing.sm),
        SFOCard(
          children: [
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
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.salesHistory);
              },
            ),
            const SFODivider(),
            SFOTile(
              icon: Icons.policy_outlined,
              title: "Policies & Warranties",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.policies);
              },
            ),
            SFOTile(
              icon: Icons.bar_chart_outlined,
              title: "Reports & Analysis",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.reports);
              },
            ),
          ],
        ),
      ],
    );

    final systemSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SFOSectionHeader(title: "System"),
        SizedBox(height: AppSpacing.sm),
        SFOCard(
          children: [
            SFOTile(
              icon: Icons.palette_outlined,
              title: "Appearance",
              subtitle: _getThemeModeName(themeProvider.themeMode),
              onTap: () => _showThemeSelector(context, themeProvider),
            ),
            // const SFODivider(),
            // SFOTile(
            //   icon: Icons.storage_outlined,
            //   title: "Backup & Restore",
            //   subtitle: "Export data, import backups",
            //   onTap: () {},
            // ),
          ],
        ),
      ],
    );

    final aboutSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SFOSectionHeader(title: "Support & Legal"),
        SizedBox(height: AppSpacing.sm),
        SFOCard(
          children: [
            SFOTile(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.privacyPolicy);
              },
            ),
            const SFODivider(),
            SFOTile(
              icon: Icons.info_outline,
              title: "About Shelfo",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.about);
              },
            ),
          ],
        ),
      ],
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 20.r,
      ),
      child: Column(
        spacing: AppSpacing.md,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SettingsProfileCard(),
          SizedBox(height: AppSpacing.sm),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: generalSection),
                SizedBox(width: 24.w),
                Expanded(
                  child: Column(
                    children: [
                      systemSection,
                      SizedBox(height: AppSpacing.md),
                      aboutSection,
                    ],
                  ),
                ),
              ],
            )
          else ...[
            generalSection,
            SizedBox(height: AppSpacing.md),
            systemSection,
            SizedBox(height: AppSpacing.md),
            aboutSection,
          ],
          SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  void _showThemeSelector(BuildContext context, ThemeProvider themeProvider) {
    SFOBottomSheet.show(
      context,
      title: "Select Theme",
      child: Column(
        children: [
          _buildThemeOption(
            context,
            themeProvider,
            ThemeMode.system,
            "System Default",
            Icons.settings_brightness_outlined,
          ),
          _buildThemeOption(
            context,
            themeProvider,
            ThemeMode.light,
            "Light Mode",
            Icons.light_mode_outlined,
          ),
          _buildThemeOption(
            context,
            themeProvider,
            ThemeMode.dark,
            "Dark Mode",
            Icons.dark_mode_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider themeProvider,
    ThemeMode mode,
    String title,
    IconData icon,
  ) {
    final isSelected = themeProvider.themeMode == mode;
    return SFOTile(
      icon: icon,
      title: title,
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : const SizedBox.shrink(),
      onTap: () {
        themeProvider.setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return "System Default";
      case ThemeMode.light:
        return "Light Mode";
      case ThemeMode.dark:
        return "Dark Mode";
    }
  }
}
