String? addedClothing;
String? newName;
List<Clothing> clothes = [];
String version = "1.1.0";

class Clothing {
  Clothing({this.name, this.count});
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
