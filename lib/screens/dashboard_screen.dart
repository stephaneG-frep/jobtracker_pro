import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job_application.dart';
import '../providers/job_application_provider.dart';
import '../screens/applications_screen.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/pie_chart_widget.dart';
import '../l10n/app_localizations.dart';
import '../theme/status_colors.dart';

// Statuses shown as stat cards and in the chart, with their label keys.
const _chartStatuses = [
  ApplicationStatus.sent,
  ApplicationStatus.interview,
  ApplicationStatus.followUp,
  ApplicationStatus.rejected,
  ApplicationStatus.accepted,
];
const _labelKeys = {
  ApplicationStatus.sent: 'sent',
  ApplicationStatus.interview: 'interviews',
  ApplicationStatus.followUp: 'followups',
  ApplicationStatus.rejected: 'rejected',
  ApplicationStatus.accepted: 'accepted',
};

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobApplicationProvider>(context);
    final apps = provider.applications;
    final l10n = AppLocalizations.of(context);
    int count(ApplicationStatus s) => apps.where((a) => a.status == s).length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(spacing: 12, runSpacing: 12, children: [
              DashboardStatCard(
                  label: l10n.t('total'),
                  value: apps.length.toString(),
                  color: Theme.of(context).colorScheme.primary,
                  onTap: () => _openApplications(context, null)),
              for (final s in _chartStatuses)
                DashboardStatCard(
                    label: l10n.t(_labelKeys[s]!),
                    value: count(s).toString(),
                    color: statusColor(context, s),
                    onTap: () => _openApplications(context, s)),
            ]),
            const SizedBox(height: 20),
            Text(l10n.t('chart')),
            const SizedBox(height: 8),
            ApplicationsPieChart(
              data: {for (final s in _chartStatuses) l10n.t(_labelKeys[s]!): count(s)},
              colors: [for (final s in _chartStatuses) statusColor(context, s)],
            ),
          ],
        ),
      ),
    );
  }

  void _openApplications(BuildContext context, ApplicationStatus? status) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ApplicationsScreen(filterStatus: status)));
  }
}
