import 'package:flutter/material.dart';

import '../../models/service_job/service_job_model.dart';
import '../../services/hive/service_job_service.dart';

class ServiceJobProvider extends ChangeNotifier {
  List<ServiceJob> _jobs = [];
  List<ServiceJob> _filteredJobs = [];
  bool _isLoading = false;
  String _searchQuery = '';
  final List<ServiceJobStatus> _filterStatuses = [];

  List<ServiceJob> get jobs => _filteredJobs;
  List<ServiceJob> get allJobs => _jobs;
  bool get isLoading => _isLoading;
  List<ServiceJobStatus> get filterStatuses => _filterStatuses;

  ServiceJobProvider() {
    loadJobs();
  }

  Future<void> loadJobs() async {
    _isLoading = true;
    notifyListeners();

    _jobs = await ServiceJobHiveService.getAllJobs();
    _applyFilter();

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void toggleFilterStatus(ServiceJobStatus? status) {
    if (status == null) {
      _filterStatuses.clear();
    } else {
      if (_filterStatuses.contains(status)) {
        _filterStatuses.remove(status);
      } else {
        _filterStatuses.add(status);
      }
    }
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    List<ServiceJob> results = _jobs;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      results = results.where((job) =>
          job.id.toLowerCase().contains(query) ||
          job.customerName.toLowerCase().contains(query) ||
          job.deviceName.toLowerCase().contains(query)).toList();
    }

    if (_filterStatuses.isNotEmpty) {
      results = results.where((job) => _filterStatuses.contains(job.status)).toList();
    }

    _filteredJobs = results;
  }

  Future<void> addJob(ServiceJob job) async {
    await ServiceJobHiveService.saveJob(job);
    await loadJobs();
  }

  Future<void> updateJob(ServiceJob job) async {
    await ServiceJobHiveService.saveJob(job);
    await loadJobs();
  }

  Future<void> deleteJob(String id) async {
    await ServiceJobHiveService.deleteJob(id);
    await loadJobs();
  }

  Future<void> advanceStatus(ServiceJob job) async {
    final nextStatus = _getNextStatus(job.status);
    if (nextStatus != null) {
      job.status = nextStatus;
      await job.save();
      notifyListeners();
    }
  }

  ServiceJobStatus? _getNextStatus(ServiceJobStatus current) {
    switch (current) {
      case ServiceJobStatus.received:
        return ServiceJobStatus.diagnosing;
      case ServiceJobStatus.diagnosing:
        return ServiceJobStatus.inRepair;
      case ServiceJobStatus.inRepair:
        return ServiceJobStatus.ready;
      case ServiceJobStatus.ready:
        return ServiceJobStatus.completed;
      default:
        return null;
    }
  }

  String getNextJobId() {
    final year = DateTime.now().year;
    final count = _jobs.length + 1;
    return "JOB-$year-${count.toString().padLeft(3, '0')}";
  }
}
