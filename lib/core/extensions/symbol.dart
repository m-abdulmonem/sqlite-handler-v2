extension ExtractSymbol on Symbol {
  String get first {
    return toString().replaceAll("Symbol(\"", "").replaceAll('")', "");
  }
}
