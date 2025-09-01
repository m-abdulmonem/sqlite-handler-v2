# SQLite Handler v2.0.0

A modern, lightweight and feature-rich SQLite database handler for Flutter with support for migrations, encryption, and advanced query building.

## Features

- 🚀 **Modern Flutter Support**: Compatible with Flutter 3.10+ and Dart 3.0+
- 🗄️ **Advanced Query Building**: Fluent API for complex SQL queries
- 🔐 **Built-in Encryption**: Secure data storage with encryption utilities
- 📊 **Rich Data Types**: Support for all SQLite data types including JSON, UUID, and geometric types
- 🔄 **Laravel-like Migrations**: Easy database schema management with rollback support
- 🏗️ **Schema Builder**: Fluent interface for table creation
- 🔗 **Relationships**: Support for hasOne, hasMany, belongsTo, and many-to-many relationships
- ⚡ **Performance**: Optimized for high-performance database operations
- 🛡️ **Error Handling**: Comprehensive error handling with custom exceptions
- 📱 **Cross-Platform**: Works on Android, iOS, Windows, macOS, Linux, and Web
- 🛠️ **Migration Generator**: CLI tools for creating and managing migrations

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  sqlite_handler: ^2.0.0
```

### Basic Usage

```dart
import 'package:sqlite_handler/sqlite_handler.dart';

// Define your model
class User extends Model {
  String? name;
  String? email;
  DateTime? createdAt;
  
  User() : super('users');
  
  @override
  Map<String, Object?> toMap() {
    return {
      'name': name,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
    };
  }
  
  @override
  User fromMap(Map<dynamic, dynamic> map) {
    return User()
      ..name = map['name'] as String?
      ..email = map['email'] as String?
      ..createdAt = map['created_at'] != null 
          ? DateTime.parse(map['created_at'] as String)
          : null;
  }
}

// Use the model
void main() async {
  final user = User()
    ..name = 'John Doe'
    ..email = 'john@example.com'
    ..createdAt = DateTime.now();
  
  // Insert user
  final savedUser = await user.insert();
  
  // Find user by ID
  final foundUser = await User().find(savedUser.id!);
  
  // Query users
  final users = await User()
    .where('email', value: 'john@example.com')
    .orderBy(column: 'created_at', order: DatabaseOrder.descending)
    .all();
}
```

## Migrations

The package includes a powerful Laravel-like migration system that makes database schema management easy and reliable.

### Creating Migrations

#### Using the CLI

```bash
# Create a new migration
dart run bin/migrate.dart make:migration create_users_table

# Create a table migration
dart run bin/migrate.dart make:table users

# Create a migration for adding columns
dart run bin/migrate.dart make:add_columns users name:text:not_null email:text:not_null:unique age:integer:not_null:18
```

#### Manual Creation

```dart
import 'package:sqlite_handler/sqlite_handler.dart';

class CreateUsersTable extends Migration {
  @override
  String get tableName => 'users';
  
