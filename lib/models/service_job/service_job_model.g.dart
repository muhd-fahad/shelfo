// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_job_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceJobAdapter extends TypeAdapter<ServiceJob> {
  @override
  final typeId = 15;

  @override
  ServiceJob read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceJob(
      id: fields[0] as String,
      customerName: fields[1] as String,
      deviceName: fields[2] as String,
      deviceType: fields[3] as String,
      brand: fields[4] as String,
      serialNumber: fields[5] as String,
      reportedIssue: fields[6] as String,
      diagnosis: fields[7] as String,
      priority: fields[8] as ServiceJobPriority,
      status: fields[9] as ServiceJobStatus,
      laborCost: (fields[10] as num).toDouble(),
      partsCosts: (fields[11] as List).cast<double>(),
      isWarranty: fields[12] as bool,
      dueDate: fields[13] as DateTime,
      createdAt: fields[14] as DateTime,
      assignedTo: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceJob obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerName)
      ..writeByte(2)
      ..write(obj.deviceName)
      ..writeByte(3)
      ..write(obj.deviceType)
      ..writeByte(4)
      ..write(obj.brand)
      ..writeByte(5)
      ..write(obj.serialNumber)
      ..writeByte(6)
      ..write(obj.reportedIssue)
      ..writeByte(7)
      ..write(obj.diagnosis)
      ..writeByte(8)
      ..write(obj.priority)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.laborCost)
      ..writeByte(11)
      ..write(obj.partsCosts)
      ..writeByte(12)
      ..write(obj.isWarranty)
      ..writeByte(13)
      ..write(obj.dueDate)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.assignedTo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceJobAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServiceJobPriorityAdapter extends TypeAdapter<ServiceJobPriority> {
  @override
  final typeId = 13;

  @override
  ServiceJobPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ServiceJobPriority.low;
      case 1:
        return ServiceJobPriority.normal;
      case 2:
        return ServiceJobPriority.high;
      default:
        return ServiceJobPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, ServiceJobPriority obj) {
    switch (obj) {
      case ServiceJobPriority.low:
        writer.writeByte(0);
      case ServiceJobPriority.normal:
        writer.writeByte(1);
      case ServiceJobPriority.high:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceJobPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServiceJobStatusAdapter extends TypeAdapter<ServiceJobStatus> {
  @override
  final typeId = 14;

  @override
  ServiceJobStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ServiceJobStatus.received;
      case 1:
        return ServiceJobStatus.diagnosing;
      case 2:
        return ServiceJobStatus.inRepair;
      case 3:
        return ServiceJobStatus.ready;
      case 4:
        return ServiceJobStatus.completed;
      case 5:
        return ServiceJobStatus.cancelled;
      default:
        return ServiceJobStatus.received;
    }
  }

  @override
  void write(BinaryWriter writer, ServiceJobStatus obj) {
    switch (obj) {
      case ServiceJobStatus.received:
        writer.writeByte(0);
      case ServiceJobStatus.diagnosing:
        writer.writeByte(1);
      case ServiceJobStatus.inRepair:
        writer.writeByte(2);
      case ServiceJobStatus.ready:
        writer.writeByte(3);
      case ServiceJobStatus.completed:
        writer.writeByte(4);
      case ServiceJobStatus.cancelled:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceJobStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
