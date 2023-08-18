import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        color_settings TEXT,
        is_active INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE session_login (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        date TEXT,
        is_active INTEGER,
        FOREIGN KEY (user_id) REFERENCES users (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY,
        content TEXT,
        icon TEXT
      );
    ''');

    await db.execute('''
  CREATE TABLE daily_tasks (
    id INTEGER PRIMARY KEY,
    task_id INTEGER,
    day_task TEXT,
    fecha_finalizacion TEXT,
    hora_finalizacion TEXT,
    is_completed INTEGER,
    sesion_id INTEGER, 
    FOREIGN KEY (task_id) REFERENCES tasks (id),
    FOREIGN KEY (sesion_id) REFERENCES session_login (id)
  );
''');

    await db.execute('''
      CREATE TABLE daily_reports (
        id INTEGER PRIMARY KEY,
        daily_task_id INTEGER,
        report_id INTEGER,
        sesion_id INTEGER,
        score TEXT,
        FOREIGN KEY (daily_task_id) REFERENCES daily_tasks (id),
        FOREIGN KEY (report_id) REFERENCES reports (id)
      );
    ''');
  }
}
