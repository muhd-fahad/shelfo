import 'package:flutter/material.dart';

import '../../models/service_job/service_job_model.dart';

class ServiceJobFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ServiceJob? job;

  late String customerName;
  late String deviceName;
  late String deviceType;
  late String brand;
  late String serialNumber;
  late String reportedIssue;
  late ServiceJobPriority priority;
  late ServiceJobStatus status;
  late double laborCost;
  late List<double> partsCosts;
  late bool isWarranty;

  ServiceJobFormProvider(this.job) {
    customerName = job?.customerName ?? "";
    deviceName = job?.deviceName ?? "";
    deviceType = job?.deviceType ?? "Phone";
    brand = job?.brand ?? "";
    serialNumber = job?.serialNumber ?? "";
    reportedIssue = job?.reportedIssue ?? "";
    priority = job?.priority ?? ServiceJobPriority.normal;
    status = job?.status ?? ServiceJobStatus.received;
    laborCost = job?.laborCost ?? 0.0;
    partsCosts = job?.partsCosts != null ? List.from(job!.partsCosts) : [0.0];
    isWarranty = job?.isWarranty ?? false;
  }

  void setCustomerName(String name) {
    customerName = name;
    notifyListeners();
  }

  void setDeviceType(String type) {
    deviceType = type;
    notifyListeners();
  }

  void setPriority(ServiceJobPriority p) {
    priority = p;
    notifyListeners();
  }

  void setStatus(ServiceJobStatus s) {
    status = s;
    notifyListeners();
  }

  void setLaborCost(double cost) {
    laborCost = cost;
    notifyListeners();
  }

  void setPartCost(int index, double cost) {
    partsCosts[index] = cost;
    notifyListeners();
  }

  void addPartCost() {
    partsCosts.add(0.0);
    notifyListeners();
  }

  void removePartCost(int index) {
    partsCosts.removeAt(index);
    notifyListeners();
  }

  void setWarranty(bool value) {
    isWarranty = value;
    notifyListeners();
  }
}
