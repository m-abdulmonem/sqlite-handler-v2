import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../core/enums/orders.dart';
import '../model.dart';
import '/core/extensions/enumations.dart';

abstract class DBHelper extends Migrations {
  String table;
  String _query = "";
  List<Map<dynamic, dynamic>> _result = [];
  final List _bindings = [];

  DBHelper(this.table);

  Future<Database> get database async {
    final path = join(await getDatabasesPath(), 'sqlite_handler_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        final queries = await getTables;
        for (String query in queries) {
          db.execute(query);
        }
      },
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      version: 1,
    );
  }

  Future? rawQuery(String query) async {
    Database db = await database;

    _result = await db.rawQuery(query);

    return this;
  }

  Future find(int id) async {
    Database db = await database;

    _result = await db.rawQuery("SELECT * FROM $table WHERE id = $id");

    if (_result.isEmpty) return null;

    return fromMap(_result.first);
  }

  DBHelper where(String column, {dynamic value, String boolean = "="}) {
    _where(column: column, value: value, operator: "AND", boolean: boolean);

    return this;
  }

  DBHelper orWhere(String column, {dynamic value, String boolean = "="}) {
    _where(column: column, value: value, operator: "OR", boolean: boolean);
    return this;
  }

  void _where(
      {required String column,
      dynamic value,
      required String operator,
      String boolean = "="}) {
    if (!_query.contains("SELECT")) {
      _query += "SELECT * FROM $table ";
    }
    if (_query.contains("ORDER")) {
      List splitedQuery = _query.split("ORDER");

      if (!_query.contains("WHERE")) {
        splitedQuery[0] += ' WHERE ';
      } else {
        splitedQuery[0] += " $operator ";
      }

      splitedQuery[0] += " $column $boolean ? ";

      splitedQuery[0] += " ORDER ";

      _query = splitedQuery.join();
    } else if (_query.contains("LIMIT")) {
      List splitedQuery = _query.split("LIMIT");

      if (!_query.contains("WHERE")) {
        splitedQuery[0] += ' WHERE ';
      } else {
        splitedQuery[0] += " $operator ";
      }

      splitedQuery[0] += " $column $boolean ? ";

      splitedQuery[0] += " LIMIT ";

      _query = splitedQuery.join();
    } else {
      if (!_query.contains("WHERE")) {
        _query += " WHERE ";
      } else {
        _query += " $operator ";
      }

      _query += " $column $boolean ? ";
    }

    _bindings.add(value);
  }

  DBHelper hasOne() {
    return this;
  }

  DBHelper hasMany(String relatedTable, String relatedColumn) {
    _query =
        "SELECT * FROM $table INNER JOIN  $relatedTable ON $relatedTable.id = $table.$relatedColumn ";
    return this;
  }

  DBHelper belongsTo(String relatedTable, String relatedColumn) {
// -- SELECT  *
// -- FROM
// --     suppliers
// -- INNER JOIN supplier_groups
// --     ON supplier_groups.id = suppliers.group_id;
// --

    // select * from suppliers  INNER JOIN supplier_groups   ON supplier_groups.id = suppliers.group_id  WHERE suppliers.id= 1;
    _query =
        "SELECT * FROM $table INNER JOIN  $relatedTable ON $relatedTable.id = $table.$relatedColumn ";

    return this;
  }

  DBHelper belongsToMany(String relatedTable, String pivotTable,
      {required String tabelId, required String relatedId}) {
//     -- select supplier_groups from suppliers
// SELECT  department.*,employee.*
// FROM
//     department
// INNER JOIN link ON link.department_id=department.id
//JOIN employee ON  employee.id = link.employee_id;

    _query = "SELECT $table.*,$relatedTable.* FROM $table ";

    _query += " INNER JOIN $pivotTable ON $pivotTable.$tabelId=$table.id ";
    _query +=
        " INNER JOIN $relatedTable ON $relatedTable.id =$pivotTable.$relatedId ";

    return this;
  }

  DBHelper order(
      {String? column = "created_at",
      DatabaseOredrs? order = DatabaseOredrs.asc}) {
    String q = "  ORDER BY  $column  ${order?.getUpperString} ";
    if (_query.contains("SELECT")) {
      if (!_query.contains("LIMIT")) {
        if (!_query.contains("ORDER")) {
          _query += q;
        }
      } else {
        List splitedQuery = _query.split("LIMIT");
        splitedQuery[0] += "$q LIMIT ";

        _query = splitedQuery.join();
      }
    } else {
      _query += "SELECT * FROM $table  $q ";
    }

    return this;
  }

  DBHelper limit(int count, [int offset = 0]) {
    if (_query.contains("SELECT")) {
      if (!_query.contains("LIMIT")) {
        _query += " LIMIT  $count  OFFSET $offset ";
      }
    } else {
      _query += "SELECT * FROM $table LIMIT  $count  OFFSET $offset ";
    }

    return this;
  }

  DBHelper select(dynamic columns) {
    if (columns.runtimeType.toString().contains("String")) {
      if (!_query.contains("SELECT")) {
        _query += "SELECT $columns FROM $table ";
      } else {
        _query += _query.replaceAll("*", columns);
      }
    } else if (columns.runtimeType.toString().contains("List<String>")) {
      if (!_query.contains("SELECT")) {
        _query += "SELECT ${columns.join(",")} FROM $table ";
      } else {
        _query += _query.replaceAll("*", columns.join(","));
      }
    }

    return this;
  }

  Future<List?> all({int? paginate}) async {
    Database db = await database;

    if (paginate != null) {
      limit(paginate);
    }
    if (_query.isEmpty) {
      _query += "SELECT * FROM $table";
    }

    List<Map<String, Object?>> result = await db.rawQuery(_query, _bindings);

    if (result.isEmpty) return null;

    List list = [];

    for (Map data in result) {
      Map newMap = {};
      data.forEach((k, v) {
        if (v.runtimeType.toString() == "DateTime") {
          newMap[k] = (v as DateTime).toIso8601String();
        } else if (v.runtimeType.toString() == "bool") {
          newMap[k] = v as bool ? 1 : 0;
        } else {
          newMap[k] = v;
        }
      });

      _result.add(newMap);
      list.add(fromMap(newMap));
    }
    return list;
  }

  Future<List<Map<String, Object?>>> outerJoin() async {
    Database db = await database;

    // List<Map<String, Object?>> result = await db.rawQuery(
    //     "SELECT * FROM users LEFT OUTER JOIN persons ON users.id = persons.user_id");

    var result = await db.rawQuery("pragma table_info('$table')");

    return result;
    //result.first.values.first as int;
  }

  Future<int> count() async {
    Database db = await database;

    aggregateFunctions(" count ", "*");

    List<Map<String, Object?>> result = await db.rawQuery(_query, _bindings);

    return result.first.values.first as int;
  }

  Future<int> max(String columnName) async {
    Database db = await database;

    aggregateFunctions(" max ", columnName);

    List<Map<String, Object?>> result = await db.rawQuery(_query, _bindings);

    return result.first.values.first as int;
  }

  Future<int> min(String columnName) async {
    Database db = await database;

    aggregateFunctions(" min ", columnName);

    List<Map<String, Object?>> result = await db.rawQuery(_query, _bindings);

    return result.first.values.first as int;
  }

  Future<int> avg(String columnName) async {
    Database db = await database;

    aggregateFunctions(" avg ", columnName);

    List<Map<String, Object?>> result = await db.rawQuery(_query, _bindings);

    return result.first.values.first as int;
  }

  Future<int> sum(String columnName) async {
    Database db = await database;

    aggregateFunctions(" sum ", columnName);

    List<Map<String, Object?>> result = await db.rawQuery(_query, _bindings);

    return result.first.values.first as int;
  }

  void aggregateFunctions(String funcName, String columnName) {
    if (!_query.contains("SELECT")) {
      _query = "SELECT $funcName($columnName) FROM $table";
    } else {
      _query = _query.replaceAll("*", " $funcName($columnName) ");
    }
  }

  Future first({int? paginate}) async {
    Database db = await database;

    if (paginate != null) {
      limit(paginate);
    }

    _result = await db.rawQuery(_query, _bindings);

    if (_result.isEmpty) return null;

    return fromMap(_result.first);
  }

  Future last({int? paginate}) async {
    Database db = await database;

    if (paginate != null) {
      limit(paginate);
    }
    _result = await db.rawQuery(_query, _bindings);

    if (_result.isEmpty) return null;

    return fromMap(_result.last);
  }

  dynamic pluck(col) async {
    var result = [];
    var map = {};

    await all();

    _result.asMap().forEach((k, value) {
      value.forEach((column, v) {
        if (col.runtimeType.toString().contains("List<String>")) {
          col.asMap().forEach((colKey, colValue) {
            if (col[1] == column) {
              map.putIfAbsent(value[col[0]], () => v);
            }
          });
        } else {
          if (col == column) {
            result.add(v);
          }
        }
      });
    });

    return result.isEmpty ? map : result;
  }

  Future insert() async {
    Database db = await database;

    Map data = toMap();

    data.putIfAbsent("created_at", () => DateTime.now());

    int id = await db.insert(
      table,
      handleDataType(data),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return find(id);
  }

  // Future<List> all(dynamic Function(int) generator) async {
  //   var maps = await get();

  //   return List.generate(maps.length, generator);
  // }

  Future update(id) async {
    final db = await database;

    Map<String, Object?> data = toMap();

    data.putIfAbsent("updated_at", () => DateTime.now());

    return await db.update(
      table,
      handleDataType(data),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> handleDataType(data) {
    Map<String, dynamic> newMap = {};
    data.forEach((k, v) {
      if (v.runtimeType.toString() == "DateTime") {
        newMap[k] = (v as DateTime).toIso8601String();
      } else if (v.runtimeType.toString() == "bool") {
        newMap[k] = v as bool ? 1 : 0;
      } else {
        newMap[k] = v;
      }
    });
    return newMap;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> erase() async {
    final db = await database;

    var data = await all();

    if (data != null) {
      for (var model in data) {
        await db.delete(
          table,
          where: 'id = ?',
          whereArgs: [model.id],
        );
      }
    }
  }

  Map<String, Object?> toMap();

  Model fromMap(Map<dynamic, dynamic> map);

  DateTime getDateTime(String dataTime) {
    return DateTime.parse(dataTime);
  }

  bool getBool(int value) {
    return value == 1;
  }
}
