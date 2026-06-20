import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/local_database_service.dart';
import 'services/notification_service.dart';
import 'providers/job_application_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabaseService.init();
  await NotificationService.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => JobApplicationProvider()),
    ],
    child: const JobTrackerApp(),
  ));
}
