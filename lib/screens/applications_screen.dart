import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job_application.dart';
import '../providers/job_application_provider.dart';
import '../widgets/application_card.dart';
import '../l10n/app_localizations.dart';
import 'application_form_screen.dart';

class ApplicationsScreen extends StatelessWidget {
  final ApplicationStatus? filterStatus;
  const ApplicationsScreen({Key? key, this.filterStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobApplicationProvider>(context);
    final apps = filterStatus == null
        ? provider.applications
        : provider.applications.where((a) => a.status == filterStatus).toList();
    return Scaffold(
      appBar: AppBar(title: Text(filterStatus == null ? AppLocalizations.of(context).t('applications') : '${AppLocalizations.of(context).t('applications')} - ${AppLocalizations.of(context).t(filterStatus!.name)}')),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 96),
          itemCount: apps.length,
          itemBuilder: (context, i) {
            final a = apps[i];
            return Dismissible(
              key: Key(a.id),
              background: Container(color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
              confirmDismiss: (_) async {
                return await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(title: Text(AppLocalizations.of(context).t('confirm')), content: Text(AppLocalizations.of(context).t('delete_question')), actions: [
                        TextButton(onPressed: () => Navigator.of(c).pop(false), child: Text(AppLocalizations.of(context).t('cancel'))),
                        TextButton(onPressed: () => Navigator.of(c).pop(true), child: Text(AppLocalizations.of(context).t('delete'))),
                      ]),
                    ) ??
                    false;
              },
              onDismissed: (_) async {
                await provider.delete(a.id);
              },
              child: ApplicationCard(
                application: a,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ApplicationFormScreen(edit: a))),
                onEdit: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ApplicationFormScreen(edit: a))),
                onDelete: () async {
                  final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(title: Text(AppLocalizations.of(context).t('confirm')), content: Text(AppLocalizations.of(context).t('delete_question')), actions: [
                          TextButton(onPressed: () => Navigator.of(c).pop(false), child: Text(AppLocalizations.of(context).t('cancel'))),
                          TextButton(onPressed: () => Navigator.of(c).pop(true), child: Text(AppLocalizations.of(context).t('delete'))),
                        ]),
                      ) ??
                      false;
                  if (confirmed) {
                    await provider.delete(a.id);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
