
extension Enumations on Enum{
  

  String get getUpperString{
    return getString.toUpperCase();
  }

  
  String get getLowerString{
    return getString.toLowerCase();
  }

  
  String get getString{
    return toString().split(".")[1];
  }

}