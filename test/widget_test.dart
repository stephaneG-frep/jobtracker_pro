import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:jobtracker_pro/app.dart';
import 'package:jobtracker_pro/providers/job_application_provider.dart';

Widget _app() => ChangeNotifierProvider(
      create: (_) => JobApplicationProvider(),
      child: const JobTrackerApp(),
    );

void main() {
  testWidgets('shows the dashboard and the navigation bar',
      (WidgetTester tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.byIcon(Icons.dashboard), findsWidgets);
    expect(find.byIcon(Icons.view_kanban), findsOneWidget);
  });

  testWidgets('applications tab has a single app bar',
      (WidgetTester tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byIcon(Icons.file_download_outlined), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('dashboard does not overflow on a small landscape screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(640, 360);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
