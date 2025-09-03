import 'package:sqflite_common/sqlite_api.dart';
export 'schema/schema.dart';
export 'package:sqflite_common/sqlite_api.dart';

/// Base class for Laravel-style migrations
abstract class Migration {
  /// Unique identifier, typically a timestamp + name (e.g., 20250902_create_users_table)
  String get id;

  /// Apply the migration
  Future<void> up(DatabaseExecutor db);

  /// Revert the migration
  Future<void> down(DatabaseExecutor db);
}

/// Records and manages applied migrations
class MigrationStore {
  static const String _table = 'migrations';

  /// Ensures the migrations table exists
  static Future<void> ensureInitialized(DatabaseExecutor db) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $_table (id TEXT PRIMARY KEY, ran_at TEXT NOT NULL)');
  }

  static Future<Set<String>> applied(DatabaseExecutor db) async {
    final List<Map<String, Object?>> rows =
        await db.query(_table, columns: ['id']);
    return rows.map((r) => r['id'] as String).toSet();
  }

  static Future<void> markApplied(DatabaseExecutor db, String id) async {
    await db.insert(_table, {
      'id': id,
      'ran_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> markRolledBack(DatabaseExecutor db, String id) async {
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}

/// Runs migrations forward/back similar to Laravel artisan migrate
class MigrationRunner {
  final List<Migration> migrations;

  MigrationRunner(this.migrations);

  /// Apply all pending migrations, in order
  Future<void> migrate(Database db) async {
    await MigrationStore.ensureInitialized(db);
    final Set<String> done = await MigrationStore.applied(db);

    for (final migration in migrations) {
      if (!done.contains(migration.id)) {
        await db.transaction((txn) async {
          await migration.up(txn);
          await MigrationStore.markApplied(txn, migration.id);
        });
      }
    }
  }

  /// Roll back the last run migration (single step)
  Future<void> rollback(Database db) async {
    await MigrationStore.ensureInitialized(db);
    final appliedIds = await _appliedInOrder(db);
    if (appliedIds.isEmpty) return;

    final String lastId = appliedIds.last;
    final Migration target = migrations.lastWhere(
      (m) => m.id == lastId,
      orElse: () => _MissingMigration(lastId),
    );

    await db.transaction((txn) async {
      await target.down(txn);
      await MigrationStore.markRolledBack(txn, lastId);
    });
  }

  /// List migrations with their status
  Future<List<(String id, bool applied)>> status(Database db) async {
    await MigrationStore.ensureInitialized(db);
    final Set<String> done = await MigrationStore.applied(db);
    return migrations.map((m) => (m.id, done.contains(m.id))).toList();
  }

  Future<List<String>> _appliedInOrder(Database db) async {
    final rows =
        await db.query('migrations', columns: ['id'], orderBy: 'ran_at ASC');
    return rows.map((r) => r['id'] as String).toList();
  }
}

class _MissingMigration extends Migration {
  final String _id;
  _MissingMigration(this._id);

  @override
  String get id => _id;

  @override
  Future<void> down(DatabaseExecutor db) async {
    // If the migration file is missing, the safest rollback is a no-op.
    // Users should manually adjust if needed.
  }

  @override
  Future<void> up(DatabaseExecutor db) async {
    // not used
  }
}
