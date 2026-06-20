import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job_application.dart';
import '../providers/job_application_provider.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobApplicationProvider>(context);
    final due = provider.dueFollowUps();
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: due.length,
        itemBuilder: (c, i) {
          final a = due[i];
          return ListTile(
            title: Text('${a.company} — ${a.title}'),
            subtitle: Text('Relance prévue: ${a.followUpAt?.toLocal().toIso8601String() ?? '-'}'),
            trailing: ElevatedButton(
              onPressed: () async {
                a.followUpAt = null;
                a.status = ApplicationStatus.sent;
                await provider.update(a);
              },
              child: const Text('Marquer relancée'),
            ),
          );
        },
      ),
    );
  }
}
