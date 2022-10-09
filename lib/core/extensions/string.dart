extension CustomStringExtenstion on String {
  String limitedTrim({String char = ',', bool last = true}) {
    String result = "";

    if (!last) {
      result = substring(0, indexOf(char));
    } else if (contains(char)) {
      result = substring(0, lastIndexOf(char));
    }

    return result;
  }

  String get toCapitalize => "${this[0].toUpperCase()}${substring(1)}";
}
