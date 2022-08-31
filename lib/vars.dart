String? addedClothing;
String? newName;
List<Clothing> clothes = [];
String version = "1.3.0";

class Clothing {
  Clothing({required this.name, required this.count});
  String? name;
  int? count;

  Map toJson() => {
        '"name"': '"$name"',
        '"count"': '"$count"',
      };

  Clothing.fromJson(Map json) {
    name = json["name"];
    count = int.parse(json["count"]);
  }
}
