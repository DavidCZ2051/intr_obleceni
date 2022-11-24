import 'package:flutter/material.dart';

String? addedClothing;
String? newName;
List<Clothing> clothes = [];
String version = "1.4.0";
String? hexColor;
String theme = "system";

String colorToHex(Color color) {
  return color.value.toRadixString(16).substring(2, 8);
}

MaterialColor materialColorMaker(String hex) {
  hex = "FF" + hex;
  int hexInt = int.parse(hex, radix: 16);

  return MaterialColor(
    hexInt,
    <int, Color>{
      50: Color(hexInt),
      100: Color(hexInt),
      200: Color(hexInt),
      300: Color(hexInt),
      400: Color(hexInt),
      500: Color(hexInt),
      600: Color(hexInt),
      700: Color(hexInt),
      800: Color(hexInt),
      900: Color(hexInt),
    },
  );
}

class Clothing {
  Clothing({
    required this.name,
    required this.count,
    required this.lastChangedDateTime,
  });
  String? name;
  int? count;
  DateTime? lastChangedDateTime;

  Map toJson() => {
        '"name"': '"$name"',
        '"count"': count,
        '"lastChangedDateTime"':
            lastChangedDateTime == null ? null : '"$lastChangedDateTime"',
      };

  Clothing.fromJson(Map json) {
    name = json["name"];
    count = json["count"];
    lastChangedDateTime = json["lastChangedDateTime"] != null
        ? DateTime.parse(json["lastChangedDateTime"])
        : null;
  }

  String get lastChangedString {
    // dd.mm.yyyy
    if (lastChangedDateTime == null) {
      return "Neznámé";
    }
    return "${lastChangedDateTime!.day}.${lastChangedDateTime!.month}.${lastChangedDateTime!.year}";
  }
}
