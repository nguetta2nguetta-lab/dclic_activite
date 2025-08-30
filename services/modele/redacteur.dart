class Redacteur {
  int? id;
  final String nom;
  final String prenom;
  final String email;

  Redacteur({this.id, required this.nom, required this.prenom, required this.email});

  Redacteur.sansId({required this.nom, required this.prenom, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }
}