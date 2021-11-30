import 'dart:convert';

DiscountProducts discountProductsFromJson(String str) => DiscountProducts.fromJson(json.decode(str));

String discountProductsToJson(DiscountProducts data) => json.encode(data.toJson());

class DiscountProducts {
  DiscountProducts({
    this.draw,
    this.recordsTotal,
    this.recordsFiltered,
    this.data,
  });

  int draw;
  int recordsTotal;
  int recordsFiltered;
  List<DiscountProductsDatum> data;

  factory DiscountProducts.fromJson(Map<String, dynamic> json) => DiscountProducts(
    draw: json["draw"],
    recordsTotal: json["recordsTotal"],
    recordsFiltered: json["recordsFiltered"],
    data: List<DiscountProductsDatum>.from(json["data"].map((x) => DiscountProductsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "draw": draw,
    "recordsTotal": recordsTotal,
    "recordsFiltered": recordsFiltered,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}


class DiscountProductsDatum {
  DiscountProductsDatum({
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

  factory DiscountProductsDatum.fromJson(Map<String, dynamic> json) => DiscountProductsDatum(
    id: json["id"],
    name: json["name"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"] == null ? null : json["subcategory_id"],
    childcategoryId: json["childcategory_id"] == null ? null : json["childcategory_id"],
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
    "subcategory_id": subcategoryId == null ? null : subcategoryId,
    "childcategory_id": childcategoryId == null ? null : childcategoryId,
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
