import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job_application.dart';
import '../providers/job_application_provider.dart';
import '../screens/applications_screen.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/pie_chart_widget.dart';
import '../l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobApplicationProvider>(context);
    final apps = provider.applications;
    final total = apps.length;
    final sent = apps.where((a) => a.status.name == 'sent').length;
    final interviews = apps.where((a) => a.status.name == 'interview').length;
    final followups = apps.where((a) => a.status.name == 'followUp').length;
    final rejected = apps.where((a) => a.status.name == 'rejected').length;
    final accepted = apps.where((a) => a.status.name == 'accepted').length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).t('dashboard'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(spacing: 12, runSpacing: 12, children: [
              DashboardStatCard(label: AppLocalizations.of(context).t('total'), value: total.toString(), onTap: () => _openApplications(context, null)),
              DashboardStatCard(label: AppLocalizations.of(context).t('sent'), value: sent.toString(), onTap: () => _openApplications(context, ApplicationStatus.sent)),
              DashboardStatCard(label: AppLocalizations.of(context).t('interviews'), value: interviews.toString(), onTap: () => _openApplications(context, ApplicationStatus.interview)),
              DashboardStatCard(label: AppLocalizations.of(context).t('followups'), value: followups.toString(), onTap: () => _openApplications(context, ApplicationStatus.followUp)),
              DashboardStatCard(label: AppLocalizations.of(context).t('rejected'), value: rejected.toString(), onTap: () => _openApplications(context, ApplicationStatus.rejected)),
              DashboardStatCard(label: AppLocalizations.of(context).t('accepted'), value: accepted.toString(), onTap: () => _openApplications(context, ApplicationStatus.accepted)),
            ]),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context).t('chart')),
            const SizedBox(height: 8),
            ApplicationsPieChart(data: {
              AppLocalizations.of(context).t('sent'): sent,
              AppLocalizations.of(context).t('interviews'): interviews,
              AppLocalizations.of(context).t('followups'): followups,
              AppLocalizations.of(context).t('rejected'): rejected,
              AppLocalizations.of(context).t('accepted'): accepted,
            }),
          ],
        ),
      ),
    );
  }

  void _openApplications(BuildContext context, ApplicationStatus? status) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ApplicationsScreen(filterStatus: status)));
  }
}
