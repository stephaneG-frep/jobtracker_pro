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
      'no_applications': 'No applications',
      'search_hint': 'Search (company, job, city, contact...)',
      'clear_search': 'Clear search',
      'no_results': 'No matching applications',
      'export_period': 'Period to export',
      'no_sent_in_period': 'No sent applications in this period',
      'week_range': 'From Saturday {start} to Friday {end}',
      'theme': 'Theme',
      'theme_light': 'Light',
      'theme_balanced': '50/50',
      'theme_dark': 'Dark',
      'followup_planned': 'Follow-up planned: {date}',
      'mark_followed_up': 'Mark as followed up',
      'no_followups': 'No follow-ups due',
      'statistics': 'Statistics',
      'response_rate': 'Response rate',
      'status': 'Status',
      'date': 'Date',
      'period': 'Period: {from} -> {to}',
      'help_welcome': 'Welcome to JobTracker Pro',
      'help_intro': 'This quick guide helps you track your job offers, applications and follow-ups. Your data stays on your phone.',
      'help_dashboard': 'Shows the total number of applications and how many are sent, to follow up, in interview, rejected or accepted, with a chart of the breakdown. Tap a statistic to open the matching list.',
      'help_kanban': 'One column per status. Scroll the columns horizontally with your finger. To change the status of an application, long-press a card, then drag it to another column.',
      'help_applications': 'All your applications, grouped by Saturday-to-Friday weeks, most recent first. Tap a card or the pencil to edit it. To delete it, use the bin or swipe the card sideways, then confirm.',
      'search': 'Search',
      'help_search': 'At the top of the Applications page, type one or more words to filter by company, job, city, contact, email or notes. Case and accents are ignored, and every word must match: "symfony paris" only keeps the Symfony offers in Paris. The cross clears the search.',
      'export': 'Export',
      'help_export': 'On the Applications page, tap the download icon at the top right, then choose the period to include (by default, from your oldest sent application to today). The PDF contains only the applications with the Sent status in that period, and can be shared or saved.',
      'help_reminders': 'Lists the applications whose follow-up date is past or due within 24 hours. "Mark as followed up" removes the follow-up date; an application in To follow up goes back to Sent, any other status is kept.',
      'help_stats': 'The response rate is the share of sent applications that received an answer (interview, rejection or acceptance); applications still to prepare are not counted. Also shows the number of interviews, rejections and acceptances.',
      'themes': 'Themes',
      'help_themes': 'Use the theme icon in the top bar to choose Light, 50/50 or Dark. Your choice is saved automatically.',
      'statuses': 'Statuses',
      'help_statuses': 'The main statuses are To prepare, Sent, Follow-up, Interview, Rejected and Accepted.',
      'tip': 'Tip',
      'help_tip': 'Use the + button in the top bar to quickly add a new application from any page. When you edit an application, its original date is kept so it stays in the right week.',
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
      'no_applications': 'Aucune candidature',
      'search_hint': 'Rechercher (entreprise, poste, ville, contact…)',
      'clear_search': 'Effacer la recherche',
      'no_results': 'Aucune candidature ne correspond',
      'export_period': 'Période à exporter',
      'no_sent_in_period': 'Aucune annonce postulée sur cette période',
      'week_range': 'Du samedi {start} au vendredi {end}',
      'theme': 'Thème',
      'theme_light': 'Clair',
      'theme_balanced': '50/50',
      'theme_dark': 'Foncé',
      'followup_planned': 'Relance prévue : {date}',
      'mark_followed_up': 'Marquer relancée',
      'no_followups': 'Aucune relance à faire',
      'statistics': 'Statistiques',
      'response_rate': 'Taux de réponse',
      'status': 'Statut',
      'date': 'Date',
      'period': 'Période : {from} -> {to}',
      'help_welcome': 'Bienvenue dans JobTracker Pro',
      'help_intro': 'Ce guide rapide vous aide à suivre vos annonces, vos candidatures et vos relances. Vos données restent sur votre téléphone.',
      'help_dashboard': 'Affiche le nombre total de candidatures et combien sont envoyées, à relancer, en entretien, refusées ou acceptées, avec un graphique de la répartition. Touchez une statistique pour ouvrir la liste correspondante.',
      'help_kanban': 'Une colonne par statut. Faites défiler les colonnes horizontalement avec le doigt. Pour changer le statut d\'une candidature, faites un appui long sur une carte, puis glissez-la vers une autre colonne.',
      'help_applications': 'Toutes vos candidatures, rangées par semaines du samedi au vendredi, les plus récentes en premier. Touchez une carte ou le crayon pour la modifier. Pour la supprimer, utilisez la corbeille ou faites glisser la carte sur le côté, puis confirmez.',
      'search': 'Recherche',
      'help_search': 'En haut de la page Candidatures, tapez un ou plusieurs mots pour filtrer par entreprise, poste, ville, contact, email ou notes. Les majuscules et les accents sont ignorés, et chaque mot doit correspondre : « symfony paris » ne garde que les annonces Symfony à Paris. La croix efface la recherche.',
      'export': 'Export',
      'help_export': 'Dans la page Candidatures, touchez l\'icône de téléchargement en haut à droite, puis choisissez la période à inclure (par défaut, de votre plus ancienne candidature envoyée à aujourd\'hui). Le PDF contient uniquement les annonces au statut Envoyées sur cette période, et peut être partagé ou enregistré.',
      'help_reminders': 'Liste les candidatures dont la date de relance est passée ou tombe dans les 24 heures. « Marquer relancée » retire la date de relance : une candidature À relancer repasse en Envoyées, les autres statuts sont conservés.',
      'help_stats': 'Le taux de réponse est la part des candidatures envoyées qui ont reçu une réponse (entretien, refus ou acceptation) ; les candidatures À préparer ne sont pas comptées. Affiche aussi le nombre d\'entretiens, de refus et d\'acceptations.',
      'themes': 'Thèmes',
      'help_themes': 'Utilisez l\'icône de thème dans la barre du haut pour choisir Clair, 50/50 ou Foncé. Votre choix est mémorisé automatiquement.',
      'statuses': 'Statuts',
      'help_statuses': 'Les statuts principaux sont À préparer, Envoyées, À relancer, Entretien, Refusées et Acceptées.',
      'tip': 'Astuce',
      'help_tip': 'Utilisez le bouton + de la barre du haut pour ajouter rapidement une candidature depuis n\'importe quelle page. Quand vous modifiez une annonce, sa date d\'origine est conservée pour garder le bon rangement hebdomadaire.',
    }
  };

  /// Returns the text for [key], replacing each `{name}` with [params]`[name]`.
  String t(String key, [Map<String, Object> params = const {}]) {
    final map =
        _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
    var text = map[key] ?? key;
    params.forEach((name, value) => text = text.replaceAll('{$name}', '$value'));
    return text;
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
