import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/dashboard_screen.dart';
import 'screens/kanban_screen.dart';
import 'screens/applications_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/application_form_screen.dart';
import 'screens/help_screen.dart';

class JobTrackerApp extends StatelessWidget {
  const JobTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobTracker Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true, colorSchemeSeed: Colors.indigo),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [Locale('en'), Locale('fr')],
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({Key? key}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const List<Widget> _pages = <Widget>[
    DashboardScreen(),
    KanbanScreen(),
    ApplicationsScreen(),
    RemindersScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).t(_navTitleKey(_index))),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ApplicationFormScreen()));
            },
            tooltip: AppLocalizations.of(context).t('add_new'),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpScreen()));
            },
            tooltip: AppLocalizations.of(context).t('help'),
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: AppLocalizations.of(context).t('dashboard')),
          BottomNavigationBarItem(icon: const Icon(Icons.view_kanban), label: AppLocalizations.of(context).t('kanban')),
          BottomNavigationBarItem(icon: const Icon(Icons.list), label: AppLocalizations.of(context).t('applications')),
          BottomNavigationBarItem(icon: const Icon(Icons.alarm), label: AppLocalizations.of(context).t('reminders')),
          BottomNavigationBarItem(icon: const Icon(Icons.bar_chart), label: AppLocalizations.of(context).t('stats')),
        ],
      ),
      floatingActionButton: _index == 2
          ? FloatingActionButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ApplicationFormScreen()));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

String _navTitleKey(int index) {
  switch (index) {
    case 0:
      return 'dashboard';
    case 1:
      return 'kanban';
    case 2:
      return 'applications';
    case 3:
      return 'reminders';
    default:
      return 'stats';
  }
}
