import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  // Pairs of (section title key, section body key).
  static const _sections = [
    ('dashboard', 'help_dashboard'),
    ('kanban', 'help_kanban'),
    ('applications', 'help_applications'),
    ('search', 'help_search'),
    ('export', 'help_export'),
    ('reminders', 'help_reminders'),
    ('stats', 'help_stats'),
    ('themes', 'help_themes'),
    ('statuses', 'help_statuses'),
    ('tip', 'help_tip'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('help'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(l10n.t('help_welcome'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(l10n.t('help_intro')),
            for (final (title, body) in _sections) ...[
              const SizedBox(height: 12),
              Text(l10n.t(title), style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(l10n.t(body)),
            ],
          ],
        ),
      ),
    );
  }
}
