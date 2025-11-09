// Importation des outils de test de Flutter
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Importation du fichier principal de l'application
import 'package:activite3/main.dart';
// Importation des dépendances nécessaires pour la simulation de DB
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Initialise sqflite_ffi pour que les tests puissent utiliser la DB
void sqfliteTestInit() {
  // Initialise l'interface ffi pour les tests desktop
  sqfliteFfiInit();
  // Utilise l'implémentation ffi pour les tests
  databaseFactory = databaseFactoryFfi;
}

void main() {
  // Initialisation de la base de données en mémoire pour le test
  // Doit être appelé avant les tests qui interagissent avec la DB
  sqfliteTestInit();

  // Test 1: Vérifie le démarrage de l'application et l'affichage des éléments de base
  testWidgets('L\'application démarre et affiche les champs de saisie', (
    WidgetTester tester,
  ) async {
    // 1. Démarrage
    await tester.pumpWidget(const MonApplication());

    // 2. Vérification des éléments de l'interface

    // Vérifie le titre de l'AppBar
    expect(find.text('Gestion des rédacteurs'), findsOneWidget);

    // Vérifie les champs de saisie
    expect(find.byType(TextField), findsNWidgets(3)); // Nom, Prénom, Email
    expect(find.widgetWithText(TextField, 'Nom'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Prénom'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);

    // Vérifie le bouton d'ajout
    expect(find.text('Ajouter un Rédacteur'), findsOneWidget);

    // Vérifie le message "Aucun rédacteur" (car la DB est vide au départ)
    expect(
      find.text("Aucun rédacteur enregistré pour le moment."),
      findsOneWidget,
    );
  });

  // Test 2: Simule l'ajout d'un rédacteur
  testWidgets('L\'ajout d\'un rédacteur met à jour la liste', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MonApplication());

    // 1. Entrer les données dans les champs de texte
    await tester.enterText(find.widgetWithText(TextField, 'Nom'), 'Dupont');
    await tester.enterText(find.widgetWithText(TextField, 'Prénom'), 'Jean');
    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'jean.dupont@test.com',
    );

    // 2. Appuyer sur le bouton d'ajout
    await tester.tap(find.text('Ajouter un Rédacteur'));

    // 3. Déclenche un frame pour que l'ajout, l'insertion en DB et le refresh s'exécutent
    // On utilise pumpAndSettle pour attendre que toutes les animations/microtasks soient terminées
    await tester.pumpAndSettle();

    // 4. Vérification
    // Le message "Aucun rédacteur" doit disparaître
    expect(
      find.text("Aucun rédacteur enregistré pour le moment."),
      findsNothing,
    );

    // L'élément ajouté doit être visible dans le ListView
    expect(find.text('Dupont Jean'), findsOneWidget);
    expect(find.text('jean.dupont@test.com'), findsOneWidget);
  });
}
