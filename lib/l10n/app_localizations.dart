import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'appTitle': 'JobTracker Pro',
      'company': 'Company',
      'job_title': 'Job title',
      'required': 'Required',
      'city': 'City',
      'recruiter_email': 'Recruiter email',
      'followup_date': 'Follow-up date',
      'followup': 'Follow-up',
      'save': 'Save',
      'total': 'Total',
      'prepare': 'To prepare',
      'sent': 'Sent',
      'interview': 'Interview',
      'interviews': 'Interviews',
      'followUp': 'Follow-up',
      'followups': 'Follow-ups',
      'rejected': 'Rejected',
      'accepted': 'Accepted',
      'dashboard': 'Dashboard',
      'kanban': 'Kanban',
      'applications': 'Applications',
      'reminders': 'Reminders',
      'stats': 'Stats',
      'help': 'Help',
      'add_new': 'New application',
      'confirm': 'Confirm',
      'delete_question': 'Delete this application?',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'chart': 'Chart',
      'no_data': 'No data',
      'chart_placeholder': 'Chart placeholder',
      'instruction': 'User guide',
      'export_sent': 'Export sent applications',
      'sent_export_title': 'Sent applications',
      'no_sent_to_export': 'No sent applications to export',
    },
    'fr': {
      'appTitle': 'JobTracker Pro',
      'company': 'Entreprise',
      'job_title': 'Titre du poste',
      'required': 'Requis',
      'city': 'Ville',
      'recruiter_email': 'Email recruteur',
      'followup_date': 'Date de relance',
      'followup': 'Relance',
      'save': 'Enregistrer',
      'total': 'Total',
      'prepare': 'À préparer',
      'sent': 'Envoyées',
      'interview': 'Entretien',
      'interviews': 'Entretiens',
      'followUp': 'À relancer',
      'followups': 'Relances',
      'rejected': 'Refusées',
      'accepted': 'Acceptées',
      'dashboard': 'Tableau de bord',
      'kanban': 'Kanban',
      'applications': 'Candidatures',
      'reminders': 'Relances',
      'stats': 'Stats',
      'help': 'Mode d\'emploi',
      'add_new': 'Nouvelle candidature',
      'confirm': 'Confirmer',
      'delete_question': 'Supprimer cette candidature ?',
      'cancel': 'Annuler',
      'delete': 'Supprimer',
      'edit': 'Modifier',
      'chart': 'Graphique',
      'no_data': 'Aucune donnée',
      'chart_placeholder': 'Zone graphique',
      'instruction': 'Mode d\'emploi',
      'export_sent': 'Exporter les annonces postulées',
      'sent_export_title': 'Annonces postulées',
      'no_sent_to_export': 'Aucune annonce postulée à exporter',
    }
  };

  String t(String key) {
    final map =
        _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
    return map[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
