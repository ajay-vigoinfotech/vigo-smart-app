import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'activity_questions.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE activity_questions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          activityId INTEGER,
          activityName TEXT,
          questionId INTEGER,
          questionName TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE assign_site_list (
          siteId INTEGER,         
          compID INTEGER,
          clientId INTEGER,
          siteName TEXT,
          siteCode TEXT,          
          unitName TEXT,
          clientName TEXT
        )
      ''');
      },
    );
  }

  Future<void> insertAssignSiteList(List<Map<String, dynamic>> siteList) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        const batchSize = 500;
        for (var i = 0; i < siteList.length; i += batchSize) {
          final chunk = siteList.sublist(i, i + batchSize < siteList.length ? i + batchSize : siteList.length);
          Batch batch = txn.batch();
          for (var site in chunk) {
            //print("Inserting: $site");
            batch.insert('assign_site_list', site, conflictAlgorithm: ConflictAlgorithm.replace);
          }
          await batch.commit(noResult: true);
        }
      });
    } catch (e) {
      print("Error inserting site list: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllAssignSite() async {
    final db = await database;
    return await db.query('assign_site_list');
  }

  Future<void> insertActivityQuestions(
      List<Map<String, dynamic>> questions) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete('activity_questions');

      Batch batch = txn.batch();
      for (var question in questions) {
        batch.insert('activity_questions', question
            , conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<List<Map<String, dynamic>>> fetchAllQuestions() async {
    final db = await database;
    return await db.query('activity_questions');
  }
}
