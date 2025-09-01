/// Database ordering options for query results
enum DatabaseOrder {
  /// Ascending order (A-Z, 1-9)
  ascending,
  /// Descending order (Z-A, 9-1)
  descending,
  /// Random order
  random,
  /// Natural order (as stored)
  natural;

  /// Get the SQL ORDER BY string representation
  String get sqlString {
    switch (this) {
      case DatabaseOrder.ascending:
        return 'ASC';
      case DatabaseOrder.descending:
        return 'DESC';
      case DatabaseOrder.random:
        return 'RANDOM()';
      case DatabaseOrder.natural:
        return '';
    }
  }

  /// Get the uppercase string representation (for backward compatibility)
  String get getUpperString => sqlString;

  /// Check if this order requires a column specification
  bool get requiresColumn {
    return this != DatabaseOrder.random;
  }

  /// Get the display name
  String get displayName {
    switch (this) {
      case DatabaseOrder.ascending:
        return 'Ascending';
      case DatabaseOrder.descending:
        return 'Descending';
      case DatabaseOrder.random:
        return 'Random';
      case DatabaseOrder.natural:
        return 'Natural';
    }
  }
}

/// Legacy enum for backward compatibility
@Deprecated('Use DatabaseOrder instead')
enum DatabaseOredrs {
  /// Ascending order
  asc,
  /// Descending order
  desc;

  /// Get the SQL ORDER BY string representation
  String get getUpperString {
    switch (this) {
      case DatabaseOredrs.asc:
        return 'ASC';
      case DatabaseOredrs.desc:
        return 'DESC';
    }
  }
}