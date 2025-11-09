import 'package:flutter/material.dart';
// Correction des chemins d'importation vers les fichiers locaux
import '../models/redacteur.dart';
import '../services/database_manager.dart';

// 3. Créez le Widget RedacteurInterface pour gérer les rédacteurs.
class RedacteursInterface extends StatefulWidget {
  const RedacteursInterface({super.key});

  @override
  State<RedacteursInterface> createState() => _RedacteursInterfaceState();
}

class _RedacteursInterfaceState extends State<RedacteursInterface> {
  // Contrôleurs de texte pour les champs de saisie
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Liste pour stocker les rédacteurs lus de la base de données
  List<Redacteur> _redacteurs = [];
  final DatabaseManager _dbManager = DatabaseManager();
  bool _isLoading = true; // Ajout d'un état de chargement

  @override
  void initState() {
    super.initState();
    // Charger les rédacteurs au démarrage de l'application
    _refreshRedacteurs();
  }

  // Méthode pour lire tous les rédacteurs et mettre à jour l'interface
  void _refreshRedacteurs() async {
    final data = await _dbManager.getAllRedacteurs();
    setState(() {
      _redacteurs = data;
      _isLoading = false; // Fin du chargement
    });
  }

  // Logique d'ajout d'un rédacteur
  Future<void> _addRedacteur() async {
    // Vérification basique des champs non vides
    if (_nomController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        _emailController.text.isEmpty) {
      // Pour une meilleure expérience utilisateur, vous pourriez afficher un SnackBar ici
      return;
    }

    final nouveauRedacteur = Redacteur.sansId(
      nom: _nomController.text,
      prenom: _prenomController.text,
      email: _emailController.text,
    );

    // Insérer dans la base de données
    await _dbManager.insertRedacteur(nouveauRedacteur);

    // Vider les champs et rafraîchir la liste
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();
    _refreshRedacteurs();
  }

  // Logique de mise à jour
  Future<void> _updateRedacteur(Redacteur redacteur) async {
    // Vérification basique au cas où l'utilisateur viderait tous les champs dans la boîte de dialogue
    if (redacteur.nom.isEmpty ||
        redacteur.prenom.isEmpty ||
        redacteur.email.isEmpty) {
      return;
    }
    await _dbManager.updateRedacteur(redacteur);
    _refreshRedacteurs();
  }

  // Logique de suppression
  Future<void> _deleteRedacteur(int id) async {
    await _dbManager.deleteRedacteur(id);
    _refreshRedacteurs();
  }

  // Affiche la boîte de dialogue de modification
  void _showEditDialog(Redacteur redacteur) {
    // Initialiser les contrôleurs avec les valeurs existantes
    final editNomController = TextEditingController(text: redacteur.nom);
    final editPrenomController = TextEditingController(text: redacteur.prenom);
    final editEmailController = TextEditingController(text: redacteur.email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier Rédacteur'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editNomController,
                  decoration: const InputDecoration(labelText: 'Nouveau Nom'),
                ),
                TextField(
                  controller: editPrenomController,
                  decoration: const InputDecoration(
                    labelText: 'Nouveau Prénom',
                  ),
                ),
                TextField(
                  controller: editEmailController,
                  decoration: const InputDecoration(labelText: 'Nouvel Email'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Annuler
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Créer le rédacteur mis à jour
                final updatedRedacteur = Redacteur(
                  id: redacteur.id,
                  nom: editNomController.text,
                  prenom: editPrenomController.text,
                  email: editEmailController.text,
                );
                _updateRedacteur(updatedRedacteur);
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  // Affiche la boîte de dialogue de confirmation de suppression
  void _showDeleteConfirmDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text(
            'Êtes-vous sûr de vouloir supprimer ce rédacteur ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteRedacteur(id);
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // L'AppBar
      appBar: AppBar(
        title: const Text('Gestion des rédacteurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Logique de recherche future
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Logique du menu future
          },
        ),
      ),
      body: Column(
        children: [
          // Section d'ajout (champs de texte et bouton)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Champ de texte pour le Nom
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // Champ de texte pour le Prénom
                TextField(
                  controller: _prenomController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // Champ de texte pour l'Email
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // Bouton "Ajouter un Rédacteur"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addRedacteur, // Logique d'ajout
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un Rédacteur'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Titre de la liste
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Liste des Rédacteurs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Affichage de l'état (Chargement ou Liste)
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Colors.pink),
                )
              : _redacteurs.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Aucun rédacteur enregistré pour le moment.",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              : Expanded(
                  // Liste des rédacteurs
                  child: ListView.builder(
                    itemCount: _redacteurs.length,
                    itemBuilder: (context, index) {
                      final redacteur = _redacteurs[index];
                      return ListTile(
                        leading: const Icon(Icons.person, color: Colors.pink),
                        title: Text(
                          '${redacteur.nom} ${redacteur.prenom}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ), // Nom et Prénom
                        subtitle: Text(redacteur.email), // Email
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icône de modification
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditDialog(
                                redacteur,
                              ), // Fonction de modification
                            ),
                            // Icône de suppression
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              // L'ID est garanti non nul ici
                              onPressed: () => _showDeleteConfirmDialog(
                                redacteur.id!,
                              ), // Fonction de suppression
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
