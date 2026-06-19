import 'package:flutter/material.dart';
import '../../models/notification/notification_model.dart';
import '../../services/hive/hive_service.dart';
import '../inventory/product_provider.dart';
import '../purchase/purchase_order_provider.dart';
import '../sales/sale_provider.dart';
import '../service_job/service_job_provider.dart';
import 'business_provider.dart';
import '../../models/purchase/purchase_order_model.dart';
import '../../models/service_job/service_job_model.dart';
import '../../services/notification/local_notification_service.dart';
import 'package:intl/intl.dart';

class NotificationProvider extends ChangeNotifier {
  ProductProvider? _productProvider;
  PurchaseOrderProvider? _purchaseOrderProvider;
  SaleProvider? _saleProvider;
  ServiceJobProvider? _serviceJobProvider;
  BusinessProvider? _businessProvider;

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationProvider({
    ProductProvider? productProvider,
    PurchaseOrderProvider? purchaseOrderProvider,
    SaleProvider? saleProvider,
    ServiceJobProvider? serviceJobProvider,
    BusinessProvider? businessProvider,
  })  : _productProvider = productProvider,
        _purchaseOrderProvider = purchaseOrderProvider,
        _saleProvider = saleProvider,
        _serviceJobProvider = serviceJobProvider,
        _businessProvider = businessProvider {
    _loadNotifications();
  }

  void update({
    ProductProvider? productProvider,
    PurchaseOrderProvider? purchaseOrderProvider,
    SaleProvider? saleProvider,
    ServiceJobProvider? serviceJobProvider,
    BusinessProvider? businessProvider,
  }) {
    if (productProvider != null) _productProvider = productProvider;
    if (purchaseOrderProvider != null) _purchaseOrderProvider = purchaseOrderProvider;
    if (saleProvider != null) _saleProvider = saleProvider;
    if (serviceJobProvider != null) _serviceJobProvider = serviceJobProvider;
    if (businessProvider != null) _businessProvider = businessProvider;
    checkNotifications();
  }

  Future<void> _loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    final box = await HiveService.getBox<NotificationModel>(HiveService.notificationsBox);
    _notifications = box.values.toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkNotifications() async {
    if (_productProvider == null || 
        _purchaseOrderProvider == null || 
        _saleProvider == null || 
        _serviceJobProvider == null ||
        _businessProvider == null) return;

    // 1. Check Stock
    final lowStockProducts = _productProvider!.products.where((p) => p.stockQuantity <= p.minStock);
    for (var product in lowStockProducts) {
      final isOut = product.stockQuantity <= 0;
      final id = "stock_${product.id}_${isOut ? 'out' : 'low'}";
      
      if (!_notifications.any((n) => n.id == id)) {
        await addNotification(NotificationModel(
          id: id,
          title: isOut ? "Out of Stock" : "Low Stock Alert",
          message: "${product.name} is ${isOut ? 'out of stock' : 'running low (${product.stockQuantity} left)'}.",
          type: NotificationType.stock,
          dateTime: DateTime.now(),
        ));
      }
    }

    // 2. Check Purchase Order & Service Job Reminders (Expected Dates)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    // PO Reminders
    final pendingOrders = _purchaseOrderProvider!.allOrders.where((o) => o.status != PurchaseOrderStatus.received && o.expectedDate != null);
    for (var order in pendingOrders) {
      final expected = DateTime(order.expectedDate!.year, order.expectedDate!.month, order.expectedDate!.day);
      if (expected.isAtSameMomentAs(today) || expected.isAtSameMomentAs(tomorrow)) {
        final isToday = expected.isAtSameMomentAs(today);
        final id = "po_${order.id}_${isToday ? 'today' : 'tomorrow'}";
        
        if (!_notifications.any((n) => n.id == id)) {
          await addNotification(NotificationModel(
            id: id,
            title: "PO Expected ${isToday ? 'Today' : 'Tomorrow'}",
            message: "Purchase Order ${order.id} from ${order.vendorName} is expected ${isToday ? 'today' : 'tomorrow'}.",
            type: NotificationType.purchaseOrder,
            dateTime: DateTime.now(),
          ));
        }
      }
    }

    // Service Job Reminders
    final activeJobs = _serviceJobProvider!.allJobs.where((j) => 
      j.status != ServiceJobStatus.completed && j.status != ServiceJobStatus.cancelled);
    for (var job in activeJobs) {
      final due = DateTime(job.dueDate.year, job.dueDate.month, job.dueDate.day);
      if (due.isAtSameMomentAs(today) || due.isAtSameMomentAs(tomorrow)) {
        final isToday = due.isAtSameMomentAs(today);
        final id = "job_${job.id}_${isToday ? 'today' : 'tomorrow'}";
        
        if (!_notifications.any((n) => n.id == id)) {
          await addNotification(NotificationModel(
            id: id,
            title: "Job Due ${isToday ? 'Today' : 'Tomorrow'}",
            message: "Service Job ${job.id} for ${job.customerName} is due ${isToday ? 'today' : 'tomorrow'}.",
            type: NotificationType.serviceJob,
            dateTime: DateTime.now(),
          ));
        }
      }
    }

    // 3. Weekly Sales (Check if we should notify about last week's performance)
    final currentMonday = today.subtract(Duration(days: (now.weekday - 1) % 7));
    final lastMonday = currentMonday.subtract(const Duration(days: 7));
    final id = "weekly_sales_${DateFormat('yyyyMMdd').format(lastMonday)}";
    
    if (!_notifications.any((n) => n.id == id)) {
      final lastWeekSales = _saleProvider!.allSales.where((s) => 
        s.dateTime.isAfter(lastMonday) && s.dateTime.isBefore(currentMonday) && s.status == 'Paid');
      
      if (lastWeekSales.isNotEmpty) {
        final totalAmount = lastWeekSales.fold(0.0, (sum, s) => sum + s.total);
        final currencySymbol = _businessProvider!.selectedCurrency.symbol;
        
        await addNotification(NotificationModel(
          id: id,
          title: "Weekly Sales Summary",
          message: "Last week (${DateFormat('MMM dd').format(lastMonday)} - ${DateFormat('MMM dd').format(currentMonday.subtract(const Duration(seconds: 1)))}) you had ${lastWeekSales.length} sales totaling $currencySymbol${totalAmount.toStringAsFixed(2)}.",
          type: NotificationType.sales,
          dateTime: DateTime.now(),
        ));
      }
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    final box = await HiveService.getBox<NotificationModel>(HiveService.notificationsBox);
    await box.add(notification);
    _notifications.insert(0, notification);
    
    // Trigger Local Notification
    await LocalNotificationService.showNotification(
      id: notification.id.hashCode,
      title: notification.title,
      body: notification.message,
      payload: notification.id,
    );

    notifyListeners();
  }

  Future<void> markAsRead(NotificationModel notification) async {
    notification.isRead = true;
    await notification.save();
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    for (var n in _notifications) {
      if (!n.isRead) {
        n.isRead = true;
        await n.save();
      }
    }
    notifyListeners();
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    await notification.delete();
    _notifications.remove(notification);
    notifyListeners();
  }

  Future<void> clearAll() async {
    final box = await HiveService.getBox<NotificationModel>(HiveService.notificationsBox);
    await box.clear();
    _notifications.clear();
    notifyListeners();
  }
}
