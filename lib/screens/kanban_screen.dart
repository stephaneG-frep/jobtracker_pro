import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job_application.dart';
import '../providers/job_application_provider.dart';
import '../widgets/application_card.dart';

class KanbanScreen extends StatelessWidget {
  const KanbanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobApplicationProvider>(context);
    final apps = provider.applications;

    Map<ApplicationStatus, List<JobApplication>> groups = {};
    for (var s in ApplicationStatus.values) {
      groups[s] = apps.where((a) => a.status == s).toList();
    }

    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: ApplicationStatus.values.map((status) {
            return Container(
              width: 260,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
                    child: Text(status.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 180,
                    child: DragTarget<JobApplication>(
                      onAcceptWithDetails: (details) async {
                        final app = details.data;
                        app.status = status;
                        await provider.update(app);
                      },
                      builder: (context, candidateData, rejected) {
                        final list = groups[status]!;
                        if (list.isEmpty) {
                          return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('Aucune candidature')));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            final item = list[i];
                            return Draggable<JobApplication>(
                              data: item,
                              feedback: Material(child: SizedBox(width: 220, child: ApplicationCard(application: item))),
                              childWhenDragging: Opacity(opacity: 0.5, child: ApplicationCard(application: item)),
                              child: ApplicationCard(application: item),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
