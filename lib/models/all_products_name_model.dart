// To parse this JSON data, do
//
//     final allProductsName = allProductsNameFromJson(jsonString);

import 'dart:convert';

AllProductsName allProductsNameFromJson(String str) => AllProductsName.fromJson(json.decode(str));

String allProductsNameToJson(AllProductsName data) => json.encode(data.toJson());

class AllProductsName {
  AllProductsName({
    this.products,
  });

  List<Products> products;

  factory AllProductsName.fromJson(Map<String, dynamic> json) => AllProductsName(
    products: List<Products>.from(json["products"].map((x) => Products.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Products {
  Products({
    this.id,
    this.name,
    this.price,
    this.previousPrice,
    this.percent,
    this.image,
  });

  int id;
  String name;
  double price;
  String previousPrice;
  String percent;
  String image;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    id: json["id"],
    name: json["name"],
    price: json["price"].toDouble(),
    previousPrice: json["previous_price"],
    percent: json["percent"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "previous_price": previousPrice,
    "percent": percent,
    "image": image,
  };
}
