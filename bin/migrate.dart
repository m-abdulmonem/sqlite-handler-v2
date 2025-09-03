import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'package:sqlite_handler/database/migrations/migration.dart';
import 'package:sqlite_handler/database/migrations/migrations_index.dart';

void main(List<String> args) async {
  // Initialize FFI for desktop/CLI environments
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final String command = args.isNotEmpty ? args.first : 'help';

  final Database db = await _openCliDatabase();
  final runner = MigrationRunner(allMigrations);

  switch (command) {
    case 'migrate':
      await runner.migrate(db);
      stdout.writeln('Migrations run successfully.');
      break;
    case 'rollback':
      await runner.rollback(db);
      stdout.writeln('Rolled back last migration.');
      break;
    case 'status':
      final statuses = await runner.status(db);
      for (final (id, applied) in statuses) {
        stdout.writeln('[${applied ? 'X' : ' '}] $id');
      }
      break;
    case 'make:migration':
      final name = args.length > 1 ? args[1] : null;
      if (name == null) {
        stderr.writeln('Usage: migrate make:migration <name>');
        exitCode = 64;
        break;
      }
      await _makeMigration(name);
      stdout.writeln('Created migration for "$name".');
      break;
    default:
      _printHelp();
  }

  await db.close();
}

Future<Database> _openCliDatabase() async {
  final String cwd = Directory.current.path;
  final String dbDir = p.join(cwd, 'build');
  final String dbPath = p.join(dbDir, 'sqlite_handler_cli.db');
  await Directory(dbDir).create(recursive: true);
  return openDatabase(dbPath);
}

Future<void> _makeMigration(String name) async {
  final String timestamp = DateTime.now().toUtc().toIso8601String().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 14);
  final String fileName = '${timestamp}_${name}.dart';
  final String dir = p.join('lib', 'database', 'migrations', 'files');
  await Directory(dir).create(recursive: true);
  final File file = File(p.join(dir, fileName));
  if (await file.exists()) {
    throw StateError('Migration file already exists: ${file.path}');
  }
  await file.writeAsString(_migrationTemplate(timestamp, name));

  // Append export to index for easy discovery
  final File index = File(p.join('lib', 'database', 'migrations', 'migrations_index.dart'));
  if (!await index.exists()) {
    await index.writeAsString(
      """// created automatically\nimport 'migration.dart';\n\n// Export migration files here (added by generator)\n// export 'files/XXXXXXXXXXXXXX_name.dart';\n\nfinal List<Migration> allMigrations = [\n  // Add your migrations here in order\n];\n""",
    );
  }
  final existing = await index.readAsString();
  final relPath = "files/${fileName}";
  if (!existing.contains(relPath)) {
    final updated = StringBuffer();
    updated.writeln(existing.trimRight());
    updated.writeln("export '${relPath}';");
    await index.writeAsString(updated.toString());
  }
}

String _migrationTemplate(String id, String name) => """
import 'package:sqflite_common//*-+.dart';
import '../migration.dart';

class Migration_${id}_$name extends Migration {
  @override
  String get id => '${id}_${name}';

  @override
  Future<void> up(DatabaseExecutor db) async {
    // TODO: implement schema changes, e.g.:
    // await db.execute('CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)');
  }

  @override
  Future<void> down(DatabaseExecutor db) async {
    // TODO: reverse schema changes, e.g.:
    // await db.execute('DROP TABLE IF EXISTS users');
  }
}
""";

void _printHelp() {
  stdout.writeln('Usage: dart run bin/migrate.dart <command>');
  stdout.writeln('Commands:');
  stdout.writeln('  migrate            Apply all pending migrations');
  stdout.writeln('  rollback           Roll back the last applied migration');
  stdout.writeln('  status             Show status of migrations');
  stdout.writeln('  make:migration <name>  Create a new migration file');
}


