/// SQLite data types supported by the package
enum SqliteDataType {
  /// Variable-length character string
  varchar,
  /// Integer number
  integer,
  /// Text data
  text,
  /// Real (floating point) number
  real,
  /// Date and time
  dateTime,
  /// Binary large object
  blob,
  /// Boolean value
  boolean,
  /// Numeric data
  numeric,
  /// Character data
  character,
  /// Double precision floating point
  double,
  /// Single precision floating point
  float,
  /// Decimal number
  decimal,
  /// Small integer
  smallInt,
  /// Big integer
  bigInt,
  /// JSON data
  json,
  /// UUID
  uuid,
  /// Email
  email,
  /// URL
  url,
  /// Phone number
  phone,
  /// Currency amount
  currency,
  /// Percentage
  percentage,
  /// Duration
  duration,
  /// File path
  filePath,
  /// IP address
  ipAddress,
  /// MAC address
  macAddress,
  /// Hash
  hash,
  /// Token
  token,
  /// Color
  color,
  /// Coordinates
  coordinates,
  /// Polygon
  polygon,
  /// Point
  point,
  /// Line
  line,
  /// Circle
  circle,
  /// Rectangle
  rectangle,
  /// Triangle
  triangle,
  /// Ellipse
  ellipse,
  /// Arc
  arc,
  /// Curve
  curve,
  /// Surface
  surface,
  /// Volume
  volume,
  /// Matrix
  matrix,
  /// Vector
  vector,
  /// Quaternion
  quaternion,
  /// Complex
  complex,
  /// Rational
  rational,
  /// Fraction
  fraction,
  /// Mixed
  mixed,
  /// Unknown
  unknown;

  /// Get the SQLite type string representation
  String get sqlType {
    switch (this) {
      case SqliteDataType.varchar:
        return 'VARCHAR';
      case SqliteDataType.integer:
        return 'INTEGER';
      case SqliteDataType.text:
        return 'TEXT';
      case SqliteDataType.real:
        return 'REAL';
      case SqliteDataType.dateTime:
        return 'DATETIME';
      case SqliteDataType.blob:
        return 'BLOB';
      case SqliteDataType.boolean:
        return 'BOOLEAN';
      case SqliteDataType.numeric:
        return 'NUMERIC';
      case SqliteDataType.character:
        return 'CHAR';
      case SqliteDataType.double:
        return 'DOUBLE';
      case SqliteDataType.float:
        return 'FLOAT';
      case SqliteDataType.decimal:
        return 'DECIMAL';
      case SqliteDataType.smallInt:
        return 'SMALLINT';
      case SqliteDataType.bigInt:
        return 'BIGINT';
      case SqliteDataType.json:
        return 'JSON';
      case SqliteDataType.uuid:
        return 'UUID';
      case SqliteDataType.email:
        return 'VARCHAR(255)';
      case SqliteDataType.url:
        return 'VARCHAR(2048)';
      case SqliteDataType.phone:
        return 'VARCHAR(20)';
      case SqliteDataType.currency:
        return 'DECIMAL(10,2)';
      case SqliteDataType.percentage:
        return 'DECIMAL(5,2)';
      case SqliteDataType.duration:
        return 'INTEGER';
      case SqliteDataType.filePath:
        return 'VARCHAR(4096)';
      case SqliteDataType.ipAddress:
        return 'VARCHAR(45)';
      case SqliteDataType.macAddress:
        return 'VARCHAR(17)';
      case SqliteDataType.hash:
        return 'VARCHAR(64)';
      case SqliteDataType.token:
        return 'VARCHAR(255)';
      case SqliteDataType.color:
        return 'VARCHAR(7)';
      case SqliteDataType.coordinates:
        return 'TEXT';
      case SqliteDataType.polygon:
        return 'TEXT';
      case SqliteDataType.point:
        return 'TEXT';
      case SqliteDataType.line:
        return 'TEXT';
      case SqliteDataType.circle:
        return 'TEXT';
      case SqliteDataType.rectangle:
        return 'TEXT';
      case SqliteDataType.triangle:
        return 'TEXT';
      case SqliteDataType.ellipse:
        return 'TEXT';
      case SqliteDataType.arc:
        return 'TEXT';
      case SqliteDataType.curve:
        return 'TEXT';
      case SqliteDataType.surface:
        return 'TEXT';
      case SqliteDataType.volume:
        return 'TEXT';
      case SqliteDataType.matrix:
        return 'TEXT';
      case SqliteDataType.vector:
        return 'TEXT';
      case SqliteDataType.quaternion:
        return 'TEXT';
      case SqliteDataType.complex:
        return 'TEXT';
      case SqliteDataType.rational:
        return 'TEXT';
      case SqliteDataType.fraction:
        return 'TEXT';
      case SqliteDataType.mixed:
        return 'TEXT';
      case SqliteDataType.unknown:
        return 'TEXT';
    }
  }

  /// Get the default length for variable-length types
  int? get defaultLength {
    switch (this) {
      case SqliteDataType.varchar:
        return 255;
      case SqliteDataType.character:
        return 1;
      case SqliteDataType.email:
        return 255;
      case SqliteDataType.url:
        return 2048;
      case SqliteDataType.phone:
        return 20;
      case SqliteDataType.hash:
        return 64;
      case SqliteDataType.token:
        return 255;
      case SqliteDataType.color:
        return 7;
      case SqliteDataType.ipAddress:
        return 45;
      case SqliteDataType.macAddress:
        return 17;
      case SqliteDataType.filePath:
        return 4096;
      default:
        return null;
    }
  }

  /// Check if this type supports length specification
  bool get supportsLength {
    return defaultLength != null;
  }

  /// Check if this type is numeric
  bool get isNumeric {
    return [
      SqliteDataType.integer,
      SqliteDataType.real,
      SqliteDataType.numeric,
      SqliteDataType.double,
      SqliteDataType.float,
      SqliteDataType.decimal,
      SqliteDataType.smallInt,
      SqliteDataType.bigInt,
      SqliteDataType.percentage,
      SqliteDataType.currency,
    ].contains(this);
  }

  /// Check if this type is text-based
  bool get isText {
    return [
      SqliteDataType.varchar,
      SqliteDataType.text,
      SqliteDataType.character,
      SqliteDataType.json,
      SqliteDataType.uuid,
      SqliteDataType.email,
      SqliteDataType.url,
      SqliteDataType.phone,
      SqliteDataType.hash,
      SqliteDataType.token,
      SqliteDataType.color,
      SqliteDataType.ipAddress,
      SqliteDataType.macAddress,
      SqliteDataType.filePath,
      SqliteDataType.coordinates,
      SqliteDataType.polygon,
      SqliteDataType.point,
      SqliteDataType.line,
      SqliteDataType.circle,
      SqliteDataType.rectangle,
      SqliteDataType.triangle,
      SqliteDataType.ellipse,
      SqliteDataType.arc,
      SqliteDataType.curve,
      SqliteDataType.surface,
      SqliteDataType.volume,
      SqliteDataType.matrix,
      SqliteDataType.vector,
      SqliteDataType.quaternion,
      SqliteDataType.complex,
      SqliteDataType.rational,
      SqliteDataType.fraction,
      SqliteDataType.mixed,
      SqliteDataType.unknown,
    ].contains(this);
  }

  /// Check if this type is date/time related
  bool get isDateTime {
    return this == SqliteDataType.dateTime;
  }

  /// Check if this type is boolean
  bool get isBoolean {
    return this == SqliteDataType.boolean;
  }

  /// Check if this type is blob
  bool get isBlob {
    return this == SqliteDataType.blob;
  }
}