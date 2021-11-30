// To parse this JSON data, do
//
//     final topProducts = topProductsFromJson(jsonString);

import 'dart:convert';

TopProducts topProductsFromJson(String str) => TopProducts.fromJson(json.decode(str));

String topProductsToJson(TopProducts data) => json.encode(data.toJson());

class TopProducts {
  TopProducts({
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  int draw;
  int recordsTotal;
  int recordsFiltered;
  List<TopProductsDatum> data;

  factory TopProducts.fromJson(Map<String, dynamic> json) => TopProducts(
    draw: json["draw"],
    recordsTotal: json["recordsTotal"],
    recordsFiltered: json["recordsFiltered"],
    data: List<TopProductsDatum>.from(json["data"].map((x) => TopProductsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "draw": draw,
    "recordsTotal": recordsTotal,
    "recordsFiltered": recordsFiltered,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class TopProductsDatum {
  TopProductsDatum({
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
  Status status;
  String previousPrice;
  String percent;
  String thumbnail;
  String rating;

  factory TopProductsDatum.fromJson(Map<String, dynamic> json) => TopProductsDatum(
    id: json["id"],
    name: json["name"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"] == null ? null : json["subcategory_id"],
    childcategoryId: json["childcategory_id"] == null ? null : json["childcategory_id"],
    discountDateStart: json["discount_date_start"],
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
    "discount_date_start": discountDateStart,
    "discount_date": discountDate,
    "price": price,
    "status": statusValues.reverse[status],
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
