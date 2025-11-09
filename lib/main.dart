import 'package:flutter/material.dart';
// Importez le widget d'interface que vous devez créer (dans lib/ui/...)
import 'ui/redacteurs_interface.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  runApp(const MonApplication());
}

// Classe StatelessWidget MonApplication
class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    // Le Widget retourne un MaterialApp
    return MaterialApp(
      title: 'Gestion des rédacteurs', // Le titre de l'application
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Configuration de base pour un look "rose" dominant
        primaryColor: Colors.pink,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pink, // Couleur de l'AppBar
          foregroundColor: Colors.white, // Couleur des icônes/texte
        ),
        useMaterial3: true,
      ),
      // La page d'accueil de l'application est RedacteursInterface
      home: const RedacteursInterface(),
    );
  }
}
