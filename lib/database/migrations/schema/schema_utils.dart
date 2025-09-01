/// Schema utilities for adding constraints and modifiers to columns
/// 
/// This class provides a fluent interface for adding various constraints
/// and modifiers to database columns during schema definition.
/// 
/// Example usage:
/// ```dart
/// final schema = Schema()
///   ..text('email').notNull().unique()
///   ..integer('age').defaultValue(18).check('age >= 0')
///   ..decimal('price').notNull().defaultValue(0.0);
/// ```
class SchemaUtils {
  final String _columnDefinition;
  final List<String> _constraints = [];

  /// Creates a new schema utility instance
  /// 
  /// [columnDefinition] should be the basic column definition
  /// (e.g., "name TEXT", "age INTEGER")
  SchemaUtils(this._columnDefinition);

  /// Add NOT NULL constraint
  /// 
  /// Makes the column required (cannot contain NULL values).
  SchemaUtils notNull() {
    _constraints.add("NOT NULL");
    return this;
  }

  /// Add UNIQUE constraint
  /// 
  /// Ensures all values in the column are unique across the table.
  SchemaUtils unique() {
    _constraints.add("UNIQUE");
    return this;
  }

  /// Add PRIMARY KEY constraint
  /// 
  /// Makes the column the primary key for the table.
  SchemaUtils primaryKey() {
    _constraints.add("PRIMARY KEY");
    return this;
  }

  /// Add AUTOINCREMENT modifier
  /// 
  /// Makes the column automatically increment for each new row.
  /// Only works with INTEGER PRIMARY KEY columns.
  SchemaUtils autoIncrement() {
    _constraints.add("AUTOINCREMENT");
    return this;
  }

  /// Add DEFAULT value constraint
  /// 
  /// Sets a default value for the column when no value is specified.
  /// [value] can be a string, number, or SQL expression.
  SchemaUtils defaultValue(dynamic value) {
    if (value is String) {
      _constraints.add("DEFAULT '$value'");
    } else {
      _constraints.add("DEFAULT $value");
    }
    return this;
  }

  /// Add CHECK constraint
  /// 
  /// Adds a condition that must be true for all values in the column.
  /// [condition] should be a valid SQL expression.
  SchemaUtils check(String condition) {
    _constraints.add("CHECK ($condition)");
    return this;
  }

  /// Add COLLATE clause
  /// 
  /// Specifies the collation sequence for text comparisons.
  /// Common values: NOCASE, RTRIM, BINARY
  SchemaUtils collate(String collation) {
    _constraints.add("COLLATE $collation");
    return this;
  }

  /// Add FOREIGN KEY constraint
  /// 
  /// Creates a foreign key relationship to another table.
  /// [referencedTable] is the table being referenced.
  /// [referencedColumn] is the column being referenced (usually 'id').
  /// [onDelete] specifies what happens when the referenced row is deleted.
  /// [onUpdate] specifies what happens when the referenced row is updated.
  SchemaUtils foreignKey(
    String referencedTable,
    String referencedColumn, {
    String? onDelete,
    String? onUpdate,
  }) {
    final constraint = StringBuffer();
    constraint.write("FOREIGN KEY REFERENCES $referencedTable($referencedColumn)");
    
    if (onDelete != null) {
      constraint.write(" ON DELETE $onDelete");
    }
    
    if (onUpdate != null) {
      constraint.write(" ON UPDATE $onUpdate");
    }
    
    _constraints.add(constraint.toString());
    return this;
  }

  /// Add INDEX hint
  /// 
  /// Suggests that an index should be created for this column.
  /// This is a hint to the database optimizer.
  SchemaUtils indexed() {
    _constraints.add("INDEXED");
    return this;
  }

  /// Add STORED modifier
  /// 
  /// Indicates that the column value should be stored rather than computed.
  /// Useful for computed columns.
  SchemaUtils stored() {
    _constraints.add("STORED");
    return this;
  }

  /// Add VIRTUAL modifier
  /// 
  /// Indicates that the column value is computed and not stored.
  /// Useful for computed columns.
  SchemaUtils virtual() {
    _constraints.add("VIRTUAL");
    return this;
  }

  /// Add GENERATED ALWAYS AS constraint
  /// 
  /// Creates a computed column that is always generated from an expression.
  /// [expression] should be a valid SQL expression.
  SchemaUtils generatedAlwaysAs(String expression) {
    _constraints.add("GENERATED ALWAYS AS ($expression)");
    return this;
  }

  /// Add STORED modifier for generated columns
  /// 
  /// Makes a generated column store its computed values.
  SchemaUtils generatedStored() {
    _constraints.add("STORED");
    return this;
  }

  /// Add VIRTUAL modifier for generated columns
  /// 
  /// Makes a generated column compute values on-demand.
  SchemaUtils generatedVirtual() {
    _constraints.add("VIRTUAL");
    return this;
  }

  /// Add INLINE modifier
  /// 
  /// Suggests that small values should be stored inline rather than in overflow pages.
  SchemaUtils inline() {
    _constraints.add("INLINE");
    return this;
  }

  /// Add COMPRESSED modifier
  /// 
  /// Suggests that the column data should be compressed.
  SchemaUtils compressed() {
    _constraints.add("COMPRESSED");
    return this;
  }

  /// Add ENCRYPTED modifier
  /// 
  /// Suggests that the column data should be encrypted.
  SchemaUtils encrypted() {
    _constraints.add("ENCRYPTED");
    return this;
  }

  /// Add HIDDEN modifier
  /// 
  /// Makes the column hidden from SELECT * queries.
  SchemaUtils hidden() {
    _constraints.add("HIDDEN");
    return this;
  }

  /// Add INVISIBLE modifier
  /// 
  /// Makes the column invisible to applications.
  SchemaUtils invisible() {
    _constraints.add("INVISIBLE");
    return this;
  }

