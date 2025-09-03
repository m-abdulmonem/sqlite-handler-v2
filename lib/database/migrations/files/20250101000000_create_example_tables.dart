import 'package:sqflite_common/sqlite_api.dart';
import '../migration.dart';

class Migration_20250101000000_create_example_tables extends Migration {
  @override
  String get id => '20250101000000_create_example_tables';

  @override
  Future<void> up(DatabaseExecutor db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        password TEXT,
        bio TEXT,
        is_active INTEGER,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS compaines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS persons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        password TEXT,
        company_id INTEGER,
        created_at TEXT,
        FOREIGN KEY(company_id) REFERENCES compaines(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS departments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS department_persons (
        department_id INTEGER,
        person_id INTEGER,
        PRIMARY KEY(department_id, person_id),
        FOREIGN KEY(department_id) REFERENCES departments(id),
        FOREIGN KEY(person_id) REFERENCES persons(id)
      )
    ''');
  }

  @override
  Future<void> down(DatabaseExecutor db) async {
    await db.execute('DROP TABLE IF EXISTS department_persons');
    await db.execute('DROP TABLE IF EXISTS departments');
    await db.execute('DROP TABLE IF EXISTS persons');
    await db.execute('DROP TABLE IF EXISTS compaines');
    await db.execute('DROP TABLE IF EXISTS users');
  }
}


