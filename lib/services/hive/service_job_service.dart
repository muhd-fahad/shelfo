import 'package:hive_ce/hive_ce.dart';
import '../../models/service_job/service_job_model.dart';
import 'hive_service.dart';

class ServiceJobHiveService {
  static const String boxName = 'serviceJobsBox';

  static Future<Box<ServiceJob>> _getBox() async {
    return HiveService.getBox<ServiceJob>(boxName);
  }

  static Future<List<ServiceJob>> getAllJobs() async {
    final box = await _getBox();
    return box.values.toList();
  }

  static Future<void> saveJob(ServiceJob job) async {
    final box = await _getBox();
    await box.put(job.id, job);
  }

  static Future<void> deleteJob(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
