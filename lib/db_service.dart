import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('depression_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE UserProfile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE TestResults (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        score INTEGER NOT NULL,
        severity TEXT NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES UserProfile (id)
      )
    ''');

    // Create NeuroticTestResults table for neurotic personality test
    await db.execute('''
      CREATE TABLE NeuroticTestResults (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        score INTEGER NOT NULL,
        risk_level TEXT NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES UserProfile (id)
      )
    ''');
  }

  // Handle database upgrades (e.g., adding a new table)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE NeuroticTestResults (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          score INTEGER NOT NULL,
          risk_level TEXT NOT NULL,
          date TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES UserProfile (id)
        )
      ''');
    }
  }

  // Insert new user
  Future<int> insertUser(String name, int age) async {
    final db = await instance.database;
    return await db.insert('UserProfile', {'name': name, 'age': age});
  }

  // Insert test result for depression test
  Future<int> insertTestResult(int userId, int score, String severity) async {
    final db = await instance.database;
    return await db.insert('TestResults', {
      'user_id': userId,
      'score': score,
      'severity': severity,
      'date': DateTime.now().toIso8601String(),
    });
  }

  // Insert test result for neurotic personality test
  Future<int> insertNeuroticTestResult(int userId, int score, String riskLevel) async {
    final db = await instance.database;
    return await db.insert('NeuroticTestResults', {
      'user_id': userId,
      'score': score,
      'risk_level': riskLevel,
      'date': DateTime.now().toIso8601String(),
    });
  }

  // Retrieve user scores along with severity and date for depression test
  Future<List<Map<String, dynamic>>> getUserScores() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT UserProfile.name, TestResults.score, TestResults.severity, TestResults.date
      FROM UserProfile
      JOIN TestResults ON UserProfile.id = TestResults.user_id
      ORDER BY TestResults.date DESC
    ''');
  }

  // Retrieve user scores along with risk level and date for neurotic test
  Future<List<Map<String, dynamic>>> getNeuroticTestScores() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT UserProfile.name, NeuroticTestResults.score, NeuroticTestResults.risk_level, NeuroticTestResults.date
      FROM UserProfile
      JOIN NeuroticTestResults ON UserProfile.id = NeuroticTestResults.user_id
      ORDER BY NeuroticTestResults.date DESC
    ''');
  }

  // Retrieve a user by ID
  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await instance.database;
    final result = await db.query(
      'UserProfile',
      where: 'id = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Update an existing user profile
  Future<int> updateUser(int userId, String name, int age) async {
    final db = await instance.database;
    return await db.update(
      'UserProfile',
      {'name': name, 'age': age},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