  /// Add READONLY modifier
  /// 
  /// Makes the column read-only (cannot be updated).
  SchemaUtils readOnly() {
    _constraints.add("READONLY");
    return this;
  }

  /// Add WRITABLE modifier
  /// 
  /// Makes the column writable (can be updated).
  SchemaUtils writable() {
    _constraints.add("WRITABLE");
    return this;
  }

  /// Add IMMUTABLE modifier
  /// 
  /// Indicates that the column value never changes after creation.
  SchemaUtils immutable() {
    _constraints.add("IMMUTABLE");
    return this;
  }

  /// Add MUTABLE modifier
  /// 
  /// Indicates that the column value can change after creation.
  SchemaUtils mutable() {
    _constraints.add("MUTABLE");
    return this;
  }

  /// Add DETERMINISTIC modifier
  /// 
  /// Indicates that the column value is deterministic (same input always produces same output).
  SchemaUtils deterministic() {
    _constraints.add("DETERMINISTIC");
    return this;
  }

  /// Add NON-DETERMINISTIC modifier
  /// 
  /// Indicates that the column value is non-deterministic.
  SchemaUtils nonDeterministic() {
    _constraints.add("NON-DETERMINISTIC");
    return this;
  }

  /// Add LEAKPROOF modifier
  /// 
  /// Indicates that the column function is leakproof (doesn't reveal information about its arguments).
  SchemaUtils leakproof() {
    _constraints.add("LEAKPROOF");
    return this;
  }

  /// Add PARALLEL SAFE modifier
  /// 
  /// Indicates that the column function is safe to use in parallel queries.
  SchemaUtils parallelSafe() {
    _constraints.add("PARALLEL SAFE");
    return this;
  }

  /// Add PARALLEL RESTRICTED modifier
  /// 
  /// Indicates that the column function cannot be used in parallel queries.
  SchemaUtils parallelRestricted() {
    _constraints.add("PARALLEL RESTRICTED");
    return this;
  }

  /// Add PARALLEL UNSAFE modifier
  /// 
  /// Indicates that the column function is unsafe for parallel queries.
  SchemaUtils parallelUnsafe() {
    _constraints.add("PARALLEL UNSAFE");
    return this;
  }

  /// Add COST modifier
  /// 
  /// Sets the estimated execution cost for the column function.
  /// [cost] should be a positive number.
  SchemaUtils cost(double cost) {
    _constraints.add("COST $cost");
    return this;
  }

  /// Add ROWS modifier
  /// 
  /// Sets the estimated number of rows returned by the column function.
  /// [rows] should be a positive number.
  SchemaUtils rows(int rows) {
    _constraints.add("ROWS $rows");
    return this;
  }

  /// Add SUPPORT modifier
  /// 
  /// Specifies the support function for the column.
  /// [function] should be the name of a support function.
  SchemaUtils support(String function) {
    _constraints.add("SUPPORT $function");
    return this;
  }

  /// Add COMMENT modifier
  /// 
  /// Adds a comment describing the column.
  /// [comment] should be a descriptive string.
  SchemaUtils comment(String comment) {
    _constraints.add("COMMENT '$comment'");
    return this;
  }

  /// Add custom constraint
  /// 
  /// Adds a custom constraint string.
  /// [constraint] should be a valid SQL constraint.
  SchemaUtils custom(String constraint) {
    _constraints.add(constraint);
    return this;
  }

  /// Get the complete column definition
  /// 
  /// Returns the column definition with all constraints applied.
  String get() {
    if (_constraints.isEmpty) {
      return _columnDefinition;
    }
    
    final buffer = StringBuffer();
    buffer.write(_columnDefinition);
    buffer.write(" ");
    buffer.write(_constraints.join(" "));
    return buffer.toString();
  }

  /// Get the column name
  /// 
  /// Extracts the column name from the column definition.
  String get columnName {
    final parts = _columnDefinition.trim().split(' ');
    return parts[1]; // Skip the first part (usually empty due to leading space)
  }

  /// Get the column type
  /// 
  /// Extracts the column type from the column definition.
  String get columnType {
    final parts = _columnDefinition.trim().split(' ');
    return parts[2]; // Skip the first two parts (empty and column name)
  }

  /// Check if the column has a specific constraint
  /// 
  /// Returns true if the column has the specified constraint, false otherwise.
  bool hasConstraint(String constraint) {
    return _constraints.any((c) => c.toUpperCase().contains(constraint.toUpperCase()));
  }

  /// Get all constraints
  /// 
  /// Returns a list of all constraints applied to this column.
  List<String> get constraints => List.unmodifiable(_constraints);

  /// Get constraint count
  /// 
  /// Returns the number of constraints applied to this column.
  int get constraintCount => _constraints.length;

  /// Check if the column has any constraints
  /// 
  /// Returns true if the column has constraints, false otherwise.
  bool get hasConstraints => _constraints.isNotEmpty;

  /// Clear all constraints
  /// 
  /// Removes all constraints from the column.
  void clearConstraints() {
    _constraints.clear();
  }

  /// Remove a specific constraint
  /// 
  /// Removes the first occurrence of the specified constraint.
  /// Returns true if the constraint was removed, false otherwise.
  bool removeConstraint(String constraint) {
    return _constraints.remove(constraint);
  }

  /// Replace a constraint
  /// 
  /// Replaces the first occurrence of [oldConstraint] with [newConstraint].
  /// Returns true if the constraint was replaced, false otherwise.
  bool replaceConstraint(String oldConstraint, String newConstraint) {
    final index = _constraints.indexOf(oldConstraint);
    if (index != -1) {
      _constraints[index] = newConstraint;
      return true;
    }
    return false;
  }
}
