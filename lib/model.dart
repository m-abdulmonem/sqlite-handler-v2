library sqlite_handler;


import 'database/database_helper.dart';
export 'core/enums/sqlite_data_type.dart';
export 'database/migrations/schema/schema.dart';
export 'database/migrations.dart';

abstract class Model extends DBHelper {
  Model(String table) : super(table);

  @override
  Model fromMap(Map<dynamic, dynamic> map);

  @override
  Map<String, Object?> toMap();

  @override
  String toString() {
    return "$runtimeType() : ${toMap().toString()}";
  }

  // @override
  // noSuchMethod(Invocation invocation) {
  //   String property = invocation.memberName.first;
  //   if (columns.contains(property)) {
  //     return property;
  //   }
  //   throw Exception("given column name: {$property} is not exists");
  // }
}
