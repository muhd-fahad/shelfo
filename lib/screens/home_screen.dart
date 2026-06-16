import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/currency/currency.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/provider/navigation_provider.dart';
import 'package:shelfo/provider/product_provider.dart';
import 'package:shelfo/provider/sale_provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/screens/sales/invoice_detail_screen.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/widgets/home/home_summary_card.dart';
import 'package:shelfo/widgets/home/quick_action_item.dart';
import 'package:shelfo/widgets/home/sales_chart.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/widgets/sfo_common/sfo_badge.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_logo.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';

import '../models/product/product_model.dart';
import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';

import '../utils/theme/app_constants/colors.dart';
import '../utils/theme/app_constants/radius.dart';
import '../utils/theme/app_constants/spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final saleProvider = context.watch<SaleProvider>();
    final recentSales = saleProvider.sales.take(3).toList();
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SFOBackground(
        child: SFOResponsive(
          mobile: _buildHomeContent(context, currency, productProvider, recentSales, false),
          tablet: _buildHomeContent(context, currency, productProvider, recentSales, true),
          desktop: _buildHomeContent(context, currency, productProvider, recentSales, true),
        ),
      ),
    );
  }

  Widget _buildHomeContent(
    BuildContext context,
    Currency currency,
    ProductProvider productProvider,
    List<dynamic> recentSales,
    bool isLargeScreen,
  ) {
    final double horizontalPadding = isLargeScreen ? 32.w : 16.w;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8.h),
      children: [
        _buildSummaryGrid(context, currency, productProvider, isLargeScreen),
        SizedBox(height: AppSpacing.xl),
        _buildQuickActionsSection(context),
        SizedBox(height: 24.h),
        _buildAnalyticsSection(),
        SizedBox(height: 24.h),
        if (isLargeScreen)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildLowStockSection(context)),
              SizedBox(width: 24.w),
              Expanded(
                child: _buildRecentTransactionsSection(
                  context,
                  recentSales,
                  currency,
                ),
              ),
            ],
          )
        else ...[
          _buildLowStockSection(context),
          SizedBox(height: 24.h),
          _buildRecentTransactionsSection(context, recentSales, currency),
        ],
        SizedBox(height: 40.h),
      ],
    );
  }

  void _handleNavigation(BuildContext context, String route) {
    final navProvider = context.read<NavigationProvider>();
    final width = MediaQuery.of(context).size.width;
    const double tabletBreakpoint = 600; // Consistent with AppBreakpoints if imported, but usually 600

    // Root tabs indices in BottomNavbarWidget:
    // 0: Home, 1: POS, 2: Sales, 3: Stock, 4: Customers, 5: Reports, 6: History, 7: Settings

    if (width >= tabletBreakpoint) {
      // Tablet/Desktop: All 8 indices are in the NavigationRail
      switch (route) {
        case AppRoutes.pos:
          navProvider.setIndex(1);
          return;
        case AppRoutes.salesOrder:
          navProvider.setIndex(2);
          return;
        case AppRoutes.inventory:
          navProvider.setIndex(3);
          return;
        case AppRoutes.customers:
          navProvider.setIndex(4);
          return;
        case AppRoutes.reports:
          navProvider.setIndex(5);
          return;
        case AppRoutes.salesHistory:
          navProvider.setIndex(6);
          return;
        case AppRoutes.settings:
          navProvider.setIndex(7);
          return;
      }
    } else {
      // Mobile: Only indices 0-3 are in the BottomNavigationBar
      switch (route) {
        case AppRoutes.pos:
          navProvider.setIndex(1);
          return;
        case AppRoutes.salesOrder:
          navProvider.setIndex(2);
          return;
        case AppRoutes.inventory:
          navProvider.setIndex(3);
          return;
      }
    }

    // Default: If not a root tab in the current mode, push normally
    Navigator.pushNamed(context, route);
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: SFOLogo(height: 24.h, fit: BoxFit.fitWidth),
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.notification),
          icon: Icon(Icons.notifications_none_rounded, size: 24.r),
        ),
        IconButton(
          onPressed: () => _handleNavigation(context, AppRoutes.settings),
          icon: Icon(Icons.account_circle_outlined, size: 24.r),
        ),
      ],
    );
  }

  Widget _buildSummaryGrid(
    BuildContext context,
    Currency currency,
    ProductProvider productProvider,
    bool isLargeScreen,
  ) {
    // Data preparation
    final now = DateTime.now();
    final todaySales = context
        .watch<SaleProvider>()
        .sales
        .where((s) =>
            s.dateTime.year == now.year &&
            s.dateTime.month == now.month &&
            s.dateTime.day == now.day &&
            s.status != 'Refunded')
        .fold(0.0, (sum, s) => sum + s.total);

    final List<Widget> cards = [
      HomeSummaryCard(
        label: "Today's Sales",
        value: CurrencyFormatter.formatCompact(todaySales, currency),
        icon: Icons.trending_up,
        badge: "+0%",
        badgeColor: AppColors.success,
      ),
      HomeSummaryCard(
        label: "Pending Orders",
        value: "0 Items",
        icon: Icons.refresh_rounded,
        badge: "0",
        badgeColor: Colors.orange,
        iconColor: Colors.orange,
        iconBgColor: Colors.orange.withValues(alpha: 0.1),
        onTap: () => _handleNavigation(context, AppRoutes.salesOrder),
      ),
      HomeSummaryCard(
        label: "Low Stock",
        value: "${productProvider.lowStockCount} Items",
        icon: Icons.error_outline_rounded,
        badge: productProvider.lowStockCount.toString(),
        badgeColor: AppColors.error,
        iconColor: AppColors.error,
        iconBgColor: AppColors.error.withValues(alpha: 0.1),
      ),
      HomeSummaryCard(
        label: "Inventory Value",
        value: CurrencyFormatter.formatCompact(
          productProvider.inventoryValue,
          currency,
        ),
        icon: Icons.inventory_2_outlined,
        iconColor: Colors.blue,
        iconBgColor: Colors.blue.withValues(alpha: 0.1),
      ),
    ];

    if (isLargeScreen) {
      return Row(
        children: cards
            .map((card) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: cards.last == card ? 0 : 12.w),
                    child: card,
                  ),
                ))
            .toList(),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: cards[0]),
            SizedBox(width: 12.w),
            Expanded(child: cards[1]),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: cards[2]),
            SizedBox(width: 12.w),
            Expanded(child: cards[3]),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SFOSectionHeader(title: "Quick Actions"),
        SizedBox(height: AppSpacing.lg),
        SFOCard(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            Wrap(
              spacing: 16.w,
              runSpacing: 16.h,
              children: [
                _buildQuickAction(context, "POS", Icons.desktop_windows_outlined, AppRoutes.pos),
                _buildQuickAction(context, "Stock", Icons.inventory_2_outlined, AppRoutes.inventory),
                _buildQuickAction(context, "Purchase", Icons.local_shipping_outlined, AppRoutes.purchaseOrder),
                _buildQuickAction(context, "Customers", Icons.people_outline_rounded, AppRoutes.customers),
                _buildQuickAction(context, "Service Jobs", Icons.handyman_outlined, AppRoutes.serviceJobs),
                _buildQuickAction(context, "Sales Orders", Icons.assignment_outlined, AppRoutes.salesOrder),
                _buildQuickAction(context, "Sales History", Icons.history_rounded, AppRoutes.salesHistory),
                _buildQuickAction(context, "Report", Icons.query_stats_rounded, AppRoutes.reports),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(
      BuildContext context,
      String label,
      IconData icon,
      String route, {
        bool isPrimary = false,
      }) {
    return QuickActionItem(
      label: label,
      icon: icon,
      isPrimary: isPrimary,
      onTap: () => _handleNavigation(context, route),
    );
  }

  Widget _buildAnalyticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SFOSectionHeader(title: "Sales Analytics"),
        SizedBox(height: 16.h),
        const SalesChart(),
      ],
    );
  }

  Widget _buildLowStockSection(BuildContext context,) {
    final theme = Theme.of(context);
    final lowStockProducts =  context.watch<ProductProvider>().products
        .where((p) => p.stockQuantity <= p.minStock)
        .take(5)
        .toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SFOSectionHeader(title: "Low Stock Alerts"),
            _buildViewAllButton(context, AppRoutes.inventory, AppColors.error),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.05),
            borderRadius: AppRadius.lg,
            border: Border.all(color: AppColors.error.withValues(alpha: 0.1)),
          ),
          child: lowStockProducts.isEmpty
              ? _buildEmptyState(theme, "No low stock items")
              : Column(
            children: lowStockProducts.map((p) => _buildLowStockItem(context, p)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsSection(
      BuildContext context,
      List<dynamic> sales,
      Currency currency,
      ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SFOSectionHeader(title: "Recent Transactions"),
            _buildViewAllButton(context, AppRoutes.salesHistory, AppColors.primary),
          ],
        ),
        SizedBox(height: 8.h),
        if (sales.isEmpty)
          _buildTransactionItem(
            context,
            "Walk-in Customer",
            "No transactions yet",
            CurrencyFormatter.format(0.0, currency),
            "None",
            AppColors.textSecondary,
            Icons.shopping_bag_outlined,
          )
        else
          ...sales.map((sale) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildTransactionItem(
              context,
              sale.customerName,
              "${DateFormat('MMM dd, hh:mm a').format(sale.dateTime)} • ${sale.id}",
              CurrencyFormatter.format(sale.total, currency),
              sale.status,
              sale.status == 'Refunded' ? AppColors.error : AppColors.success,
              sale.paymentMethod == 'Cash' ? Icons.payments_outlined : Icons.credit_card,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceDetailScreen(sale: sale),
                ),
              ),
            ),
          )),
      ],
    );
  }

  Widget _buildViewAllButton(BuildContext context, String route, Color color) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () => _handleNavigation(context, route),
      child: Row(
        children: [
          Text(
            "View All",
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.chevron_right, size: 16.r, color: color),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, String message) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Center(
        child: Text(message, style: theme.textTheme.bodySmall),
      ),
    );
  }

  Widget _buildLowStockItem(BuildContext context, Product product) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: Row(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 18.r,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              product.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            product.stockQuantity <= 0 ? "Out" : "${product.stockQuantity} left",
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            "Min: ${product.minStock}",
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      BuildContext context,
      String title,
      String subtitle,
      String amount,
      String status,
      Color statusColor,
      IconData icon, {
        VoidCallback? onTap,
      }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: ShapeDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.md,
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                size: 20.r,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                SFOBadge(
                  label: status,
                  bgColor: statusColor.withValues(alpha: 0.1),
                  textColor: statusColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}