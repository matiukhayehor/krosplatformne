import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'training_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('trainings.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE trainings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            duration INTEGER NOT NULL,
            date TEXT NOT NULL,
            emoji TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE trainings ADD COLUMN emoji TEXT NOT NULL DEFAULT "🏋️"');
        }
        if (oldVersion < 3) {
          await db.execute('UPDATE trainings SET emoji = "🏋️" WHERE emoji IS NULL');
        }
      },
    );
  }

  Future<int> insertTraining(Training training) async {
    final db = await instance.database;
    return await db.insert(
      'trainings',
      training.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Training>> getTrainings() async {
    final db = await instance.database;
    final result = await db.query('trainings');
    return result.map((map) => Training.fromMap(map)).toList();
  }

  Future<int> deleteTraining(int id) async {
    final db = await instance.database;
    return await db.delete(
      'trainings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}