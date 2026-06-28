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
            Text('Bienvenue dans JobTracker Pro',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(
                'Ce guide rapide vous aide à suivre vos annonces, vos candidatures et vos relances.'),
            SizedBox(height: 12),
            Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Affiche le nombre total de candidatures, les annonces envoyées, les relances, les entretiens, les refus et les acceptations. Touchez une statistique pour ouvrir la liste correspondante.'),
            SizedBox(height: 12),
            Text('Kanban', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Faites défiler les colonnes horizontalement avec le doigt. Pour changer le statut d\'une candidature, faites un appui long sur une carte, puis glissez-la vers une autre colonne.'),
            SizedBox(height: 12),
            Text('Candidatures', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Depuis cette page, ajoutez, modifiez ou supprimez une candidature. Les annonces sont rangées par périodes du samedi au vendredi, avec les plus récentes en premier.'),
            SizedBox(height: 12),
            Text('Export', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Dans la page Candidatures, utilisez l\'icône de téléchargement en haut à droite pour exporter en PDF uniquement les annonces au statut Envoyées.'),
            SizedBox(height: 12),
            Text('Relances', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Retrouvez les candidatures avec une relance programmée et marquez-les comme relancées.'),
            SizedBox(height: 12),
            Text('Stats', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Consultez le taux de réponse, le nombre d\'entretiens, de refus et d\'acceptations.'),
            SizedBox(height: 12),
            Text('Thèmes', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Utilisez l\'icône de thème dans la barre du haut pour choisir Clair, 50/50 ou Foncé. Votre choix est mémorisé automatiquement.'),
            SizedBox(height: 12),
            Text('Statuts', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Les statuts principaux sont À préparer, Envoyées, À relancer, Entretien, Refusées et Acceptées.'),
            SizedBox(height: 12),
            Text('Astuce', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Utilisez le bouton + pour ajouter rapidement une nouvelle candidature. Quand vous modifiez une annonce, sa date d\'origine est conservée pour garder le bon rangement hebdomadaire.'),
          ],
        ),
      ),
    );
  }
}
