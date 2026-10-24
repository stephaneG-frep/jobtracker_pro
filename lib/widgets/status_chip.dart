import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/job_application.dart';
import '../theme/status_colors.dart';

class StatusChip extends StatelessWidget {
  final ApplicationStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context).t(status.name);
    final c = statusColor(context, status);

    return Chip(
      label: Text(label),
      backgroundColor: c.withAlpha((255 * 0.15).round()),
      avatar: CircleAvatar(
        backgroundColor: c,
        child: Text(label[0].toUpperCase()),
      ),
    );
  }
}
