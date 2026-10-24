import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/job_application.dart';
import '../theme/status_colors.dart';
import 'accent_card.dart';
import 'status_chip.dart';

class ApplicationCard extends StatelessWidget {
  final JobApplication application;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final Future<void> Function()? onDelete;
  final bool compact;

  const ApplicationCard({
    super.key,
    required this.application,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = Text(
      '${application.company} - ${application.title}',
      maxLines: compact ? 2 : null,
      overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
    final city = Text(
      application.city,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 12),
    );
    final date = Text(
      application.appliedAt.toLocal().toShortIso(),
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
    final actionButtons = Row(mainAxisSize: MainAxisSize.min, children: [
      if (onEdit != null)
        IconButton(
          icon: const Icon(Icons.edit, size: 20),
          splashRadius: 20,
          onPressed: onEdit,
          tooltip: l10n.t('edit'),
        ),
      if (onDelete != null)
        IconButton(
          icon: const Icon(Icons.delete, size: 20),
          splashRadius: 20,
          onPressed: () => onDelete?.call(),
          tooltip: l10n.t('delete'),
        ),
    ]);

    final cardChild = Padding(
      padding: EdgeInsets.all(compact ? 10.0 : 12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (compact) ...[
          title,
          const SizedBox(height: 6),
          city,
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: StatusChip(status: application.status),
            ),
          ),
        ] else
          Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    const SizedBox(height: 6),
                    city,
                  ]),
            ),
            Flexible(
              flex: 0,
              child: StatusChip(status: application.status),
            ),
          ]),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: date),
            actionButtons,
          ],
        ),
      ]),
    );

    return AccentCard(
      color: statusColor(context, application.status),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      onTap: onTap,
      child: cardChild,
    );
  }
}

extension _DateShort on DateTime {
  String toShortIso() =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}
