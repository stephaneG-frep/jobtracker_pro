import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/job_application.dart';

class StatusChip extends StatelessWidget {
  final ApplicationStatus status;
  const StatusChip({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context).t(status.name);
    Color c;
    switch (status) {
      case ApplicationStatus.accepted:
        c = Colors.green;
        break;
      case ApplicationStatus.rejected:
        c = Colors.red;
        break;
      case ApplicationStatus.followUp:
        c = Colors.orange;
        break;
      default:
        c = Colors.blueGrey;
    }

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
