import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/job_application.dart';
import '../providers/job_application_provider.dart';
import '../theme/status_colors.dart';
import '../widgets/accent_card.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobApplicationProvider>(context);
    final l10n = AppLocalizations.of(context);
    final dateFormat = MaterialLocalizations.of(context);
    final due = provider.dueFollowUps();
    if (due.isEmpty) {
      return Center(child: Text(l10n.t('no_followups')));
    }
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: due.length,
        itemBuilder: (c, i) {
          final a = due[i];
          return AccentCard(
            color: statusColor(context, a.status),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: ListTile(
              title: Text('${a.company} — ${a.title}'),
              subtitle: Text(
                l10n.t('followup_planned', {
                  'date': a.followUpAt == null
                      ? '-'
                      : dateFormat.formatMediumDate(a.followUpAt!.toLocal()),
                }),
              ),
              trailing: ElevatedButton(
                onPressed: () async {
                  // Only a pending follow-up goes back to "sent"; a later stage
                  // (interview, accepted...) keeps its status.
                  await provider.update(
                    a.copyWith(
                      followUpAt: null,
                      status: a.status == ApplicationStatus.followUp
                          ? ApplicationStatus.sent
                          : a.status,
                    ),
                  );
                },
                child: Text(l10n.t('mark_followed_up')),
              ),
            ),
          );
        },
      ),
    );
  }
}
