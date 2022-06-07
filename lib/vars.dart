String? addedClothing;
List<Clothing> clothes = [];

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
