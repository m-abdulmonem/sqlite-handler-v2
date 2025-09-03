import 'package:sqlite_handler/core/enums/orders.dart';
import 'package:sqlite_handler/core/enums/sqlite_data_type.dart';

String runOrdersAndTypesDemo() {
  final orders = DatabaseOrder.values.map((o) => '${o.displayName} -> ${o.sqlString}').join(', ');
  final types = SqliteDataType.values
      .take(20)
      .map((t) => '${t.name}:${t.sqlType}${t.supportsLength ? '(${t.defaultLength})' : ''}')
      .join(', ');
  return 'Orders: $orders\nTypes(sample): $types';
}


