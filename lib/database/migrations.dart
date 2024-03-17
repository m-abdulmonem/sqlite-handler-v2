import 'package:file_encryptor/file_encryptor.dart';

import 'package:sqflite/sqflite.dart';

import '/core/extensions/enumations.dart';

import '/core/extensions/string.dart';

import '../core/enums/sqlite_data_type.dart';

class Migrations {
  Map<String, dynamic>? tables = {};

  final List<String> _queries = [];

  Migrations([this.tables]);

  static final Migrations _init = Migrations();

  static Future<void> createTables([Map<String, dynamic>? dbTables]) async {
    var data = dbTables ?? _init.tables;

    if (data == null) {
      throw Exception("You must enter database tables");
    }

    data.forEach((key, value) {
      if (value.runtimeType.toString().contains("Map")) {
        _init._handle(key, value);
      } else {
        _init._queries.add(value().createTable(key));
      }
    });

    // return _init._queries;

    FileEncryptor().encrypt(await _init.path, _init._queries.join(";"));
  }

  Future<List> get getTables async {
    return (await FileEncryptor().decrypt(await _init.path)).split(";");
    // try {
    //   return (await FileCryptor().decrypt(await _init.path)).split(";");
    // } catch (e) {
    //   // If encountering an error, return 0
    //   if (kDebugMode) {
    //     print(e);
    //   }
    //   return [];
    // }
  }

  Future<String> get path async {
    return join(await getDatabasesPath(), 'sqlite_handler_database_tables.aes');
  }

  void _handle(String tableName, columns) {
    var query = 'CREATE TABLE IF NOT EXISTS $tableName (';
    columns.forEach((key, value) {
      if (key == 'id') {
        query += ' $key ${_getType(value)} PRIMARY KEY AUTOINCREMENT, ';
      } else {
        query += '$key ${_getType(value)} ,';
      }
    });
    _queries.add('${query.limitedTrim()})');
  }

  String _getType(SqlTypes sqlTypes) {
    if (sqlTypes == SqlTypes.bool) {
      return SqlTypes.integer.getUpperString;
    }
    return sqlTypes.getUpperString;
  }

  // @override
  // noSuchMethod(Invocation invocation) {
  //   String property = invocation.memberName.first;
  //   if (_columns.containsKey(property)) {
  //     return property;
  //   }
  //   throw Exception("given column name: {$property} is not exists");
  // }
}
