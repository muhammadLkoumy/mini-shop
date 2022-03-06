class CategoriesModel {
  bool? status;
  CategoriesData? data;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CategoriesData.fromJson(json['data']);
  }
}

class CategoriesData {
  List<CategoryElement> elements = [];

  CategoriesData.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((item) {
      elements.add(CategoryElement.fromJson(item));
    });
  }
}

class CategoryElement {
  int? id;
  String? name;
  String? image;

  CategoryElement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
