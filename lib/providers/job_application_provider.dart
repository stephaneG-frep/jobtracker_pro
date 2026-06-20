import 'package:flutter/material.dart';
import '../models/job_application.dart';
import '../services/local_database_service.dart';

class JobApplicationProvider extends ChangeNotifier {
  List<JobApplication> _applications = [];

  JobApplicationProvider() {
    _load();
  }

  Future<void> _load() async {
    _applications = LocalDatabaseService.getAll();
    notifyListeners();
  }

  List<JobApplication> get applications => List.unmodifiable(_applications);

  Future<void> add(JobApplication app) async {
    await LocalDatabaseService.add(app);
    await _load();
  }

  Future<void> update(JobApplication app) async {
    await LocalDatabaseService.update(app);
    await _load();
  }

  Future<void> delete(String id) async {
    await LocalDatabaseService.delete(id);
    await _load();
  }

  List<JobApplication> filterByStatus(ApplicationStatus status) => _applications.where((a) => a.status == status).toList();

  List<JobApplication> dueFollowUps() {
    final now = DateTime.now();
    return _applications.where((a) => a.followUpAt != null && a.followUpAt!.isBefore(now.add(const Duration(days: 1)))).toList();
  }
}
