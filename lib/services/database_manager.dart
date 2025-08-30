import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modele/redacteur.dart';

class DatabaseManager {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'redacteurs.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE redacteurs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        prenom TEXT,
        email TEXT
      )
    ''');
  }

  Future<List<Redacteur>> getAllRedacteurs() async {
    Database db = await database;
    List<Map> maps = await db.query('redacteurs');
    return maps.map((map) => Redacteur(
        id: map['id'],
        nom: map['nom'],
        prenom: map['prenom'],
        email: map['email']
    )).toList();
  }

  Future<int> insertRedacteur(Redacteur redacteur) async {
    Database db = await database;
    return await db.insert('redacteurs', redacteur.toMap());
  }

  Future<int> updateRedacteur(Redacteur redacteur) async {
    Database db = await database;
    return await db.update(
        'redacteurs',
        redacteur.toMap(),
        where: 'id = ?',
        whereArgs: [redacteur.id]
    );
  }

  Future<int> deleteRedacteur(int id) async {
    Database db = await database;
    return await db.delete(
        'redacteurs',
        where: 'id = ?',
        whereArgs: [id]
    );
  }
}