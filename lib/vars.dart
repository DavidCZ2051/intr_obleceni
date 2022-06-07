String? addedClothing;
List<Clothing> clothes = [];

class Clothing {
  String? name;
  int? count;
  Map toJson() {
    return {
      "name": name,
      "count": count,
    };
  }
}
