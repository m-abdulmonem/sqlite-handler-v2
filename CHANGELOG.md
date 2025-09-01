# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-01-01

### Added
- **Major Version Release**: Complete package rewrite and modernization
- **Laravel-like Migration System**: Full-featured migration system with rollback support
- **Migration Runner**: Manages migration execution, dependencies, and batch processing
- **Migration Generator**: CLI tools for creating various types of migrations
- **Schema Builder**: Fluent API for defining database schemas
- **Advanced Query Building**: Enhanced query builder with better performance
- **Comprehensive Data Types**: Support for all SQLite data types including JSON, UUID, geometric types
- **Built-in Encryption**: Password hashing, data encryption, and security utilities
- **Transaction Support**: Database transaction management
- **Relationship Support**: hasOne, hasMany, belongsTo, and many-to-many relationships
- **CLI Tools**: Command-line interface for migration management
- **Example Migrations**: Complete set of example migrations for common use cases

### Changed
- **SDK Requirements**: Updated to Flutter 3.10+ and Dart 3.0+
- **Package Structure**: Reorganized for better maintainability and extensibility
- **API Design**: Fluent API design throughout the package
- **Error Handling**: Comprehensive error handling with custom exceptions
- **Performance**: Optimized query execution and memory management

### Breaking Changes
- **Enum Names**: `SqlTypes` → `SqliteDataType`, `DatabaseOredrs` → `DatabaseOrder`
- **Method Names**: `order()` → `orderBy()`
- **SDK Requirements**: Flutter 3.10+ and Dart 3.0+ required
- **Package Structure**: Complete reorganization of internal structure

### Removed
- **Legacy Code**: Removed outdated and deprecated functionality
- **Old Dependencies**: Replaced with modern, maintained alternatives

## [1.0.0] - 2024-01-01

### Added
- **Modern Flutter Support**: Compatible with Flutter 3.10+ and Dart 3.0+
- **Advanced Query Building**: Fluent API for complex SQL queries
- **Built-in Encryption**: Secure data storage with encryption utilities
- **Rich Data Types**: Support for all SQLite data types including JSON, UUID, and geometric types
- **Laravel-like Migrations**: Easy database schema management with rollback support
- **Schema Builder**: Fluent interface for table creation
- **Relationships**: Support for hasOne, hasMany, belongsTo, and many-to-many relationships
- **Performance**: Optimized for high-performance database operations
- **Error Handling**: Comprehensive error handling with custom exceptions
- **Cross-Platform**: Works on Android, iOS, Windows, macOS, Linux, and Web
- **Migration Generator**: CLI tools for creating and managing migrations

### Changed
- **Description**: Updated to reflect new features and capabilities
- **Dependencies**: Updated all dependencies to latest compatible versions
- **SDK Requirements**: Updated to Flutter 3.10+ and Dart 3.0+

### Breaking Changes
- **Enum Names**: `SqlTypes` → `SqliteDataType`, `DatabaseOredrs` → `DatabaseOrder`
- **Method Names**: `order()` → `orderBy()`
- **SDK Requirements**: Flutter 3.10+ and Dart 3.0+ required

### Migration Notes from v0.0.4 to v2.0.0

1. **Update your `pubspec.yaml`**:
   ```yaml
   dependencies:
     sqlite_handler: ^2.0.0
   ```

2. **Update enum imports**:
   ```dart
   // Old
   import 'package:sqlite_handler/core/enums/sqlite_data_type.dart';
   
   // New
   import 'package:sqlite_handler/sqlite_handler.dart';
   ```

3. **Update enum usage**:
   ```dart
   // Old
   DatabaseOredrs.asc
   
   // New
   DatabaseOrder.ascending
   ```

4. **Update method calls**:
   ```dart
   // Old
   .order(column: 'name', order: DatabaseOredrs.asc)
   
   // New
   .orderBy(column: 'name', order: DatabaseOrder.ascending)
   ```

5. **Review error handling**:
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

## [0.0.4] - 2023-01-01

### Added
- Initial release of SQLite Handler package
- Basic database operations (CRUD)
- Simple query building
- Basic data type support
- Cross-platform compatibility

---

## Support

For questions about migration or new features, please:

1. Check the [README.md](README.md) for comprehensive documentation
2. Review the [migration guide](#migration-notes) above
3. Open an [issue](https://github.com/m-abdulmonem/sqlite-handler-v2/issues) for specific problems
4. Start a [discussion](https://github.com/m-abdulmonem/sqlite-handler-v2/discussions) for general questions

---

*This changelog follows the [Keep a Changelog](https://keepachangelog.com/) format and adheres to [Semantic Versioning](https://semver.org/).*
