// To parse this JSON data, do
//
//     final saleProducts = saleProductsFromJson(jsonString);

import 'dart:convert';

SaleProducts saleProductsFromJson(String str) => SaleProducts.fromJson(json.decode(str));

String saleProductsToJson(SaleProducts data) => json.encode(data.toJson());

class SaleProducts {
  SaleProducts({
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  int draw;
  int recordsTotal;
  int recordsFiltered;
  List<SaleProductsDatum> data;

  factory SaleProducts.fromJson(Map<String, dynamic> json) => SaleProducts(
    draw: json["draw"],
    recordsTotal: json["recordsTotal"],
    recordsFiltered: json["recordsFiltered"],
    data: List<SaleProductsDatum>.from(json["data"].map((x) => SaleProductsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "draw": draw,
    "recordsTotal": recordsTotal,
    "recordsFiltered": recordsFiltered,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SaleProductsDatum {
  SaleProductsDatum({
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

  factory SaleProductsDatum.fromJson(Map<String, dynamic> json) => SaleProductsDatum(
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
