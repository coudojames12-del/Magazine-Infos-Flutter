import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
// Changement d'import : nous utilisons maintenant le modèle Redacteur
import 'package:activite3/models/redacteur.dart';

// Renommée en DatabaseManager

class DatabaseManager {
  static Database? _database;

  static const String tableName = 'redacteurs'; // Nom de la table

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB();

    return _database!;
  }

  // Initialisation pour initialiser la base de données SQLite avec une table redacteurs.

  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'redacteurs_database.db');

    return await openDatabase(
      path,

      version: 1, // Version du schéma

      onCreate: _createDB,
    );
  }

  // Création des tables

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''

CREATE TABLE $tableName(

id INTEGER PRIMARY KEY AUTOINCREMENT,

nom TEXT,

prenom TEXT,

email TEXT

)

''');
  }

  // ----------------------------------------------------

  // Opérations CRUD spécifiques aux Rédacteurs

  // ----------------------------------------------------

  // insertRedacteur: pour ajouter un rédacteur à la base de données.

  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await database;

    return await db.insert(
      tableName,
      redacteur.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // getAllRedacteurs: pour récupérer tous les rédacteurs de la base de données.

  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    // Convertit la List<Map> en List<Redacteur>

    return List.generate(maps.length, (i) {
      return Redacteur.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRedacteurs() async {
    try {
      final db = await database;
      return await db.query('redacteurs');
    } catch (e) {
      // ⚠️ IMPORTANT: Loggez l'erreur pour la voir dans la console!
      print('Erreur lors de la lecture des rédacteurs: $e');
      // Retournez une liste vide pour ne pas bloquer l'UI
      return [];
    }
  }
  // updateRedacteur: pour mettre à jour les informations d'un rédacteur.

  Future<int> updateRedacteur(Redacteur redacteur) async {
    final db = await database;

    return await db.update(
      tableName,
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  // deleteRedacteur: pour supprimer un rédacteur de la base de données.

  Future<int> deleteRedacteur(int id) async {
    final db = await database;

    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
