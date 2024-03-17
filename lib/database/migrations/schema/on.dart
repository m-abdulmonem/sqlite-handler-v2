class On {
  String _query = "";

  String query = "";

  On(this.query);

  nullOnUpdate() {
    _query += " ON UPDATE SET NULL ";

    if (_query.contains("DELETE")) {
      query = query.contains(",") ? query.replaceAll(",", "") : query;
      return "$query $_query , ";
    }
    return this;
  }

  nullOnDelete() {
    _query += " ON DELETE SET NULL ";

    if (_query.contains("UPDATE")) {
      query = query.contains(",") ? query.replaceAll(",", "") : query;
      return "$query $_query , ";
    }
    return this;
  }

  cascadeOnUpdate() {
    _query += " ON UPDATE SET cascade ";

    if (_query.contains("DELETE")) {
      query = query.contains(",") ? query.replaceAll(",", "") : query;
      return "$query $_query , ";
    }
    return this;
  }

  restrictOnUpdate() {
    _query += " ON UPDATE SET  restrict ";

    if (_query.contains("DELETE")) {
      query = query.contains(",") ? query.replaceAll(",", "") : query;
      return "$query $_query , ";
    }
    return this;
  }

  cascadeOnDelete() {
    _query += " ON DELETE SET cascade ";

    if (_query.contains("UPDATE")) {
      query = query.contains(",") ? query.replaceAll(",", "") : query;
      return "$query $_query , ";
    }
    return this;
  }

  restrictOnDelete() {
    _query += " ON DELETE SET  restrict ";

    if (_query.contains("UPDATE")) {
      query = query.contains(",") ? query.replaceAll(",", "") : query;
      return "$query $_query , ";
    }

    return this;
  }
}
