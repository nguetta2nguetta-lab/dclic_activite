import 'package:flutter/material.dart';
import 'modele/redacteur.dart';
import 'services/database_manager.dart';

class Redacteurs extends StatefulWidget {
  const Redacteurs({super.key});
  @override
  _RedacteursState createState() => _RedacteursState();
}

class _RedacteursState extends State<Redacteurs> {
  final DatabaseManager dbManager = DatabaseManager();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  List<Redacteur> redacteurs = [];

  @override
  void initState() {
    super.initState();
    _chargerRedacteurs();
  }

  _chargerRedacteurs() async {
    List<Redacteur> liste = await dbManager.getAllRedacteurs();
    setState(() => redacteurs = liste);
  }

  _ajouterRedacteur() async {
    await dbManager.insertRedacteur(Redacteur.sansId(
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text
    ));
    _viderChamps();
    _chargerRedacteurs();
  }

  _modifierRedacteur(Redacteur redacteur) async {
    await dbManager.updateRedacteur(redacteur);
    _chargerRedacteurs();
  }

  _supprimerRedacteur(int id) async {
    await dbManager.deleteRedacteur(id);
    _chargerRedacteurs();
  }

  _viderChamps() {
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();
  }

  _dialogueModification(Redacteur redacteur) {
    TextEditingController nomCtrl = TextEditingController(text: redacteur.nom);
    TextEditingController prenomCtrl = TextEditingController(text: redacteur.prenom);
    TextEditingController emailCtrl = TextEditingController(text: redacteur.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier le rédacteur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomCtrl, decoration: InputDecoration(labelText: 'Nom')),
            TextField(controller: prenomCtrl, decoration: InputDecoration(labelText: 'Prénom')),
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Redacteur r = Redacteur(
                    id: redacteur.id,
                    nom: nomCtrl.text,
                    prenom: prenomCtrl.text,
                    email: emailCtrl.text
                );
                _modifierRedacteur(r);
                Navigator.pop(context);
              },
              child: Text('Enregistrer')
          )
        ],
      ),
    );
  }

  _dialogueSuppression(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ce rédacteur ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler')
          ),
          TextButton(
              onPressed: () {
                _supprimerRedacteur(id);
                Navigator.pop(context);
              },
              child: Text('Supprimer')
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(controller: _nomController, decoration: InputDecoration(labelText: 'Nom')),
          TextField(controller: _prenomController, decoration: InputDecoration(labelText: 'Prénom')),
          TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Ajouter un rédacteur',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _ajouterRedacteur,
          ),

          Expanded(
            child: ListView.builder(
              itemCount: redacteurs.length,
              itemBuilder: (context, index) => ListTile(
                title: Text('${redacteurs[index].prenom} ${redacteurs[index].nom}'),
                subtitle: Text(redacteurs[index].email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _dialogueModification(redacteurs[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _dialogueSuppression(redacteurs[index].id!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}