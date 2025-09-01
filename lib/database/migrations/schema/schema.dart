import '/core/extensions/string.dart';
import '/core/enums/sqlite_data_type.dart';
import 'schema_utils.dart';

/// Schema builder for creating database tables
/// 
/// This class provides a fluent interface for defining table schemas
/// with proper column types, constraints, and relationships.
/// 
/// Example usage:
/// ```dart
/// final schema = Schema()
///   ..id()
///   ..text('name').notNull()
///   ..integer('age').defaultValue(18)
///   ..timestamps();
/// 
/// final createTableQuery = schema.createTable('users');
/// ```
class Schema {
  final Map<String, dynamic> _columns = {};

  /// Add a primary key column
  /// 
  /// Creates an auto-incrementing integer primary key column.
  /// By default, the column name is 'id'.
  void id([String name = "id"]) {
    _columns['id'] = " $name INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,";
  }

  /// Add an integer column
  /// 
  /// Creates an integer column with optional constraints.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils integer(String name) {
    final column = SchemaUtils(" $name INTEGER ");
    _columns[name] = column;
    return column;
  }

  /// Add a real (floating point) column
  /// 
  /// Creates a real column for decimal numbers.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils real(String name) {
    final column = SchemaUtils(" $name REAL ");
    _columns[name] = column;
    return column;
  }

  /// Add a foreign key column
  /// 
  /// Creates an integer column that references another table's primary key.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils foreignId(String name) {
    final column = integer(name);
    _columns[name] = column;
    return column;
  }

  /// Add a text column
  /// 
  /// Creates a text column for string data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils text(String name) {
    final column = SchemaUtils(" $name TEXT ");
    _columns[name] = column;
    return column;
  }

  /// Add a blob column
  /// 
  /// Creates a blob column for binary data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils blob(String name) {
    final column = SchemaUtils(" $name BLOB ");
    _columns[name] = column;
    return column;
  }

  /// Add a boolean column
  /// 
  /// Creates an integer column that stores boolean values (0 or 1).
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils boolean(String name) {
    final column = integer(name);
    _columns[name] = column;
    return column;
  }

  /// Add a datetime column
  /// 
  /// Creates a text column for storing ISO 8601 datetime strings.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils datetime(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a decimal column
  /// 
  /// Creates a real column for precise decimal numbers.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils decimal(String name, {int precision = 10, int scale = 2}) {
    final column = SchemaUtils(" $name DECIMAL($precision,$scale) ");
    _columns[name] = column;
    return column;
  }

  /// Add a varchar column
  /// 
  /// Creates a text column with a specified maximum length.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils varchar(String name, int length) {
    final column = SchemaUtils(" $name VARCHAR($length) ");
    _columns[name] = column;
    return column;
  }

  /// Add a JSON column
  /// 
  /// Creates a text column for storing JSON data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils json(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a UUID column
  /// 
  /// Creates a text column for storing UUID strings.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils uuid(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a hash column
  /// 
  /// Creates a text column for storing hash values (e.g., SHA-256).
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils hash(String name, {int length = 64}) {
    final column = varchar(name, length);
    _columns[name] = column;
    return column;
  }

  /// Add an email column
  /// 
  /// Creates a varchar column for storing email addresses.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils email(String name) {
    final column = varchar(name, 255);
    _columns[name] = column;
    return column;
  }

  /// Add a URL column
  /// 
  /// Creates a varchar column for storing URLs.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils url(String name) {
    final column = varchar(name, 2048);
    _columns[name] = column;
    return column;
  }

  /// Add a phone column
  /// 
  /// Creates a varchar column for storing phone numbers.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils phone(String name) {
    final column = varchar(name, 20);
    _columns[name] = column;
    return column;
  }

  /// Add a color column
  /// 
  /// Creates a varchar column for storing hex color codes.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils color(String name) {
    final column = varchar(name, 7);
    _columns[name] = column;
    return column;
  }

  /// Add a currency column
  /// 
  /// Creates a decimal column for storing currency amounts.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils currency(String name) {
    final column = decimal(name, precision: 10, scale: 2);
    _columns[name] = column;
    return column;
  }

  /// Add a percentage column
  /// 
  /// Creates a decimal column for storing percentage values.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils percentage(String name) {
    final column = decimal(name, precision: 5, scale: 2);
    _columns[name] = column;
    return column;
  }

  /// Add a duration column
  /// 
  /// Creates an integer column for storing duration in seconds.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils duration(String name) {
    final column = integer(name);
    _columns[name] = column;
    return column;
  }

  /// Add a file path column
  /// 
  /// Creates a varchar column for storing file paths.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils filePath(String name) {
    final column = varchar(name, 4096);
    _columns[name] = column;
    return column;
  }

  /// Add an IP address column
  /// 
  /// Creates a varchar column for storing IP addresses.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils ipAddress(String name) {
    final column = varchar(name, 45);
    _columns[name] = column;
    return column;
  }

  /// Add a MAC address column
  /// 
  /// Creates a varchar column for storing MAC addresses.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils macAddress(String name) {
    final column = varchar(name, 17);
    _columns[name] = column;
    return column;
  }

  /// Add a token column
  /// 
  /// Creates a varchar column for storing authentication tokens.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils token(String name) {
    final column = varchar(name, 255);
    _columns[name] = column;
    return column;
  }

  /// Add a coordinates column
  /// 
  /// Creates a text column for storing geographic coordinates.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils coordinates(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a polygon column
  /// 
  /// Creates a text column for storing polygon data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils polygon(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a point column
  /// 
  /// Creates a text column for storing point data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils point(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a line column
  /// 
  /// Creates a text column for storing line data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils line(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a circle column
  /// 
  /// Creates a text column for storing circle data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils circle(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a rectangle column
  /// 
  /// Creates a text column for storing rectangle data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils rectangle(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a triangle column
  /// 
  /// Creates a text column for storing triangle data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils triangle(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add an ellipse column
  /// 
  /// Creates a text column for storing ellipse data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils ellipse(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add an arc column
  /// 
  /// Creates a text column for storing arc data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils arc(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a curve column
  /// 
  /// Creates a text column for storing curve data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils curve(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a surface column
  /// 
  /// Creates a text column for storing surface data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils surface(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a volume column
  /// 
  /// Creates a text column for storing volume data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils volume(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a matrix column
  /// 
  /// Creates a text column for storing matrix data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils matrix(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a vector column
  /// 
  /// Creates a text column for storing vector data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils vector(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a quaternion column
  /// 
  /// Creates a text column for storing quaternion data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils quaternion(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a complex column
  /// 
  /// Creates a text column for storing complex number data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils complex(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a rational column
  /// 
  /// Creates a text column for storing rational number data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils rational(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a fraction column
  /// 
  /// Creates a text column for storing fraction data.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils fraction(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a mixed column
  /// 
  /// Creates a text column for storing mixed data types.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils mixed(String name) {
    final column = text(name);
    _columns[name] = column;
    return column;
  }

  /// Add a custom column
  /// 
  /// Creates a column with a custom SQL type definition.
  /// Returns a SchemaUtils instance for adding constraints.
  SchemaUtils custom(String name, String sqlType) {
    final column = SchemaUtils(" $name $sqlType ");
    _columns[name] = column;
    return column;
  }

  /// Add timestamp columns
  /// 
  /// Adds created_at and updated_at columns for tracking record creation
  /// and modification times.
  void timestamps() {
    _columns['created_at'] = " created_at DATETIME NULL,";
    _columns['updated_at'] = " updated_at DATETIME NULL,";
  }

  /// Add soft delete columns
  /// 
  /// Adds deleted_at column for soft delete functionality.
  void softDeletes() {
    _columns['deleted_at'] = " deleted_at DATETIME NULL,";
  }

  /// Add audit columns
  /// 
  /// Adds created_by and updated_by columns for tracking who created
  /// and modified records.
  void auditTrail() {
    _columns['created_by'] = " created_by INTEGER NULL,";
    _columns['updated_by'] = " updated_by INTEGER NULL,";
  }

  /// Create the table creation SQL
  /// 
  /// Builds the complete CREATE TABLE SQL statement based on the
  /// defined columns and their constraints.
  String createTable(String tableName) {
    final buffer = StringBuffer();
    final foreignKeys = <String>[];

    buffer.write("CREATE TABLE IF NOT EXISTS $tableName (");
    
    _columns.forEach((key, value) {
      if (value is SchemaUtils) {
        final columnDef = value.get();
        if (columnDef.contains("FOREIGN KEY")) {
          foreignKeys.add(columnDef);
        } else {
          buffer.write(columnDef);
        }
      } else {
        buffer.write(value);
      }
    });

    // Remove trailing comma from last column
    final sql = buffer.toString().replaceAll(RegExp(r',$'), '');
    
    // Add foreign key constraints
    if (foreignKeys.isNotEmpty) {
      buffer.write(", ${foreignKeys.join(", ")}");
    }

    buffer.write(")");
    
    return buffer.toString();
  }

  /// Get the list of column names
  /// 
  /// Returns a list of all column names defined in this schema.
  List<String> get columnNames => _columns.keys.toList();

  /// Check if the schema has any columns
  /// 
  /// Returns true if columns are defined, false otherwise.
  bool get hasColumns => _columns.isNotEmpty;

  /// Get the number of columns
  /// 
  /// Returns the total number of columns defined in this schema.
  int get columnCount => _columns.length;
}
