import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../models/job_application.dart';
import '../providers/job_application_provider.dart';
import '../services/export_service.dart';
import '../utils/text_utils.dart';
import '../widgets/application_card.dart';
import '../l10n/app_localizations.dart';
import 'application_form_screen.dart';

class ApplicationsScreen extends StatefulWidget {
  final ApplicationStatus? filterStatus;

  /// True when shown as a tab of the main shell, which already provides the
  /// app bar and the export action.
  final bool embedded;

  const ApplicationsScreen({super.key, this.filterStatus, this.embedded = false});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobApplicationProvider>(context);
    final l10n = AppLocalizations.of(context);
    final filterStatus = widget.filterStatus;
    final apps = List<JobApplication>.from(provider.applications.where((a) =>
        (filterStatus == null || a.status == filterStatus) &&
        matchesSearch(a, _query)))
      ..sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
    final sections = _groupBySaturdayWeek(apps);

    final searchField = Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (value) => setState(() => _query = value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: l10n.t('search_hint'),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: l10n.t('clear_search'),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _query = '');
                  },
                ),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );

    final list = SafeArea(
      child: Column(
        children: [
          searchField,
          Expanded(
            child: apps.isEmpty && _query.isNotEmpty
                ? Center(child: Text(l10n.t('no_results')))
                : ListView(
                    padding: const EdgeInsets.only(bottom: 96),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      for (final section in sections) ...[
                        _WeekHeader(section: section),
                        for (final a in section.applications)
                          Dismissible(
                            key: Key(a.id),
                            background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.delete,
                                    color: Colors.white)),
                            confirmDismiss: (_) => _confirmDelete(context),
                            onDismissed: (_) async {
                              await provider.delete(a.id);
                            },
                            child: ApplicationCard(
                              application: a,
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ApplicationFormScreen(edit: a))),
                              onEdit: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ApplicationFormScreen(edit: a))),
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
        ],
      ),
    );

    if (widget.embedded) return list;

    return Scaffold(
      appBar: AppBar(
        title: Text(filterStatus == null
            ? l10n.t('applications')
            : '${l10n.t('applications')} - ${l10n.t(filterStatus.name)}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: l10n.t('export_sent'),
            onPressed: () =>
                exportSentApplications(context, provider.applications),
          ),
        ],
      ),
      body: list,
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(l10n.t('confirm')),
            content: Text(l10n.t('delete_question')),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(c).pop(false),
                  child: Text(l10n.t('cancel'))),
              TextButton(
                  onPressed: () => Navigator.of(c).pop(true),
                  child: Text(l10n.t('delete'))),
            ],
          ),
        ) ??
        false;
  }
}

/// True when every word of [query] appears in one of the application's text
/// fields, ignoring case and accents.
bool matchesSearch(JobApplication app, String query) {
  String normalize(String value) => removeDiacritics(value.toLowerCase());

  final words = normalize(query).split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  if (words.isEmpty) return true;

  final haystack = normalize([
    app.company,
    app.title,
    app.city,
    app.contactName,
    app.contactEmail,
    app.notes,
  ].whereType<String>().join(' '));
  return words.every(haystack.contains);
}

Future<void> exportSentApplications(
  BuildContext context,
  List<JobApplication> applications,
) async {
  final l10n = AppLocalizations.of(context);
  final sentApplications = List<JobApplication>.from(
    applications.where((app) => app.status == ApplicationStatus.sent),
  )..sort((a, b) => b.appliedAt.compareTo(a.appliedAt));

  if (sentApplications.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.t('no_sent_to_export'))),
    );
    return;
  }

  // Default to the whole history: from the oldest sent application to today.
  DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  final oldest = dateOnly(sentApplications.last.appliedAt);
  final today = dateOnly(DateTime.now());
  final firstDate = oldest.isBefore(DateTime(2000)) ? oldest : DateTime(2000);
  final range = await showDateRangePicker(
    context: context,
    firstDate: firstDate,
    lastDate: DateTime(2100),
    initialDateRange: DateTimeRange(
      start: oldest,
      end: today.isBefore(oldest) ? oldest : today,
    ),
    helpText: l10n.t('export_period'),
    saveText: l10n.t('export'),
  );
  if (range == null || !context.mounted) return;

  // The end day is inclusive.
  final endExclusive = range.end.add(const Duration(days: 1));
  final inRange = sentApplications
      .where((a) =>
          !a.appliedAt.isBefore(range.start) &&
          a.appliedAt.isBefore(endExclusive))
      .toList();

  if (inRange.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.t('no_sent_in_period'))),
    );
    return;
  }

  final pdfBytes = await ExportService.toPdfBytes(
    inRange,
    from: range.start,
    to: range.end,
    title: l10n.t('sent_export_title'),
    statusLabelBuilder: (status) => l10n.t(status.name),
    columnHeaders: [
      l10n.t('company'),
      l10n.t('job_title'),
      l10n.t('status'),
      l10n.t('date'),
    ],
    periodLabelBuilder: (from, to) => l10n.t('period', {'from': from, 'to': to}),
  );

  String fileDate(DateTime d) => formatShortDate(d).split('/').reversed.join('-');
  await Printing.sharePdf(
    bytes: pdfBytes,
    filename:
        'jobtracker_annonces_postulees_${fileDate(range.start)}_${fileDate(range.end)}.pdf',
  );
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
                AppLocalizations.of(context).t('week_range', {
                  'start': _formatDate(section.start),
                  'end': _formatDate(section.end),
                }),
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
