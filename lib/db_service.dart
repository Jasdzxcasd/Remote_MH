import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

    return await openDatabase(path, version: 3, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future<void> _createDB(Database db, int version) async {
    print('📌 Creating Database...');

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
        emotion_data TEXT, -- Ensure this column exists!
        FOREIGN KEY (user_id) REFERENCES UserProfile (id)
      )
    ''');

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

    print('✅ Database created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('⚙️ Upgrading database from $oldVersion to $newVersion...');

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
      print('✅ NeuroticTestResults table added');
    }

    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE TestResults ADD COLUMN emotion_data TEXT;
      ''');
      print('✅ emotion_data column added to TestResults');
    }
  }

  Future<int> insertUser(String name, int age) async {
    final db = await instance.database;
    int id = await db.insert('UserProfile', {'name': name, 'age': age});

    print('✅ User inserted: ID = $id, Name = $name, Age = $age');
    return id;
  }

  Future<int> insertTestResult(int userId, int score, String severity, String emotionData) async {
    final db = await instance.database;

    print('🔍 Inserting Test Result: User ID = $userId, Score = $score, Severity = $severity, Emotion = $emotionData');

    int id = await db.insert('TestResults', {
      'user_id': userId,
      'score': score,
      'severity': severity,
      'date': DateTime.now().toIso8601String(),
      'emotion_data': emotionData, // Make sure this is being stored correctly
    });

    print('✅ Test result inserted: ID = $id, User ID = $userId, Score = $score, Severity = $severity, Emotion = $emotionData');
    return id;
  }

  Future<int> insertNeuroticTestResult(int userId, int score, String riskLevel) async {
    final db = await instance.database;
    int id = await db.insert('NeuroticTestResults', {
      'user_id': userId,
      'score': score,
      'risk_level': riskLevel,
      'date': DateTime.now().toIso8601String(),
    });

    print('✅ Neurotic test result inserted: ID = $id, User ID = $userId, Score = $score, Risk Level = $riskLevel');
    return id;
  }

  Future<List<Map<String, dynamic>>> getUserScores() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT UserProfile.name, TestResults.score, TestResults.severity, TestResults.date, TestResults.emotion_data
      FROM UserProfile
      JOIN TestResults ON UserProfile.id = TestResults.user_id
      ORDER BY TestResults.date DESC
    ''');

    print('📊 Retrieved ${result.length} user test results');
    for (var row in result) {
      print('User: ${row['name']}, Score: ${row['score']}, Severity: ${row['severity']}, Date: ${row['date']}, Emotion: ${row['emotion_data']}');
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getNeuroticTestScores() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT UserProfile.name, NeuroticTestResults.score, NeuroticTestResults.risk_level, NeuroticTestResults.date
      FROM UserProfile
      JOIN NeuroticTestResults ON UserProfile.id = NeuroticTestResults.user_id
      ORDER BY NeuroticTestResults.date DESC
    ''');

    print('📊 Retrieved ${result.length} neurotic test results');
    for (var row in result) {
      print('User: ${row['name']}, Score: ${row['score']}, Risk Level: ${row['risk_level']}, Date: ${row['date']}');
    }
    return result;
  }

  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await instance.database;
    final result = await db.query(
      'UserProfile',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      print('👤 User retrieved: ${result.first}');
      return result.first;
    } else {
      print('❌ No user found with ID = $userId');
      return null;
    }
  }

  Future<int> updateUser(int userId, String name, int age) async {
    final db = await instance.database;
    int rowsAffected = await db.update(
      'UserProfile',
      {'name': name, 'age': age},
      where: 'id = ?',
      whereArgs: [userId],
    );

    print('🔄 Updated user ID = $userId, Name = $name, Age = $age, Rows affected = $rowsAffected');
    return rowsAffected;
  }

  Future<void> checkTableStructure() async {
    final db = await instance.database;
    final result = await db.rawQuery("PRAGMA table_info(TestResults)");
    print('📌 Table Structure for TestResults: $result');
  }
}
