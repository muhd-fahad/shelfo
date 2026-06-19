import 'package:hive_ce/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 24)
enum NotificationType {
  @HiveField(0)
  stock,
  @HiveField(1)
  purchaseOrder,
  @HiveField(2)
  sales,
  @HiveField(3)
  general,
}

@HiveType(typeId: 25)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String message;
  @HiveField(3)
  final NotificationType type;
  @HiveField(4)
  final DateTime dateTime;
  @HiveField(5)
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.dateTime,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? dateTime,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      isRead: isRead ?? this.isRead,
    );
  }
}
