import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/currency/currency.dart';
import 'package:shelfo/models/purchase/purchase_order_model.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/screens/inventory/product_details_screen.dart';
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
import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';

import '../../models/product/product_model.dart';
import '../../provider/business/business_provider.dart';
import '../../provider/business/navigation_provider.dart';
import '../../provider/inventory/product_provider.dart';
import '../../provider/purchase/purchase_order_provider.dart';
import '../../provider/sales/sale_provider.dart';
import '../../provider/business/notification_provider.dart';
import '../../utils/theme/app_constants/colors.dart';
import '../../utils/theme/app_constants/radius.dart';
import '../../utils/theme/app_constants/spacing.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final saleProvider = context.watch<SaleProvider>();
    final orderProvider = context.watch<PurchaseOrderProvider>();
    final recentSales = saleProvider.sales.take(3).toList();
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SFOBackground(
        child: SFOResponsive(
          mobile: _buildHomeContent(context, currency, productProvider, orderProvider, recentSales, false),
          tablet: _buildHomeContent(context, currency, productProvider, orderProvider, recentSales, true),
          desktop: _buildHomeContent(context, currency, productProvider, orderProvider, recentSales, true),
        ),
      ),
    );
  }

  Widget _buildHomeContent(
    BuildContext context,
    Currency currency,
    ProductProvider productProvider,
    PurchaseOrderProvider orderProvider,
    List<dynamic> recentSales,
    bool isLargeScreen,
  ) {
    final double horizontalPadding = isLargeScreen ? 32.w : 16.w;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8.h),
      children: [
        _buildSummaryGrid(context, currency, productProvider, orderProvider, isLargeScreen),
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
    const double tabletBreakpoint = 600;

    // Mapping of routes to BottomNavbarWidget indices
    final Map<String, int> routeToIndex = {
      AppRoutes.home: 0,
      AppRoutes.purchaseOrder: 1,
      AppRoutes.salesOrder: 2,
      AppRoutes.inventory: 3,
      AppRoutes.customers: 4,
      AppRoutes.reports: 5,
      AppRoutes.salesHistory: 6,
      AppRoutes.settings: 7,
    };

    if (routeToIndex.containsKey(route)) {
      int index = routeToIndex[route]!;
      
      if (width < tabletBreakpoint) {
        // Mobile: Only indices 0–3 are in the BottomNavigationBar directly.
        // If it's one of those, we switch the tab.
        if (index >= 0 && index <= 3) {
          navProvider.setIndex(index);
          return;
        }
        // For index 7 (Settings) or others, we fall through to Navigator.pushNamed
        // to show the screen without the BottomNavigationBar.
      } else {
        // Tablet/Desktop: All indices are in the NavigationRail
        navProvider.setIndex(index);
        return;
      }
    }

    // Default: If not a root tab or if on mobile and not in the main navbar, push normally
    Navigator.pushNamed(context, route);
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: SFOLogo(height: 24.h, fit: BoxFit.fitWidth),
      actions: [
        Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.notification),
                  icon: Icon(Icons.notifications_none_rounded, size: 24.r),
                ),
                if (provider.unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        provider.unreadCount > 9 ? '9+' : provider.unreadCount.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
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
    PurchaseOrderProvider orderProvider,
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

    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdaySales = context
        .read<SaleProvider>()
        .sales
        .where((s) =>
            s.dateTime.year == yesterday.year &&
            s.dateTime.month == yesterday.month &&
            s.dateTime.day == yesterday.day &&
            s.status != 'Refunded')
        .fold(0.0, (sum, s) => sum + s.total);

    String salesBadge = "+0%";
    Color salesBadgeColor = AppColors.success;
    if (yesterdaySales > 0) {
      final percentage = ((todaySales - yesterdaySales) / yesterdaySales) * 100;
      salesBadge = "${percentage >= 0 ? '+' : ''}${percentage.toStringAsFixed(1)}%";
      salesBadgeColor = percentage >= 0 ? AppColors.success : AppColors.error;
    } else if (todaySales > 0) {
      salesBadge = "+100%";
      salesBadgeColor = AppColors.success;
    }

    final pendingOrdersCount = orderProvider.orders
        .where((o) =>
            o.status == PurchaseOrderStatus.ordered ||
            o.status == PurchaseOrderStatus.partial ||
            o.status == PurchaseOrderStatus.draft)
        .length;

    final lowStockCount = productProvider.lowStockCount;
    final outOfStockCount = productProvider.outOfStockCount;

    final List<HomeSummaryCard> cards = [
      HomeSummaryCard(
        label: "Today's Sales",
        value: CurrencyFormatter.formatCompact(todaySales, currency),
        icon: Icons.trending_up,
        badge: salesBadge,
        badgeColor: salesBadgeColor,
        onTap: () => _handleNavigation(context, AppRoutes.salesHistory),
      ),
      HomeSummaryCard(
        label: "Pending Orders",
        value: "$pendingOrdersCount Items",
        icon: Icons.refresh_rounded,
        iconColor: Colors.orange,
        iconBgColor: Colors.orange.withValues(alpha: 0.1),
        onTap: () => _handleNavigation(context, AppRoutes.purchaseOrder),
      ),
      HomeSummaryCard(
        label: "Stock Alerts",
        value: "${lowStockCount + outOfStockCount} Items",
        icon: Icons.error_outline_rounded,
        badge: outOfStockCount > 0 ? "$outOfStockCount Out" : "$lowStockCount Low",
        badgeColor: outOfStockCount > 0 ? AppColors.error : Colors.orange,
        iconColor: outOfStockCount > 0 ? AppColors.error : Colors.orange,
        iconBgColor: (outOfStockCount > 0 ? AppColors.error : Colors.orange).withValues(alpha: 0.1),
        onTap: () => _handleNavigation(context, AppRoutes.inventory),
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
        onTap: () {
          context.read<ProductProvider>().clearFilters();
          _handleNavigation(context, AppRoutes.inventory);
        },
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 900) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisExtent: 115.h,
          ),
          itemBuilder: (context, index) => cards[index],
        );
      },
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
            LayoutBuilder(
              builder: (context, constraints) {
                // Determine number of columns based on width
                int crossAxisCount = 4;
                if (constraints.maxWidth > 1000) {
                  crossAxisCount = 8;
                } else if (constraints.maxWidth > 600) {
                  crossAxisCount = 6;
                }
                
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 8.w,
                    mainAxisExtent: 96.h, // Increased for better alignment and accessibility
                  ),
                  itemBuilder: (context, index) {
                    final actions = [
                      ("POS", Icons.desktop_windows_outlined, AppRoutes.pos, true),
                      ("Stock", Icons.inventory_2_outlined, AppRoutes.inventory, false),
                      ("Purchase", Icons.local_shipping_outlined, AppRoutes.purchaseOrder, false),
                      ("Customers", Icons.people_outline_rounded, AppRoutes.customers, false),
                      ("Service", Icons.handyman_outlined, AppRoutes.serviceJobs, false),
                      ("Orders", Icons.assignment_outlined, AppRoutes.salesOrder, false),
                      ("History", Icons.history_rounded, AppRoutes.salesHistory, false),
                      ("Report", Icons.query_stats_rounded, AppRoutes.reports, false),
                    ];
                    final action = actions[index];
                    return _buildQuickAction(context, action.$1, action.$2, action.$3, isPrimary: action.$4);
                  },
                );
              },
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
    final productProvider = context.watch<ProductProvider>();
    final lowStockProducts = productProvider.products
        .where((p) => p.stockQuantity <= p.minStock)
        .toList()
        ..sort((a, b) => a.stockQuantity.compareTo(b.stockQuantity));

    final displayProducts = lowStockProducts.take(5).toList();

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
          child: displayProducts.isEmpty
              ? _buildEmptyState(theme, "No low stock items")
              : Column(
            children: displayProducts.map((p) => _buildLowStockItem(context, p)).toList(),
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
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(product: product),
        ),
      ),
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
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