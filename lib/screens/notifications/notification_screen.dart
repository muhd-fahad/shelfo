import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shelfo/models/notification/notification_model.dart';
import 'package:shelfo/provider/business/notification_provider.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_dialog.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SFOHeader(
        title: "Notifications",
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: "Mark all as read",
            onPressed: () => context.read<NotificationProvider>().markAllAsRead(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: "Clear all",
            onPressed: () => _showClearAllDialog(context),
          ),
        ],
      ),
      body: SFOBackground(
        child: Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.notifications.isEmpty) {
              return _buildEmptyState(context);
            }

            return ListView.separated(
              padding: EdgeInsets.all(AppSpacing.md),
              itemCount: provider.notifications.length,
              separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];
                return _NotificationTile(notification: notification);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 64,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            "No notifications yet",
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            "We'll notify you about stock alerts,\npurchase orders, and sales updates.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    SFODialog.show(
      context,
      title: "Clear all notifications?",
      message: "This action cannot be undone.",
      primaryActionText: "Clear All",
      onPrimaryAction: () {
        context.read<NotificationProvider>().clearAll();
        Navigator.pop(context);
      },
      secondaryActionText: "Cancel",
      isDestructive: true,
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: AppRadius.lg,
        ),
        child: Icon(Icons.delete_outline, color: colorScheme.onError),
      ),
      onDismissed: (_) {
        context.read<NotificationProvider>().deleteNotification(notification);
      },
      child: SFOCard(
        padding: EdgeInsets.zero,
        children: [
          InkWell(
            onTap: () {
              if (!notification.isRead) {
                context.read<NotificationProvider>().markAsRead(notification);
              }
            },
            borderRadius: AppRadius.lg,
            child: Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: notification.isRead
                    ? Colors.transparent
                    : colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: AppRadius.lg,
                border: !notification.isRead
                    ? Border.all(color: colorScheme.primary.withValues(alpha: 0.2))
                    : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIcon(context),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                            Text(
                              _formatDate(notification.dateTime),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: notification.isRead ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.stock:
        iconData = Icons.inventory_2_outlined;
        iconColor = Colors.orange;
        break;
      case NotificationType.purchaseOrder:
        iconData = Icons.shopping_cart_outlined;
        iconColor = colorScheme.secondary;
        break;
      case NotificationType.sales:
        iconData = Icons.trending_up;
        iconColor = colorScheme.primary;
        break;
      case NotificationType.serviceJob:
        iconData = Icons.handyman_outlined;
        iconColor = Colors.blue;
        break;
      case NotificationType.general:
        iconData = Icons.notifications_outlined;
        iconColor = colorScheme.outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: ShapeDecoration(
        color: iconColor.withValues(alpha: 0.1),
        shape: RoundedSuperellipseBorder(
          borderRadius: AppRadius.sm,
        ),
      ),
      child: Icon(iconData, color: iconColor, size: 20),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);

    if (date == today) {
      return DateFormat('hh:mm a').format(dt);
    } else if (date == today.subtract(const Duration(days: 1))) {
      return "Yesterday";
    } else {
      return DateFormat('MMM dd').format(dt);
    }
  }
}
