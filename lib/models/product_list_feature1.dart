// To parse this JSON data, do
//
//     final productListFeature = productListFeatureFromJson(jsonString);

import 'dart:convert';

ProductListFeature1 productListFeature1FromJson(String str) => ProductListFeature1.fromJson(json.decode(str));

String productListFeature1ToJson(ProductListFeature1 data) => json.encode(data.toJson());

class ProductListFeature1 {
  ProductListFeature1({
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  int draw;
  int recordsTotal;
  int recordsFiltered;
  List<Datum1> data;

  factory ProductListFeature1.fromJson(Map<String, dynamic> json) => ProductListFeature1(
    draw: json["draw"],
    recordsTotal: json["recordsTotal"],
    recordsFiltered: json["recordsFiltered"],
    data: List<Datum1>.from(json["data"].map((x) => Datum1.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "draw": draw,
    "recordsTotal": recordsTotal,
    "recordsFiltered": recordsFiltered,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum1 {
  Datum1({
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
  dynamic discountDateStart;
  dynamic discountDate;
  String price;
  String status;
  String previousPrice;
  String percent;
  String thumbnail;
  String rating;

  factory Datum1.fromJson(Map<String, dynamic> json) => Datum1(
    id: json["id"],
    name: json["name"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    childcategoryId: json["childcategory_id"],
    discountDateStart: json["discount_date_start"],
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
    "discount_date_start": discountDateStart,
    "discount_date": discountDate,
    "price": price,
    "status": status,
    "previous_price": previousPrice,
    "percent": percent,
    "thumbnail": thumbnail,
    "rating": rating,
  };
}
