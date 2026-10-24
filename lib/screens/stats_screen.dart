import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/job_application.dart';
import '../providers/job_application_provider.dart';
import '../theme/status_colors.dart';
import '../widgets/dashboard_stat_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobApplicationProvider>(context);
    final l10n = AppLocalizations.of(context);
    final apps = provider.applications;
    int count(ApplicationStatus s) => apps.where((a) => a.status == s).length;

    final interviews = count(ApplicationStatus.interview);
    final rejected = count(ApplicationStatus.rejected);
    final accepted = count(ApplicationStatus.accepted);
    // Applications still being prepared have not been sent, so they cannot
    // have received an answer yet.
    final submitted = apps.length - count(ApplicationStatus.prepare);
    final responses = interviews + rejected + accepted;
    final rate = submitted == 0 ? 0 : (responses / submitted * 100).round();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 12, runSpacing: 12, children: [
            DashboardStatCard(
                label: l10n.t('response_rate'),
                value: '$rate %',
                color: Theme.of(context).colorScheme.primary),
            DashboardStatCard(
                label: l10n.t('interviews'),
                value: '$interviews',
                color: statusColor(context, ApplicationStatus.interview)),
            DashboardStatCard(
                label: l10n.t('rejected'),
                value: '$rejected',
                color: statusColor(context, ApplicationStatus.rejected)),
            DashboardStatCard(
                label: l10n.t('accepted'),
                value: '$accepted',
                color: statusColor(context, ApplicationStatus.accepted)),
          ]),
        ]),
      ),
    );
  }
}
