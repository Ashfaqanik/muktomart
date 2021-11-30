// To parse this JSON data, do
//
//     final popularProducts = popularProductsFromJson(jsonString);

import 'dart:convert';

PopularProducts popularProductsFromJson(String str) => PopularProducts.fromJson(json.decode(str));

String popularProductsToJson(PopularProducts data) => json.encode(data.toJson());

class PopularProducts {
  PopularProducts({
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  int draw;
  int recordsTotal;
  int recordsFiltered;
  List<PopularProductsDatum> data;

  factory PopularProducts.fromJson(Map<String, dynamic> json) => PopularProducts(
    draw: json["draw"],
    recordsTotal: json["recordsTotal"],
    recordsFiltered: json["recordsFiltered"],
    data: List<PopularProductsDatum>.from(json["data"].map((x) => PopularProductsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "draw": draw,
    "recordsTotal": recordsTotal,
    "recordsFiltered": recordsFiltered,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class PopularProductsDatum {
  PopularProductsDatum({
    this.id,
    this.name,
    this.categoryId,
    this.subcategoryId,
    this.childcategoryId,
    this.discountDateStart,
    this.discountDate,
    this.price,
    this.status,
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
  String discountDateStart;
  dynamic discountDate;
  String price;
  Status status;
  String previousPrice;
  String percent;
  String thumbnail;
  String rating;

  factory PopularProductsDatum.fromJson(Map<String, dynamic> json) => PopularProductsDatum(
    id: json["id"],
    name: json["name"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"] == null ? null : json["subcategory_id"],
    childcategoryId: json["childcategory_id"] == null ? null : json["childcategory_id"],
    discountDateStart: json["discount_date_start"] == null ? null : json["discount_date_start"],
    discountDate: json["discount_date"],
    price: json["price"],
    status: statusValues.map[json["status"]],
    previousPrice: json["previous_price"],
    percent: json["percent"],
    thumbnail: json["thumbnail"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category_id": categoryId,
    "subcategory_id": subcategoryId == null ? null : subcategoryId,
    "childcategory_id": childcategoryId == null ? null : childcategoryId,
    "discount_date_start": discountDateStart == null ? null : discountDateStart,
    "discount_date": discountDate,
    "price": price,
    "status": statusValues.reverse[status],
    "previous_price": previousPrice,
    "percent": percent,
    "thumbnail": thumbnail,
    "rating": rating,
  };
}

enum Status { ACTIVE }

final statusValues = EnumValues({
  "Active": Status.ACTIVE
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
