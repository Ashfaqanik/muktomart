// To parse this JSON data, do
//
//     final categoryProductsModel = categoryProductsModelFromJson(jsonString);

import 'dart:convert';

CategoryProductsModel categoryProductsModelFromJson(String str) => CategoryProductsModel.fromJson(json.decode(str));

String categoryProductsModelToJson(CategoryProductsModel data) => json.encode(data.toJson());

class CategoryProductsModel {
  CategoryProductsModel({
    this.data,
  });

  List<CategoryProductsModelDatum> data;

  factory CategoryProductsModel.fromJson(Map<String, dynamic> json) => CategoryProductsModel(
    data: List<CategoryProductsModelDatum>.from(json["data"].map((x) => CategoryProductsModelDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CategoryProductsModelDatum {
  CategoryProductsModelDatum({
    this.id,
    this.name,
    this.categoryId,
    this.subcategoryId,
    this.childcategoryId,
    this.price,
    this.previousPrice,
    this.percent,
    this.thumbnail,
    this.rating,
  });

  int id;
  String name;
  int categoryId;
  int subcategoryId;
  int childcategoryId;
  String price;
  String previousPrice;
  String percent;
  String thumbnail;
  String rating;

  factory CategoryProductsModelDatum.fromJson(Map<String, dynamic> json) => CategoryProductsModelDatum(
    id: json["id"],
    name: json["name"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    childcategoryId: json["childcategory_id"],
    price: json["price"],
    previousPrice: json["previous_price"],
    percent: json["percent"],
    thumbnail: json["thumbnail"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "childcategory_id": childcategoryId,
    "price": price,
    "previous_price": previousPrice,
    "percent": percent,
    "thumbnail": thumbnail,
    "rating": rating,
  };
}

enum PreviousPrice { THE_0 }

final previousPriceValues = EnumValues({
  "৳0": PreviousPrice.THE_0
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
