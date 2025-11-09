// Modèle de données pour un Rédacteur
class Redacteur {
  // id est nullable car il sera assigné par la base de données lors de l'insertion
  final int? id;
  final String nom;
  final String prenom;
  final String email;

  // Constructeur principal (avec ID, utilisé pour la lecture depuis la DB et la mise à jour)
  Redacteur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Constructeur sans ID (Redacteur.sansId), utilisé pour la création d'un nouvel objet
  Redacteur.sansId({
    required this.nom,
    required this.prenom,
    required this.email,
  }) : id = null;

  // Convertit un objet Redacteur en Map (pour l'insertion ou la mise à jour en DB)
  Map<String, dynamic> toMap() {
    // Si id est null (nouvelle insertion), la DB l'auto-incrémentera.
    return {'id': id, 'nom': nom, 'prenom': prenom, 'email': email};
  }

  // Crée un objet Redacteur à partir d'un Map (pour la lecture depuis la DB)
  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      // L'id est lu comme un int, en toute sécurité
      id: map['id'] as int,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      email: map['email'] as String,
    );
  }
}
