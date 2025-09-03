import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite_handler/database/migrations/migration.dart';
import 'package:sqlite_handler/database/migrations/migrations_index.dart';

Future<String> runMigrationsDemo() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final String dbDir = p.join(Directory.systemTemp.path, 'sqlite_handler_example');
  final String dbPath = p.join(dbDir, 'demo.db');
  await Directory(dbDir).create(recursive: true);

  final Database db = await openDatabase(dbPath);
  final runner = MigrationRunner(allMigrations);
  await runner.migrate(db);
  final statuses = await runner.status(db);
  await db.close();

  return statuses.map((s) => '[${s.$2 ? 'X' : ' '}] ${s.$1}').join('\n');
}


