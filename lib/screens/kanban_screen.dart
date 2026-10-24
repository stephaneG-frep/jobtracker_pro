import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/job_application.dart';
import '../providers/job_application_provider.dart';
import '../theme/status_colors.dart';
import '../widgets/application_card.dart';

class KanbanScreen extends StatefulWidget {
  const KanbanScreen({super.key});

  @override
  State<KanbanScreen> createState() => _KanbanScreenState();
}

class _KanbanScreenState extends State<KanbanScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobApplicationProvider>(context);
    final apps = provider.applications;

    Map<ApplicationStatus, List<JobApplication>> groups = {};
    for (var s in ApplicationStatus.values) {
      groups[s] = apps.where((a) => a.status == s).toList();
    }

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columnWidth = constraints.maxWidth.clamp(220.0, 260.0);

          return Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                height: constraints.maxHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: ApplicationStatus.values.map((status) {
                    return _KanbanColumn(
                      width: columnWidth,
                      status: status,
                      applications: groups[status]!,
                      onStatusChanged: (app) async {
                        if (app.status == status) return;
                        await provider.update(app.copyWith(status: status));
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  const _KanbanColumn({
    required this.width,
    required this.status,
    required this.applications,
    required this.onStatusChanged,
  });

  final double width;
  final ApplicationStatus status;
  final List<JobApplication> applications;
  final Future<void> Function(JobApplication app) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = statusColor(context, status);

    return Container(
      width: width,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                  accent.withAlpha(90), colorScheme.surfaceContainerHighest),
              border: Border(bottom: BorderSide(color: accent, width: 3)),
            ),
            child: Text(
              AppLocalizations.of(context).t(status.name),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: DragTarget<JobApplication>(
              onAcceptWithDetails: (details) => onStatusChanged(details.data),
              builder: (context, candidateData, rejected) {
                if (applications.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        AppLocalizations.of(context).t('no_applications'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(6),
                  itemCount: applications.length,
                  itemBuilder: (context, i) {
                    final item = applications[i];
                    final card =
                        ApplicationCard(application: item, compact: true);

                    return LongPressDraggable<JobApplication>(
                      data: item,
                      feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(width: width - 24, child: card),
                      ),
                      childWhenDragging: Opacity(opacity: 0.5, child: card),
                      child: card,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
