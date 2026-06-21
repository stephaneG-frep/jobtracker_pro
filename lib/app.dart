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

enum AppThemeOption {
  light('Clair', Icons.light_mode),
  balanced('50/50', Icons.contrast),
  dark('Foncé', Icons.dark_mode);

  const AppThemeOption(this.label, this.icon);

  final String label;
  final IconData icon;
}

class JobTrackerApp extends StatefulWidget {
  const JobTrackerApp({Key? key}) : super(key: key);

  @override
  State<JobTrackerApp> createState() => _JobTrackerAppState();
}

class _JobTrackerAppState extends State<JobTrackerApp> {
  AppThemeOption _themeOption = AppThemeOption.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobTracker Pro',
      debugShowCheckedModeBanner: false,
      theme: _themeData(_themeOption),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [Locale('en'), Locale('fr')],
      home: MainShell(
        themeOption: _themeOption,
        onThemeChanged: (themeOption) {
          setState(() => _themeOption = themeOption);
        },
      ),
    );
  }
}

ThemeData _themeData(AppThemeOption option) {
  const bottomNavigationBarTheme = BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Color(0xFFF7F8FC),
    selectedItemColor: Color(0xFF3F51B5),
    unselectedItemColor: Color(0xFF5F6673),
    selectedIconTheme: IconThemeData(size: 26),
    unselectedIconTheme: IconThemeData(size: 24),
    showSelectedLabels: false,
    showUnselectedLabels: false,
  );

  switch (option) {
    case AppThemeOption.light:
      return ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        bottomNavigationBarTheme: bottomNavigationBarTheme,
      );
    case AppThemeOption.balanced:
      final colorScheme = ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ).copyWith(
        surface: const Color(0xFFCCD3E0),
        onSurface: const Color(0xFF172033),
        surfaceContainerHighest: const Color(0xFFB3BDCC),
        onSurfaceVariant: const Color(0xFF263246),
      );

      return ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFBFC8D6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8996AA),
          foregroundColor: Color(0xFF111827),
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFFCCD3E0),
          selectedItemColor: Color(0xFF3F51B5),
          unselectedItemColor: Color(0xFF344052),
          selectedIconTheme: IconThemeData(size: 26),
          unselectedIconTheme: IconThemeData(size: 24),
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFFD6DCE6),
          surfaceTintColor: Colors.transparent,
        ),
      );
    case AppThemeOption.dark:
      return ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
          backgroundColor: const Color(0xFF1E1F25),
          selectedItemColor: const Color(0xFF9FA8FF),
          unselectedItemColor: const Color(0xFFB9BECA),
        ),
      );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({
    Key? key,
    required this.themeOption,
    required this.onThemeChanged,
  }) : super(key: key);

  final AppThemeOption themeOption;
  final ValueChanged<AppThemeOption> onThemeChanged;

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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ApplicationFormScreen()));
            },
            tooltip: AppLocalizations.of(context).t('add_new'),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const HelpScreen()));
            },
            tooltip: AppLocalizations.of(context).t('help'),
          ),
          PopupMenuButton<AppThemeOption>(
            icon: Icon(widget.themeOption.icon),
            tooltip: 'Thème',
            onSelected: widget.onThemeChanged,
            itemBuilder: (context) {
              return AppThemeOption.values.map((themeOption) {
                return PopupMenuItem<AppThemeOption>(
                  value: themeOption,
                  child: Row(
                    children: [
                      Icon(themeOption.icon),
                      const SizedBox(width: 12),
                      Text(themeOption.label),
                      if (themeOption == widget.themeOption) ...[
                        const Spacer(),
                        const Icon(Icons.check),
                      ],
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard),
              label: AppLocalizations.of(context).t('dashboard')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.view_kanban),
              label: AppLocalizations.of(context).t('kanban')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              label: AppLocalizations.of(context).t('applications')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.alarm),
              label: AppLocalizations.of(context).t('reminders')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart),
              label: AppLocalizations.of(context).t('stats')),
        ],
      ),
      floatingActionButton: _index == 2
          ? FloatingActionButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ApplicationFormScreen()));
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
