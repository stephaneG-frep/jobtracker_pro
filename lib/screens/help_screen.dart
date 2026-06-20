import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).t('help'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text('Bienvenue dans JobTracker Pro', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Ce guide rapide vous aide à utiliser l\'application.'),
            SizedBox(height: 12),
            Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Affiche le nombre total de candidatures, les relances à faire, les entretiens prévus, les refus et les acceptations.'),
            SizedBox(height: 12),
            Text('Kanban', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Vous pouvez glisser-déposer les cartes pour changer le statut d\'une candidature.'),
            SizedBox(height: 12),
            Text('Candidatures', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Depuis cette page, ajoutez, modifiez ou supprimez une candidature. Appuyez sur une carte pour modifier.'),
            SizedBox(height: 12),
            Text('Relances', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Retrouvez les candidatures avec une relance programmée et marquez-les comme relancées.'),
            SizedBox(height: 12),
            Text('Stats', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Consultez le taux de réponse, le nombre d\'entretiens, de refus et d\'acceptations.'),
            SizedBox(height: 12),
            Text('Astuce', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Utilisez le bouton + sur la page Candidatures pour ajouter une nouvelle candidature.'),
          ],
        ),
      ),
    );
  }
}
