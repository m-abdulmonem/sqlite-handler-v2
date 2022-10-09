class SchemaUtils {
  String column;

  SchemaUtils(this.column);

  nullable() {
    if (!column.contains("NULL")) {
      if (!column.contains(",")) {
        column += " NULL ,";
      } else {
        column = "${column.replaceAll(",", "")} NULL ,";
      }
    }
    return this;
  }

  notNull() {
    if (!column.contains("NOT  NULL")) {
      if (!column.contains(",")) {
        column += " NOT  NULL ,";
      } else {
        column = "${column.replaceAll(",", "")} NOT  NULL ,";
      }
    }
    return this;
  }

  unique() {
    if (!column.contains("UNIQUE")) {
      if (!column.contains(",")) {
        column += " UNIQUE ,";
      } else {
        column = "${column.replaceAll(",", "")} UNIQUE ,";
      }
    }
    return this;
  }

  defaultValue(dynamic value) {
    if (!column.contains("DEFAULT")) {
      if (!column.contains(",")) {
        column += "   DEFAULT  ,";
      } else {
        column = "${column.replaceAll(",", "")}   DEFAULT $value ,";
      }
    }
    return this;
  }

  check(String expression) {
    if (!column.contains("CHECK")) {
      if (!column.contains(",")) {
        column += " CHECK($expression)  ,";
      } else {
        column = "${column.replaceAll(",", "")}   CHECK($expression)  ,";
      }
    }
    return this;
  }

  String get() {
    return column;
  }
}
