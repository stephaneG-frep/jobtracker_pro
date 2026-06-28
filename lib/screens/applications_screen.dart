import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../models/job_application.dart';
import '../providers/job_application_provider.dart';
import '../services/export_service.dart';
import '../widgets/application_card.dart';
import '../l10n/app_localizations.dart';
import 'application_form_screen.dart';

class ApplicationsScreen extends StatelessWidget {
  final ApplicationStatus? filterStatus;
  const ApplicationsScreen({Key? key, this.filterStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobApplicationProvider>(context);
    final apps = List<JobApplication>.from(filterStatus == null
        ? provider.applications
        : provider.applications.where((a) => a.status == filterStatus))
      ..sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
    final sections = _groupBySaturdayWeek(apps);

    return Scaffold(
      appBar: AppBar(
        title: Text(filterStatus == null
            ? AppLocalizations.of(context).t('applications')
            : '${AppLocalizations.of(context).t('applications')} - ${AppLocalizations.of(context).t(filterStatus!.name)}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: AppLocalizations.of(context).t('export_sent'),
            onPressed: () =>
                _exportSentApplications(context, provider.applications),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: [
            for (final section in sections) ...[
              _WeekHeader(section: section),
              for (final a in section.applications)
                Dismissible(
                  key: Key(a.id),
                  background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white)),
                  confirmDismiss: (_) => _confirmDelete(context),
                  onDismissed: (_) async {
                    await provider.delete(a.id);
                  },
                  child: ApplicationCard(
                    application: a,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ApplicationFormScreen(edit: a))),
                    onEdit: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ApplicationFormScreen(edit: a))),
                    onDelete: () async {
                      final confirmed = await _confirmDelete(context);
                      if (confirmed) {
                        await provider.delete(a.id);
                      }
                    },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(AppLocalizations.of(context).t('confirm')),
            content: Text(AppLocalizations.of(context).t('delete_question')),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(c).pop(false),
                  child: Text(AppLocalizations.of(context).t('cancel'))),
              TextButton(
                  onPressed: () => Navigator.of(c).pop(true),
                  child: Text(AppLocalizations.of(context).t('delete'))),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _exportSentApplications(
    BuildContext context,
    List<JobApplication> applications,
  ) async {
    final sentApplications = List<JobApplication>.from(
      applications.where((app) => app.status == ApplicationStatus.sent),
    )..sort((a, b) => b.appliedAt.compareTo(a.appliedAt));

    if (sentApplications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context).t('no_sent_to_export'))),
      );
      return;
    }

    final pdfBytes = await ExportService.toPdfBytes(
      sentApplications,
      title: AppLocalizations.of(context).t('sent_export_title'),
      statusLabelBuilder: (status) =>
          AppLocalizations.of(context).t(status.name),
    );

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'jobtracker_annonces_postulees.pdf',
    );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader({required this.section});

  final _WeekSection section;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Du samedi ${_formatDate(section.start)} au vendredi ${_formatDate(section.end)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text('${section.applications.length}'),
          ],
        ),
      ),
    );
  }
}

class _WeekSection {
  const _WeekSection({
    required this.start,
    required this.end,
    required this.applications,
  });

  final DateTime start;
  final DateTime end;
  final List<JobApplication> applications;
}

List<_WeekSection> _groupBySaturdayWeek(List<JobApplication> apps) {
  final grouped = <DateTime, List<JobApplication>>{};

  for (final app in apps) {
    final start = _saturdayWeekStart(app.appliedAt);
    grouped.putIfAbsent(start, () => []).add(app);
  }

  final starts = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
  return starts.map((start) {
    final sectionApps = grouped[start]!
      ..sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
    return _WeekSection(
      start: start,
      end: start.add(const Duration(days: 6)),
      applications: sectionApps,
    );
  }).toList();
}

DateTime _saturdayWeekStart(DateTime date) {
  final local = DateTime(date.year, date.month, date.day);
  final daysSinceSaturday = (local.weekday - DateTime.saturday) % 7;
  return local.subtract(Duration(days: daysSinceSaturday));
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
}
