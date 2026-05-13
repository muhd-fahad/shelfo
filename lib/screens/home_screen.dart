import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/provider/product_provider.dart';
import 'package:intl/intl.dart';
import 'package:shelfo/provider/sale_provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/widgets/home/home_summary_card.dart';
import 'package:shelfo/widgets/home/quick_action_item.dart';
import 'package:shelfo/widgets/home/sales_chart.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_logo.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_badge.dart';
import 'package:shelfo/screens/sales/invoice_detail_screen.dart';

import '../models/product/product_model.dart';
import '../utils/theme/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final productProvider = context.watch<ProductProvider>();
    final saleProvider = context.watch<SaleProvider>();
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;

    // Calculate today's sales
    final now = DateTime.now();
    final todaySales = saleProvider.sales
        .where(
          (s) =>
              s.dateTime.year == now.year &&
              s.dateTime.month == now.month &&
              s.dateTime.day == now.day &&
              s.status != 'Refunded',
        )
        .fold(0.0, (sum, s) => sum + s.total);

    // Get recent transactions
    final recentSales = saleProvider.sales.take(3).toList();

    // Get low stock products
    final lowStockProducts = productProvider.products
        .where((p) => p.stockQuantity <= p.minStock)
        .take(5)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const SFOLogo(height: 24, fit: BoxFit.fitWidth),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.notification),
                icon: const Icon(Icons.notifications_none_rounded, size: 24),
              ),
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.settings),
                icon: const Icon(Icons.account_circle_outlined, size: 24),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Summary Cards Grid
          Row(
            children: [
              HomeSummaryCard(
                label: "Today's Sales",
                value: CurrencyFormatter.formatCompact(todaySales, currency),
                icon: Icons.trending_up,
                badge: "+0%",
                badgeColor: AppColors.success,
              ),
              const SizedBox(width: 12),
              HomeSummaryCard(
                label: "Pending Orders",
                value: "0 Items",
                icon: Icons.refresh_rounded,
                badge: "0",
                badgeColor: Colors.orange,
                iconColor: Colors.orange,
                iconBgColor: Colors.orange.withValues(alpha: 0.1),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              HomeSummaryCard(
                label: "Low Stock",
                value: "${productProvider.lowStockCount} Items",
                icon: Icons.error_outline_rounded,
                badge: productProvider.lowStockCount.toString(),
                badgeColor: AppColors.error,
                iconColor: AppColors.error,
                iconBgColor: AppColors.error.withValues(alpha: 0.1),
              ),
              const SizedBox(width: 12),
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
            ],
          ),

          const SizedBox(height: AppSpacing.xl),
          const SFOSectionHeader(title: "Quick Actions"),
          const SizedBox(height: AppSpacing.lg),

          // Quick Actions Grid
          SFOCard(
            padding: EdgeInsets.all(AppSpacing.md),
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: .spaceAround,
                children: [
                  QuickActionItem(
                    label: "New Sale",
                    icon: Icons.add,
                    isPrimary: true,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.pos),
                  ),
                  QuickActionItem(
                    label: "POS",
                    icon: Icons.desktop_windows_outlined,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.pos),
                  ),
                  QuickActionItem(
                    label: "Stock",
                    icon: Icons.inventory_2_outlined,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.inventory),
                  ),
                  QuickActionItem(
                    label: "Purchase",
                    icon: Icons.local_shipping_outlined,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.purchaseOrder),
                  ),
                  QuickActionItem(
                    label: "Customers",
                    icon: Icons.people_outline_rounded,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.customers),
                  ),
                  QuickActionItem(
                    label: "Service Jobs",
                    icon: Icons.handyman_outlined,
                    onTap: () {},
                  ),
                  QuickActionItem(
                    label: "Sales History",
                    icon: Icons.history_rounded,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.salesHistory),
                  ),
                  QuickActionItem(
                    label: "Report",
                    icon: Icons.query_stats_rounded,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.reports),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),
          const SFOSectionHeader(title: "Sales Analytics"),
          const SizedBox(height: 16),
          const SalesChart(),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SFOSectionHeader(title: "Low Stock Alerts"),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.inventory),
                child: Row(
                  children: [
                    Text(
                      "View All",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.error,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.05),
              borderRadius: AppRadius.lg,
              border: Border.all(color: AppColors.error.withValues(alpha: 0.1)),
            ),
            child: lowStockProducts.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "No low stock items",
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  )
                : Column(
                    children: lowStockProducts
                        .map((product) => _buildLowStockItem(context, product))
                        .toList(),
                  ),
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SFOSectionHeader(title: "Recent Transactions"),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.salesHistory),
                child: Row(
                  children: [
                    Text(
                      "View All",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (recentSales.isEmpty)
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
            ...recentSales.map(
              (sale) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildTransactionItem(
                  context,
                  sale.customerName,
                  "${DateFormat('MMM dd, hh:mm a').format(sale.dateTime)} • ${sale.id}",
                  CurrencyFormatter.format(sale.total, currency),
                  sale.status,
                  sale.status == 'Refunded'
                      ? AppColors.error
                      : AppColors.success,
                  sale.paymentMethod == 'Cash'
                      ? Icons.payments_outlined
                      : Icons.credit_card,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvoiceDetailScreen(sale: sale),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLowStockItem(BuildContext context, Product product) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
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
            product.stockQuantity <= 0
                ? "Out"
                : "${product.stockQuantity} left",
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "Min: ${product.minStock}",
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
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
        padding: const EdgeInsets.all(12),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
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
                      fontSize: 10,
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
                const SizedBox(height: 4),
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
