import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../core/enums/orders.dart';
import '../model.dart';
import '../core/extensions/enumations.dart';

/// Enhanced database helper with better error handling and modern features
abstract class DBHelper {
  final String table;
  String _query = "";
  List<Map<dynamic, dynamic>> _result = [];
  final List<dynamic> _bindings = [];
  final List<String> _whereConditions = [];
  final List<String> _orderByConditions = [];
  final List<String> _groupByConditions = [];
  final List<String> _havingConditions = [];
  int? _limit;
  int? _offset;
  bool _distinct = false;
  final List<String> _selectColumns = [];

  DBHelper(this.table);

  /// Get the database instance
  Future<Database> get database async {
    final path = join(await getDatabasesPath(), 'sqlite_handler_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        // Create tables based on the model's tableName
        // This will be handled by individual model classes
      },
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      version: 1,
    );
  }

  /// Execute a raw SQL query
  Future<DBHelper> rawQuery(String query, [List<dynamic>? arguments]) async {
    try {
      Database db = await database;
      _result = await db.rawQuery(query, arguments);
      return this;
    } catch (e) {
      throw DatabaseException('Failed to execute raw query: $e');
    }
  }

  /// Find a record by ID
  Future<Model?> find(int id) async {
    try {
      Database db = await database;
      final result = await db.rawQuery(
        "SELECT * FROM $table WHERE id = ?",
        [id],
      );

      if (result.isEmpty) return null;
      return fromMap(result.first);
    } catch (e) {
      throw DatabaseException('Failed to find record with ID $id: $e');
    }
  }

  /// Add a WHERE condition
  DBHelper where(String column, {dynamic value, String operator = "="}) {
    _addWhereCondition(column, value, operator, "AND");
    return this;
  }

  /// Add an OR WHERE condition
  DBHelper orWhere(String column, {dynamic value, String operator = "="}) {
    _addWhereCondition(column, value, operator, "OR");
    return this;
  }

  /// Add a WHERE IN condition
  DBHelper whereIn(String column, List<dynamic> values) {
    if (values.isNotEmpty) {
      final placeholders = List.filled(values.length, '?').join(',');
      _whereConditions.add("$column IN ($placeholders)");
      _bindings.addAll(values);
    }
    return this;
  }

  /// Add a WHERE NOT IN condition
  DBHelper whereNotIn(String column, List<dynamic> values) {
    if (values.isNotEmpty) {
      final placeholders = List.filled(values.length, '?').join(',');
      _whereConditions.add("$column NOT IN ($placeholders)");
      _bindings.addAll(values);
    }
    return this;
  }

  /// Add a WHERE NULL condition
  DBHelper whereNull(String column) {
    _whereConditions.add("$column IS NULL");
    return this;
  }

  /// Add a WHERE NOT NULL condition
  DBHelper whereNotNull(String column) {
    _whereConditions.add("$column IS NOT NULL");
    return this;
  }

  /// Add a WHERE LIKE condition
  DBHelper whereLike(String column, String pattern) {
    _whereConditions.add("$column LIKE ?");
    _bindings.add(pattern);
    return this;
  }

  /// Add a WHERE BETWEEN condition
  DBHelper whereBetween(String column, dynamic start, dynamic end) {
    _whereConditions.add("$column BETWEEN ? AND ?");
    _bindings.addAll([start, end]);
    return this;
  }

  void _addWhereCondition(String column, dynamic value, String operator, String logicalOperator) {
    if (_whereConditions.isNotEmpty) {
      _whereConditions.add(logicalOperator);
    }
    _whereConditions.add("$column $operator ?");
    _bindings.add(value);
  }

  /// Add a hasOne relationship
  DBHelper hasOne() {
    return this;
  }

  /// Add a hasMany relationship
  DBHelper hasMany(String relatedTable, String relatedColumn) {
    _query = "SELECT * FROM $table INNER JOIN $relatedTable ON $relatedTable.id = $table.$relatedColumn";
    return this;
  }

  /// Add a belongsTo relationship
  DBHelper belongsTo(String relatedTable, String relatedColumn) {
    _query = "SELECT * FROM $table INNER JOIN $relatedTable ON $relatedTable.id = $table.$relatedColumn";
    return this;
  }

  /// Add a belongsToMany relationship
  DBHelper belongsToMany(String relatedTable, String pivotTable,
      {required String tableId, required String relatedId}) {
    _query = "SELECT $table.*,$relatedTable.* FROM $table "
        "INNER JOIN $pivotTable ON $pivotTable.$tableId=$table.id "
        "INNER JOIN $relatedTable ON $relatedTable.id =$pivotTable.$relatedId";
    return this;
  }

  /// Add ORDER BY clause
  DBHelper orderBy({String? column = "created_at", DatabaseOrder? order = DatabaseOrder.ascending}) {
    if (column != null && order != null) {
      _orderByConditions.add("$column ${order.sqlString}");
    }
    return this;
  }

  /// Add GROUP BY clause
  DBHelper groupBy(String column) {
    _groupByConditions.add(column);
    return this;
  }

  /// Add HAVING clause
  DBHelper having(String condition, [List<dynamic>? arguments]) {
    _havingConditions.add(condition);
    if (arguments != null) {
      _bindings.addAll(arguments);
    }
    return this;
  }

  /// Set LIMIT and OFFSET
  DBHelper limit(int count, [int offset = 0]) {
    _limit = count;
    _offset = offset;
    return this;
  }

  /// Set DISTINCT
  DBHelper distinct() {
    _distinct = true;
    return this;
  }

  /// Select specific columns
  DBHelper select(dynamic columns) {
    if (columns is String) {
      _selectColumns.add(columns);
    } else if (columns is List<String>) {
      _selectColumns.addAll(columns);
    }
    return this;
  }

  /// Build the final SQL query
  String _buildQuery() {
    final buffer = StringBuffer();
    
    // SELECT clause
    buffer.write("SELECT ");
    if (_distinct) buffer.write("DISTINCT ");
    
    if (_selectColumns.isNotEmpty) {
      buffer.write(_selectColumns.join(", "));
    } else {
      buffer.write("*");
    }
    
    buffer.write(" FROM $table");
    
    // WHERE clause
    if (_whereConditions.isNotEmpty) {
      buffer.write(" WHERE ");
      buffer.write(_whereConditions.join(" "));
    }
    
    // GROUP BY clause
    if (_groupByConditions.isNotEmpty) {
      buffer.write(" GROUP BY ");
      buffer.write(_groupByConditions.join(", "));
    }
    
    // HAVING clause
    if (_havingConditions.isNotEmpty) {
      buffer.write(" HAVING ");
      buffer.write(_havingConditions.join(" AND "));
    }
    
    // ORDER BY clause
    if (_orderByConditions.isNotEmpty) {
      buffer.write(" ORDER BY ");
      buffer.write(_orderByConditions.join(", "));
    }
    
    // LIMIT and OFFSET
    if (_limit != null) {
      buffer.write(" LIMIT $_limit");
      if (_offset != null && _offset! > 0) {
        buffer.write(" OFFSET $_offset");
      }
    }
    
    return buffer.toString();
  }

  /// Get all records with optional pagination
  Future<List<Model>?> all({int? paginate}) async {
    try {
      if (paginate != null) {
        limit(paginate);
      }
      
      final query = _buildQuery();
      Database db = await database;
      
      final result = await db.rawQuery(query, _bindings);
      if (result.isEmpty) return null;

      return result.map((data) {
        final newMap = _convertDataTypes(data);
        return fromMap(newMap);
      }).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch all records: $e');
    }
  }

  /// Get the first record
  Future<Model?> first({int? paginate}) async {
    try {
      if (paginate != null) {
        limit(paginate);
      }
      
      final query = _buildQuery();
      Database db = await database;
      
      final result = await db.rawQuery(query, _bindings);
      if (result.isEmpty) return null;

      final newMap = _convertDataTypes(result.first);
      return fromMap(newMap);
    } catch (e) {
      throw DatabaseException('Failed to fetch first record: $e');
    }
  }

  /// Get the last record
  Future<Model?> last({int? paginate}) async {
    try {
      if (paginate != null) {
        limit(paginate);
      }
      
      final query = _buildQuery();
      Database db = await database;
      
      final result = await db.rawQuery(query, _bindings);
      if (result.isEmpty) return null;

      final newMap = _convertDataTypes(result.last);
      return fromMap(newMap);
    } catch (e) {
      throw DatabaseException('Failed to fetch last record: $e');
    }
  }

  /// Extract specific column values
  Future<dynamic> pluck(dynamic column) async {
    try {
      final result = await all();
      if (result == null) return null;

      if (column is String) {
        return result.map((model) => model.toMap()[column]).toList();
      } else if (column is List<String>) {
        final map = <String, List<dynamic>>{};
        for (final model in result) {
          final modelMap = model.toMap();
          for (final col in column) {
            map.putIfAbsent(col, () => []).add(modelMap[col]);
          }
        }
        return map;
      }
      return null;
    } catch (e) {
      throw DatabaseException('Failed to pluck column: $e');
    }
  }

  /// Insert a new record
  Future<Model?> insert() async {
    try {
      Database db = await database;
      final data = toMap();
      data.putIfAbsent("created_at", () => DateTime.now());

      final id = await db.insert(
        table,
        _handleDataType(data),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return find(id);
    } catch (e) {
      throw DatabaseException('Failed to insert record: $e');
    }
  }

  /// Update an existing record
  Future<int> update(int id) async {
    try {
      final db = await database;
      final data = toMap();
      data.putIfAbsent("updated_at", () => DateTime.now());

      return await db.update(
        table,
        _handleDataType(data),
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException('Failed to update record with ID $id: $e');
    }
  }

  /// Delete a record by ID
  Future<int> delete(int id) async {
    try {
      final db = await database;
      return await db.delete(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete record with ID $id: $e');
    }
  }

  /// Delete all records from the table
  Future<void> erase() async {
    try {
      final db = await database;
      final data = await all();
      if (data != null) {
        for (final model in data) {
          await db.delete(
            table,
            where: 'id = ?',
            whereArgs: [model.toMap()['id']],
          );
        }
      }
    } catch (e) {
      throw DatabaseException('Failed to erase table: $e');
    }
  }

  /// Execute a transaction
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    try {
      final db = await database;
      return await db.transaction(action);
    } catch (e) {
      throw DatabaseException('Transaction failed: $e');
    }
  }

  /// Count records
  Future<int> count() async {
    try {
      final db = await database;
      final query = "SELECT COUNT(*) as count FROM $table";
      
      if (_whereConditions.isNotEmpty) {
        final whereClause = _whereConditions.join(" ");
        final fullQuery = "$query WHERE $whereClause";
        final result = await db.rawQuery(fullQuery, _bindings);
        return result.first['count'] as int;
      }
      
      final result = await db.rawQuery(query);
      return result.first['count'] as int;
    } catch (e) {
      throw DatabaseException('Failed to count records: $e');
    }
  }

  /// Get maximum value of a column
  Future<dynamic> max(String columnName) async {
    try {
      final db = await database;
      final query = "SELECT MAX($columnName) as max_value FROM $table";
      
      if (_whereConditions.isNotEmpty) {
        final whereClause = _whereConditions.join(" ");
        final fullQuery = "$query WHERE $whereClause";
        final result = await db.rawQuery(fullQuery, _bindings);
        return result.first['max_value'];
      }
      
      final result = await db.rawQuery(query);
      return result.first['max_value'];
    } catch (e) {
      throw DatabaseException('Failed to get max value for column $columnName: $e');
    }
  }

  /// Get minimum value of a column
  Future<dynamic> min(String columnName) async {
    try {
      final db = await database;
      final query = "SELECT MIN($columnName) as min_value FROM $table";
      
      if (_whereConditions.isNotEmpty) {
        final whereClause = _whereConditions.join(" ");
        final fullQuery = "$query WHERE $whereClause";
        final result = await db.rawQuery(fullQuery, _bindings);
        return result.first['min_value'];
      }
      
      final result = await db.rawQuery(query);
      return result.first['min_value'];
    } catch (e) {
      throw DatabaseException('Failed to get min value for column $columnName: $e');
    }
  }

  /// Get average value of a column
  Future<double?> avg(String columnName) async {
    try {
      final db = await database;
      final query = "SELECT AVG($columnName) as avg_value FROM $table";
      
      if (_whereConditions.isNotEmpty) {
        final whereClause = _whereConditions.join(" ");
        final fullQuery = "$query WHERE $whereClause";
        final result = await db.rawQuery(fullQuery, _bindings);
        return result.first['avg_value'] as double?;
      }
      
      final result = await db.rawQuery(query);
      return result.first['avg_value'] as double?;
    } catch (e) {
      throw DatabaseException('Failed to get average value for column $columnName: $e');
    }
  }

  /// Get sum of a column
  Future<num?> sum(String columnName) async {
    try {
      final db = await database;
      final query = "SELECT SUM($columnName) as sum_value FROM $table";
      
      if (_whereConditions.isNotEmpty) {
        final whereClause = _whereConditions.join(" ");
        final fullQuery = "$query WHERE $whereClause";
        final result = await db.rawQuery(fullQuery, _bindings);
        return result.first['sum_value'] as num?;
      }
      
      final result = await db.rawQuery(query);
      return result.first['sum_value'] as num?;
    } catch (e) {
      throw DatabaseException('Failed to get sum for column $columnName: $e');
    }
  }

  /// Reset the query builder state
  void reset() {
    _query = "";
    _result.clear();
    _bindings.clear();
    _whereConditions.clear();
    _orderByConditions.clear();
    _groupByConditions.clear();
    _havingConditions.clear();
    _limit = null;
    _offset = null;
    _distinct = false;
    _selectColumns.clear();
  }

  /// Convert data types for storage
  Map<String, dynamic> _handleDataType(Map<String, dynamic> data) {
    final newMap = <String, dynamic>{};
    data.forEach((k, v) {
      if (v is DateTime) {
        newMap[k] = v.toIso8601String();
      } else if (v is bool) {
        newMap[k] = v ? 1 : 0;
      } else {
        newMap[k] = v;
      }
    });
    return newMap;
  }

  /// Convert data types from storage
  Map<String, dynamic> _convertDataTypes(Map<String, dynamic> data) {
    final newMap = <String, dynamic>{};
    data.forEach((k, v) {
      if (v is String && _isDateTimeString(v)) {
        newMap[k] = DateTime.parse(v);
      } else if (v is int && k == 'is_active' || k.endsWith('_enabled') || k.endsWith('_active')) {
        newMap[k] = v == 1;
      } else {
        newMap[k] = v;
      }
    });
    return newMap;
  }

  /// Check if a string represents a datetime
  bool _isDateTimeString(String value) {
    try {
      DateTime.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get DateTime from string
  DateTime getDateTime(String dateTime) {
    return DateTime.parse(dateTime);
  }

  /// Get boolean from integer
  bool getBool(int value) {
    return value == 1;
  }

  /// Abstract methods that must be implemented
  Map<String, Object?> toMap();
  Model fromMap(Map<dynamic, dynamic> map);
}

/// Custom exception for database operations
class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}
