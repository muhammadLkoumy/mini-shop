class FavoritesModel {
  bool? status;
  FavoriteData? data;

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? FavoriteData.fromJson(json['data']) : null;
  }
}

class FavoriteData {
  int? currentPage;
  List<Data>? favorites;

  FavoriteData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      favorites = <Data>[];
      json['data'].forEach((v) {
        favorites!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  int? id;
  FavoriteProduct? product;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'] != null
        ? FavoriteProduct.fromJson(json['product'])
        : null;
  }
}

class FavoriteProduct {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  String? description;

  FavoriteProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
