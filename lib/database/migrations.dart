import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '/core/extensions/enumations.dart';

import '/core/extensions/string.dart';

import '../core/enums/sqlite_data_type.dart';

import 'dart:convert';

class Migrations {
  Map<String, dynamic>? tables = {};

  final List<String> _queries = [];

  Migrations([this.tables]);

  static final Migrations _init = Migrations();

  static void createTables([Map<String, dynamic>? dbTables]) async {
    var data = dbTables ?? _init.tables;

    if (data == null) {
      throw Exception("You must enter database tables");
    }

    final file = File(await _init.path);

    // String credentials = "username:password";

    data.forEach((key, value) {
      if (value.runtimeType.toString().contains("Map")) {
        _init._handle(key, value);
      } else {
        _init._queries.add(value().createTable(key));
      }
    });

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(_init._queries.join(";"));

    file.writeAsString(encoded);

    // String decoded = stringToBase64.decode(encoded);

    // GetStorage().write(_init._key, _init.queries);
  }

  Future<List> get getTables async {
    try {
      final file = File(await _init.path);

      // Read the file
      final tables = await file.readAsString();

      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      return stringToBase64.decode(tables).split(";");
    } catch (e) {
      // If encountering an error, return 0
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<String> get path async {
    return join(await getDatabasesPath(), 'sqlite_handler_database_tables.txt');
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
