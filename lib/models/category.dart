class Category {
  int? id;
  String name;
  String description;

  Category({this.id, required this.name, required this.description});

  categoryMap() {
    var mapping = Map<String, dynamic>();
    if (id != null) {
      mapping['id'] = id;
    }
    mapping['name'] = name;
    mapping['description'] = description;

    return mapping;
  }
}
