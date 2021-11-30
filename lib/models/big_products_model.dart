// To parse this JSON data, do
//
//     final bigProducts = bigProductsFromJson(jsonString);

import 'dart:convert';

BigProducts bigProductsFromJson(String str) => BigProducts.fromJson(json.decode(str));

String bigProductsToJson(BigProducts data) => json.encode(data.toJson());

class BigProducts {
  BigProducts({
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  int draw;
  int recordsTotal;
  int recordsFiltered;
  List<BigProductsDatum> data;

  factory BigProducts.fromJson(Map<String, dynamic> json) => BigProducts(
    draw: json["draw"],
    recordsTotal: json["recordsTotal"],
    recordsFiltered: json["recordsFiltered"],
    data: List<BigProductsDatum>.from(json["data"].map((x) => BigProductsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "draw": draw,
    "recordsTotal": recordsTotal,
    "recordsFiltered": recordsFiltered,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BigProductsDatum {
  BigProductsDatum({
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
  String status;
  String previousPrice;
  String percent;
  String thumbnail;
  String rating;

  factory BigProductsDatum.fromJson(Map<String, dynamic> json) => BigProductsDatum(
    id: json["id"],
    name: json["name"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    childcategoryId: json["childcategory_id"],
    discountDateStart: json["discount_date_start"] == null ? null : json["discount_date_start"],
    discountDate: json["discount_date"],
    price: json["price"],
    status: json["status"],
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
    "discount_date_start": discountDateStart == null ? null : discountDateStart,
    "discount_date": discountDate,
    "price": price,
    "status": status,
    "previous_price": previousPrice,
    "percent": percent,
    "thumbnail": thumbnail,
    "rating": rating,
  };
}
