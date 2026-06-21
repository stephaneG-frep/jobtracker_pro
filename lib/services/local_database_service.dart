import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/job_application.dart';

class LocalDatabaseService {
  static const String boxName = 'applications';
  static const String settingsBoxName = 'settings';
  static const String themeKey = 'theme';

  static Box<dynamic>? _box;
  static Box<dynamic>? _settingsBox;

  static Future<void> init() async {
    if (!kIsWeb) {
      Directory appDoc = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDoc.path);
    } else {
      await Hive.initFlutter();
    }
    _box = await Hive.openBox(boxName);
    _settingsBox = await Hive.openBox(settingsBoxName);
    await _seedDemoDataIfNeeded();
  }

  static Future<void> _seedDemoDataIfNeeded() async {
    if (_box == null) return;
    if (_box!.isEmpty) {
      final demo = [
        JobApplication(
                id: '1',
                company: 'Acme Corp',
                title: 'Développeur Flutter',
                city: 'Paris',
                status: ApplicationStatus.sent)
            .toMap(),
        JobApplication(
                id: '2',
                company: 'Globex',
                title: 'Ingénieur Backend',
                city: 'Lyon',
                status: ApplicationStatus.followUp,
                followUpAt: DateTime.now().add(const Duration(days: 2)))
            .toMap(),
        JobApplication(
                id: '3',
                company: 'Initech',
                title: 'Stage QA',
                city: 'Bordeaux',
                status: ApplicationStatus.prepare)
            .toMap(),
      ];
      for (var i = 0; i < demo.length; i++) {
        await _box!.put(demo[i]['id'], demo[i]);
      }
    }
  }

  static List<JobApplication> getAll() {
    if (_box == null) return [];
    return _box!.values
        .map((e) => JobApplication.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> add(JobApplication app) async {
    await _box!.put(app.id, app.toMap());
  }

  static Future<void> update(JobApplication app) async {
    await _box!.put(app.id, app.toMap());
  }

  static Future<void> delete(String id) async {
    await _box!.delete(id);
  }

  static String? getTheme() {
    return _settingsBox?.get(themeKey) as String?;
  }

  static Future<void> saveTheme(String theme) async {
    await _settingsBox?.put(themeKey, theme);
  }
}
