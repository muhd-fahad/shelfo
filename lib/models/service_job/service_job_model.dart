import 'package:hive_ce/hive.dart';

part 'service_job_model.g.dart';

@HiveType(typeId: 13)
enum ServiceJobPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  normal,
  @HiveField(2)
  high,
}

@HiveType(typeId: 14)
enum ServiceJobStatus {
  @HiveField(0)
  received,
  @HiveField(1)
  diagnosing,
  @HiveField(2)
  inRepair,
  @HiveField(3)
  ready,
  @HiveField(4)
  completed,
  @HiveField(5)
  cancelled,
}

@HiveType(typeId: 15)
class ServiceJob extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String customerName;

  @HiveField(2)
  final String deviceName;

  @HiveField(3)
  final String deviceType;

  @HiveField(4)
  final String brand;

  @HiveField(5)
  final String serialNumber;

  @HiveField(6)
  final String reportedIssue;

  @HiveField(7)
  final String diagnosis;

  @HiveField(8)
  final ServiceJobPriority priority;

  @HiveField(9)
  ServiceJobStatus status;

  @HiveField(10)
  final double laborCost;

  @HiveField(11)
  final List<double> partsCosts;

  @HiveField(12)
  final bool isWarranty;

  @HiveField(13)
  final DateTime dueDate;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final String? assignedTo;

  ServiceJob({
    required this.id,
    required this.customerName,
    required this.deviceName,
    required this.deviceType,
    required this.brand,
    required this.serialNumber,
    required this.reportedIssue,
    required this.diagnosis,
    required this.priority,
    required this.status,
    required this.laborCost,
    required this.partsCosts,
    required this.isWarranty,
    required this.dueDate,
    required this.createdAt,
    this.assignedTo,
  });

  double get totalPartsCost => partsCosts.fold(0.0, (sum, item) => sum + item);
  double get totalCost => isWarranty ? 0.0 : (laborCost + totalPartsCost);

  ServiceJob copyWith({
    String? id,
    String? customerName,
    String? deviceName,
    String? deviceType,
    String? brand,
    String? serialNumber,
    String? reportedIssue,
    String? diagnosis,
    ServiceJobPriority? priority,
    ServiceJobStatus? status,
    double? laborCost,
    List<double>? partsCosts,
    bool? isWarranty,
    DateTime? dueDate,
    DateTime? createdAt,
    String? assignedTo,
  }) {
    return ServiceJob(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      deviceName: deviceName ?? this.deviceName,
      deviceType: deviceType ?? this.deviceType,
      brand: brand ?? this.brand,
      serialNumber: serialNumber ?? this.serialNumber,
      reportedIssue: reportedIssue ?? this.reportedIssue,
      diagnosis: diagnosis ?? this.diagnosis,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      laborCost: laborCost ?? this.laborCost,
      partsCosts: partsCosts ?? this.partsCosts,
      isWarranty: isWarranty ?? this.isWarranty,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}
