import '/core/extensions/string.dart';

import 'schema_utils.dart';

class Schema {
  final Map<String, dynamic> _columns = {};

  void id([String name = "id"]) {
    _columns['id'] = " $name INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,";
  }

  SchemaUtils integer(name) {
    var column = SchemaUtils(" $name INTEGER  ");

    _columns[name] = column;

    return column;
  }

  SchemaUtils real(name) {
    var column = SchemaUtils(" $name REAL   ");
    _columns[name] = column;

    return column;
  }

  SchemaUtils foreignId(name) {
    //   FOREIGN KEY (group_id) REFERENCES supplier_groups (id)
    //  ON UPDATE SET NULL
    //  ON DELETE SET NULL
    var column = integer(name);
    _columns[name] = column;

    return column;
  }

  SchemaUtils text(name) {
    var column = SchemaUtils(" $name TEXT   ");
    _columns[name] = column;

    return column;
  }

  SchemaUtils blob(name) {
    var column = SchemaUtils(" $name BLOB  ");
    _columns[name] = column;

    return column;
  }

  void timestamps() {
    _columns['created_at'] = " created_at DATETIME NULL,";
    _columns['updated_at'] = " updated_at DATETIME NULL,";
  }

  String createTable(String tableName) {
    String query = " CREATE TABLE IF NOT EXISTS $tableName ( ", foreigns = "";

    _columns.forEach((k, v) {
      if (v.runtimeType.toString() == "SchemaUtils") {
        if (v.get().contains("FOREIGN")) {
          foreigns += " ${v.get()} ";
        } else {
          query += " ${v.get()}  ";
        }
      } else {
        query += " $v ";
      }
    });

    return ' ${query.limitedTrim()} ${foreigns.isNotEmpty ? ", ${foreigns.limitedTrim()}" : null } ); ';
  }
}
