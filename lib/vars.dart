import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const String version = "1.6.0";

List<Clothing> clothes = [];
late ThemeMode themeMode;

String colorToHex(Color color) {
  return color.value.toRadixString(16).substring(2, 8);
}

MaterialColor materialColorMaker(String hex) {
  hex = "FF$hex";
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
  String name;
  int count;
  DateTime? lastChangedDateTime;

  Clothing({
    required this.name,
    required this.count,
    required this.lastChangedDateTime,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "count": count,
        "lastChangedDateTime": lastChangedDateTime?.toIso8601String(),
      };

  Clothing.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        count = json["count"],
        lastChangedDateTime = json["lastChangedDateTime"] == null
            ? null
            : DateTime.parse(json["lastChangedDateTime"] as String);

  String get lastChangedString {
    // dd.mm.yyyy
    if (lastChangedDateTime == null) {
      return "Neznámé";
    }
    return "${lastChangedDateTime!.day}.${lastChangedDateTime!.month}.${lastChangedDateTime!.year}";
  }
}

loadData() async {
  debugPrint("loading data");
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> clothesList = prefs.getStringList("clothes") ?? [];

  for (String clothing in clothesList) {
    debugPrint(clothing);
    clothes.add(Clothing.fromJson(jsonDecode(clothing)));
  }

  //hexColor = prefs.getString("color") ?? "2196f3";

  themeMode = const {
    "light": ThemeMode.light,
    "dark": ThemeMode.dark,
    "system": ThemeMode.system
  }[prefs.getString("theme") ?? "system"]!;

  debugPrint("data loaded");
}

Future saveData() async {
  debugPrint("saving data");

  List<String> clothesList = [];

  for (Clothing clothing in clothes) {
    String json = jsonEncode(clothing);
    clothesList.add(json);
    debugPrint(json);
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setStringList("clothes", clothesList);

  debugPrint("data saved");
}
