import 'migration.dart';
import 'files/20250101000000_create_example_tables.dart';

/// Export newly generated migration files from lib/database/migrations/files/* here.
/// The CLI generator will append exports automatically.

// Example:
// export 'files/20250101120000_create_users_table.dart';

final List<Migration> allMigrations = [
  Migration_20250101000000_create_example_tables(),
];


