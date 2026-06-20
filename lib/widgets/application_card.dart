import 'package:flutter/material.dart';
import '../models/job_application.dart';
import 'status_chip.dart';

class ApplicationCard extends StatelessWidget {
  final JobApplication application;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final Future<void> Function()? onDelete;
  const ApplicationCard({Key? key, required this.application, this.onTap, this.onEdit, this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardChild = Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${application.company} — ${application.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(application.city, style: const TextStyle(fontSize: 12)),
            ]),
          ),
          StatusChip(status: application.status),
        ]),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(application.appliedAt.toLocal().toShortIso(), style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Row(children: [
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  splashRadius: 20,
                  onPressed: onEdit,
                  tooltip: 'Modifier',
                ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  splashRadius: 20,
                  onPressed: () => onDelete?.call(),
                  tooltip: 'Supprimer',
                ),
            ]),
          ],
        ),
      ]),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: onTap == null ? cardChild : InkWell(onTap: onTap, child: cardChild),
    );
  }
}

extension _DateShort on DateTime {
  String toShortIso() => '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}