  @override
  String get description => 'Create users table with basic authentication fields';
  
  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        email_verified_at DATETIME,
        remember_token TEXT,
        is_active INTEGER DEFAULT 1,
        created_at DATETIME,
        updated_at DATETIME
      )
    ''');
    
    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_users_email ON users(email)');
    await db.execute('CREATE INDEX idx_users_active ON users(is_active)');
  }
  
  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE users');
  }
}
```

### Running Migrations

#### Using the CLI

```bash
# Run all pending migrations
dart run bin/migrate.dart migrate

# Show migration status
dart run bin/migrate.dart status

# Rollback the last batch
dart run bin/migrate.dart rollback

# Rollback to a specific migration
dart run bin/migrate.dart rollback:to 20240101120000_create_users_table

# Reset all migrations
dart run bin/migrate.dart reset

# Refresh (reset and re-run all migrations)
dart run bin/migrate.dart refresh
```

#### Programmatically

```dart
import 'package:sqlite_handler/sqlite_handler.dart';

void main() async {
  final runner = MigrationRunner();
  
  // Add your migrations
  runner.addMigration(CreateUsersTable());
  runner.addMigration(CreatePostsTable());
  
  // Run migrations
  final executed = await runner.migrate();
  print('Executed ${executed.length} migrations');
  
  // Show status
  final statuses = await runner.status();
  for (final status in statuses) {
    print('${status['migration']}: ${status['hasRun'] ? '✓' : '○'}');
  }
  
  // Rollback if needed
  final rolledBack = await runner.rollback();
  print('Rolled back ${rolledBack.length} migrations');
  
  await runner.close();
}
```

### Migration Dependencies

Migrations can depend on other migrations to ensure proper execution order:

```dart
class CreatePostsTable extends Migration {
  @override
  String get tableName => 'posts';
  
  @override
  List<String> get dependencies => ['20240101120000_CreateUsersTable'];
  
  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        content TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }
  
  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE posts');
  }
}
```

### Advanced Migration Features

#### Schema Builder Integration

```dart
import 'package:sqlite_handler/sqlite_handler.dart';

class CreateProductsTable extends Migration {
  @override
  String get tableName => 'products';
  
  @override
  Future<void> up(Database db) async {
    final schema = Schema()
      ..id()
      ..text('name').notNull()
      ..text('description')
      ..decimal('price', precision: 10, scale: 2).notNull()
      ..integer('stock').defaultValue(0)
      ..boolean('is_active').defaultValue(true)
      ..datetime('created_at')
      ..datetime('updated_at')
      ..timestamps();
    
    final createTableQuery = schema.createTable('products');
    await db.execute(createTableQuery);
  }
  
  @override
  Future<void> down(Database db) async {
    await db.execute('DROP TABLE products');
  }
}
```

#### Data Seeding

```dart
class SeedUsersTable extends Migration {
  @override
  String get tableName => 'users';
  
  @override
  Future<void> up(Database db) async {
    // Insert default users
    await db.insert('users', {
      'name': 'Admin User',
      'email': 'admin@example.com',
      'password_hash': 'hashed_password_here',
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
    
    await db.insert('users', {
      'name': 'Demo User',
      'email': 'demo@example.com',
      'password_hash': 'hashed_password_here',
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
  
  @override
  Future<void> down(Database db) async {
    await db.delete('users', where: 'email IN (?, ?)', whereArgs: ['admin@example.com', 'demo@example.com']);
  }
}
```

### Migration Generator

The package includes a powerful migration generator that can create various types of migrations:

```dart
import 'package:sqlite_handler/sqlite_handler.dart';

void main() async {
  final generator = MigrationGenerator();
  
  // Create a basic migration
  await generator.create('create_orders_table');
  
  // Create a table with columns
  await generator.createTable('products', columns: [
    {'name': 'name', 'type': 'TEXT', 'nullable': false},
    {'name': 'price', 'type': 'DECIMAL(10,2)', 'nullable': false},
    {'name': 'stock', 'type': 'INTEGER', 'default': 0},
  ]);
  
  // Add columns to existing table
  await generator.addColumns('users', [
    {'name': 'phone', 'type': 'TEXT'},
    {'name': 'address', 'type': 'TEXT'},
  ]);
  
  // Create indexes
  await generator.createIndex('users', ['email'], unique: true);
  await generator.createIndex('posts', ['user_id', 'status']);
  
  // Rename table
  await generator.renameTable('old_table_name', 'new_table_name');
}
```

## Advanced Features

### Schema Building

```dart
import 'package:sqlite_handler/sqlite_handler.dart';

class UserMigration extends Migrations {
  @override
  Future<List<String>> get getTables async {
    final schema = Schema()
      ..id()
      ..text('name').notNull()
      ..email('email').notNull().unique()
      ..datetime('created_at')
      ..datetime('updated_at')
      ..timestamps();
    
    return [schema.createTable('users')];
  }
}
```

### Complex Queries

```dart
// Advanced query building
final users = await User()
  .select(['id', 'name', 'email'])
  .where('age', value: 18, operator: '>=')
  .whereIn('status', ['active', 'pending'])
  .whereNotNull('email')
  .orderBy(column: 'created_at', order: DatabaseOrder.descending)
  .limit(10, 0)
  .all();

// Aggregations
final userCount = await User().count();
final maxAge = await User().max('age');
final avgAge = await User().avg('age');
final totalScore = await User().sum('score');
```

### Relationships

```dart
// One-to-Many relationship
class Post extends Model {
  Post() : super('posts');
  
  // Get posts with user information
  Future<List<Post>> withUser() async {
    return await belongsTo('users', 'user_id').all();
  }
}

// Many-to-Many relationship
class User extends Model {
  User() : super('users');
  
  // Get users with their roles
  Future<List<User>> withRoles() async {
    return await belongsToMany(
      'roles',
      'user_roles',
      tableId: 'user_id',
      relatedId: 'role_id',
    ).all();
  }
}
```

### Transactions

```dart
// Execute operations within a transaction
await User().transaction((txn) async {
  final user1 = User()..name = 'User 1';
  final user2 = User()..name = 'User 2';
  
  await user1.insert();
  await user2.insert();
  
  return 'Transaction completed';
});
```

### Encryption

```dart
import 'package:sqlite_handler/sqlite_handler.dart';

final encryption = Encryption();

// Hash passwords
final passwordData = encryption.hashPassword('myPassword123');
final isMatch = encryption.verifyPassword(
  'myPassword123',
  passwordData['hash']!,
  passwordData['salt']!,
  int.parse(passwordData['iterations']!),
  int.parse(passwordData['keyLength']!),
);

// Encrypt sensitive data
final encrypted = encryption.encrypt('sensitive data', 'secretKey');
final decrypted = encryption.decrypt(encrypted, 'secretKey');

// Generate secure tokens
final token = encryption.generateToken();
final uuid = encryption.generateUuid();
```

## Data Types

The package supports a wide range of SQLite data types:

### Basic Types
- `integer()` - Integer numbers
- `real()` - Floating point numbers
- `text()` - Text data
- `blob()` - Binary data
- `boolean()` - Boolean values (stored as integers)

### Specialized Types
- `email()` - Email addresses (VARCHAR(255))
- `url()` - URLs (VARCHAR(2048))
- `phone()` - Phone numbers (VARCHAR(20))
- `hash()` - Hash values (VARCHAR(64))
- `uuid()` - UUID strings
- `json()` - JSON data
- `currency()` - Currency amounts (DECIMAL(10,2))
- `percentage()` - Percentage values (DECIMAL(5,2))

### Geometric Types
- `coordinates()` - Geographic coordinates
- `point()` - Point data
- `line()` - Line data
- `polygon()` - Polygon data
- `circle()` - Circle data
- `rectangle()` - Rectangle data

## API Reference

### Model Methods

- `insert()` - Insert a new record
- `update(id)` - Update an existing record
- `delete(id)` - Delete a record by ID
- `find(id)` - Find a record by ID
- `all()` - Get all records
- `first()` - Get the first record
- `last()` - Get the last record
- `count()` - Count records
- `exists()` - Check if record exists
- `save()` - Insert or update based on ID
- `destroy()` - Delete the current record
- `refresh()` - Refresh from database
- `copy()` - Create a copy without ID

### Query Builder Methods

- `where(column, value, operator)` - Add WHERE condition
- `orWhere(column, value, operator)` - Add OR WHERE condition
- `whereIn(column, values)` - Add WHERE IN condition
- `whereNotIn(column, values)` - Add WHERE NOT IN condition
- `whereNull(column)` - Add WHERE NULL condition
- `whereNotNull(column)` - Add WHERE NOT NULL condition
- `whereLike(column, pattern)` - Add WHERE LIKE condition
- `whereBetween(column, start, end)` - Add WHERE BETWEEN condition
- `orderBy(column, order)` - Add ORDER BY clause
- `groupBy(column)` - Add GROUP BY clause
- `having(condition)` - Add HAVING clause
- `limit(count, offset)` - Add LIMIT and OFFSET
- `distinct()` - Add DISTINCT modifier
- `select(columns)` - Select specific columns

### Schema Builder Methods

- `id()` - Primary key column
- `integer(name)` - Integer column
- `real(name)` - Real column
- `text(name)` - Text column
- `blob(name)` - Blob column
- `boolean(name)` - Boolean column
- `datetime(name)` - Datetime column
- `decimal(name, precision, scale)` - Decimal column
- `varchar(name, length)` - Varchar column
- `timestamps()` - Add created_at and updated_at
- `softDeletes()` - Add deleted_at column
- `auditTrail()` - Add created_by and updated_by

### Constraint Methods

- `notNull()` - NOT NULL constraint
- `unique()` - UNIQUE constraint
- `primaryKey()` - PRIMARY KEY constraint
- `autoIncrement()` - AUTOINCREMENT modifier
- `defaultValue(value)` - DEFAULT value
- `check(condition)` - CHECK constraint
- `foreignKey(table, column)` - FOREIGN KEY constraint
- `indexed()` - INDEX hint

### Migration Methods

- `up(Database db)` - Execute the migration
- `down(Database db)` - Rollback the migration
- `hasRun(Database db)` - Check if migration has been run
- `markAsRun(Database db)` - Mark migration as executed
- `markAsRolledBack(Database db)` - Mark migration as rolled back
- `canRun(Database db)` - Check if migration can run
- `getStatus(Database db)` - Get migration status

### Migration Runner Methods

- `addMigration(Migration)` - Add a migration to the runner
- `addMigrations(List<Migration>)` - Add multiple migrations
- `migrate()` - Run all pending migrations
- `rollback()` - Rollback the last batch
- `rollbackTo(String)` - Rollback to a specific migration
- `reset()` - Rollback all migrations
- `refresh()` - Reset and re-run all migrations
- `status()` - Get migration status
- `getPendingMigrations()` - Get pending migrations
- `getRanMigrations()` - Get executed migrations

### Migration Generator Methods

- `create(String name)` - Create a new migration
- `createTable(String tableName)` - Create a table migration
- `addColumns(String tableName, List columns)` - Create add columns migration
- `dropColumns(String tableName, List columns)` - Create drop columns migration
- `renameTable(String oldName, String newName)` - Create rename table migration
- `createIndex(String tableName, List columns, bool unique)` - Create index migration

## Error Handling

The package provides comprehensive error handling:

```dart
try {
  final user = await User().find(999);
  if (user == null) {
    print('User not found');
  }
} on DatabaseException catch (e) {
  print('Database error: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

## Performance Tips

1. **Use Indexes**: Add indexes on frequently queried columns
2. **Limit Results**: Use `limit()` to avoid loading large datasets
3. **Select Specific Columns**: Use `select()` instead of `SELECT *`
4. **Batch Operations**: Use transactions for multiple operations
5. **Avoid N+1 Queries**: Use relationships efficiently
6. **Migration Batching**: Group related migrations together

## Migration Guide from v0.0.4

### Breaking Changes

1. **Enum Names**: `SqlTypes` → `SqliteDataType`, `DatabaseOredrs` → `DatabaseOrder`
2. **Method Names**: `order()` → `orderBy()`
3. **SDK Requirements**: Flutter 3.10+ and Dart 3.0+

### Update Steps

1. Update your `pubspec.yaml`:
   ```yaml
   dependencies:
     sqlite_handler: ^2.0.0
   ```

2. Update enum imports:
   ```dart
   // Old
   import 'package:sqlite_handler/core/enums/sqlite_data_type.dart';
   
   // New
   import 'package:sqlite_handler/sqlite_handler.dart';
   ```

3. Update enum usage:
   ```dart
   // Old
   DatabaseOredrs.asc
   
   // New
   DatabaseOrder.ascending
   ```

4. Update method calls:
   ```dart
   // Old
   .order(column: 'name', order: DatabaseOredrs.asc)
   
   // New
   .orderBy(column: 'name', order: DatabaseOrder.ascending)
   ```

5. Review error handling:
   ```dart
   // Old
   try {
     // operations
   } catch (e) {
     // generic error handling
   }
   
   // New
   try {
     // operations
   } on DatabaseException catch (e) {
     // specific database error handling
   }
   ```

### Benefits of Upgrading

- **Better Performance**: Improved query execution and memory management
- **Enhanced Security**: Built-in encryption and better security features
- **Modern API**: Fluent API design with better developer experience
- **Type Safety**: Enhanced type safety throughout the codebase
- **Future Proof**: Support for latest Flutter and Dart versions
- **Rich Features**: Advanced query building, relationships, and schema management
- **Migration System**: Laravel-like migration system with rollback support

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 [Documentation](https://github.com/m-abdulmonem/sqlite-handler-v2)
- 🐛 [Issue Tracker](https://github.com/m-abdulmonem/sqlite-handler-v2/issues)
- 💬 [Discussions](https://github.com/m-abdulmonem/sqlite-handler-v2/discussions)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes.


