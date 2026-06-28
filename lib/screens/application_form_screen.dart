import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../l10n/app_localizations.dart';
import '../models/job_application.dart';
import '../providers/job_application_provider.dart';

class ApplicationFormScreen extends StatefulWidget {
  final JobApplication? edit;
  const ApplicationFormScreen({Key? key, this.edit}) : super(key: key);

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  DateTime? _followUp;
  ApplicationStatus _status = ApplicationStatus.prepare;

  @override
  void initState() {
    super.initState();
    if (widget.edit != null) {
      final e = widget.edit!;
      _companyCtrl.text = e.company;
      _titleCtrl.text = e.title;
      _cityCtrl.text = e.city;
      _emailCtrl.text = e.contactEmail ?? '';
      _status = e.status;
      _followUp = e.followUpAt;
    }
  }

  @override
  void dispose() {
    _companyCtrl.dispose();
    _titleCtrl.dispose();
    _cityCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobApplicationProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.edit == null
              ? AppLocalizations.of(context).t('add_new')
              : AppLocalizations.of(context).t('edit'))),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                  controller: _companyCtrl,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).t('company')),
                  validator: (v) => v == null || v.isEmpty
                      ? AppLocalizations.of(context).t('required')
                      : null),
              TextFormField(
                  controller: _titleCtrl,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).t('job_title')),
                  validator: (v) => v == null || v.isEmpty
                      ? AppLocalizations.of(context).t('required')
                      : null),
              TextFormField(
                  controller: _cityCtrl,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).t('city'))),
              TextFormField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).t('recruiter_email'))),
              DropdownButtonFormField<ApplicationStatus>(
                initialValue: _status,
                items: ApplicationStatus.values
                    .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(AppLocalizations.of(context).t(s.name))))
                    .toList(),
                onChanged: (v) => setState(() => _status = v!),
              ),
              ListTile(
                title: Text(_followUp == null
                    ? AppLocalizations.of(context).t('followup_date')
                    : '${AppLocalizations.of(context).t('followup')}: ${_followUp!.toLocal()}'),
                trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final d = await showDatePicker(
                          context: context,
                          initialDate: _followUp ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                      if (d != null) setState(() => _followUp = d);
                    }),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final id = widget.edit?.id ?? const Uuid().v4();
                  final app = JobApplication(
                    id: id,
                    company: _companyCtrl.text,
                    title: _titleCtrl.text,
                    city: _cityCtrl.text,
                    appliedAt: widget.edit?.appliedAt,
                    contactEmail:
                        _emailCtrl.text.isEmpty ? null : _emailCtrl.text,
                    status: _status,
                    followUpAt: _followUp,
                  );
                  if (widget.edit == null) {
                    await provider.add(app);
                  } else {
                    await provider.update(app);
                  }
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context).t('save')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
