import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job_application.dart';
import '../providers/job_application_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobApplicationProvider>(context);
    final apps = provider.applications;
    final weeksMap = <String, int>{};
    for (var a in apps) {
      final key = '${a.appliedAt.year}-${a.appliedAt.weekday}';
      weeksMap[key] = (weeksMap[key] ?? 0) + 1;
    }
    final responses = apps.where((a) => a.status == ApplicationStatus.rejected || a.status == ApplicationStatus.accepted).length;
    final rate = apps.isEmpty ? 0 : (responses / apps.length * 100).round();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Statistiques', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text('Taux de réponse: $rate %'),
          const SizedBox(height: 12),
          Text('Entretiens: ${apps.where((a) => a.status == ApplicationStatus.interview).length}'),
          const SizedBox(height: 12),
          Text('Refus: ${apps.where((a) => a.status == ApplicationStatus.rejected).length}'),
          const SizedBox(height: 12),
          Text('Acceptations: ${apps.where((a) => a.status == ApplicationStatus.accepted).length}'),
        ]),
      ),
    );
  }
}
