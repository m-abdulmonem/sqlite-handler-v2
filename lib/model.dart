import 'database/database_helper.dart';

/// Base model class for SQLite Handler
/// 
/// This class provides the foundation for all data models
/// in your application. Extend this class to create your own models.
/// 
/// Example:
/// ```dart
/// class User extends Model {
///   User({required super.table});
///   
///   @override
///   Map<String, Object?> toMap() => {
///     'id': id,
///     'name': name,
///     'email': email,
///   };
///   
///   @override
///   Model fromMap(Map<dynamic, dynamic> map) => User(
///     table: tableName,
///   )..id = map['id'] as int? ?? 0
///     ..name = map['name'] as String? ?? ''
///     ..email = map['email'] as String? ?? '';
/// }
/// ```
abstract class Model extends DBHelper {
  Model({required String table}) : super(table);

  /// Convert the model to a map for database operations
  @override
  Map<String, Object?> toMap();
  
  /// Create a model instance from a map
  @override
  Model fromMap(Map<dynamic, dynamic> map);

  /// Get the table name for this model
  String get tableName => table;
}
