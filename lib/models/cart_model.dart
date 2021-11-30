// To parse this JSON data, do
//
//     final carts = cartsFromJson(jsonString);

import 'dart:convert';

Carts cartsFromJson(String str) => Carts.fromJson(json.decode(str));

String cartsToJson(Carts data) => json.encode(data.toJson());

class Carts {
  Carts({
    this.item,
    this.totalQty,
    this.totalPrice,
  });

  List<CartItem> item;
  int totalQty;
  dynamic totalPrice;

  factory Carts.fromJson(Map<String, dynamic> json) => Carts(
    item: List<CartItem>.from(json["item"].map((x) => CartItem.fromJson(x))),
    totalQty: json["totalQty"],
    totalPrice: json["totalPrice"],
  );

  Map<String, dynamic> toJson() => {
    "item": List<dynamic>.from(item.map((x) => x.toJson())),
    "totalQty": totalQty,
    "totalPrice": totalPrice,
  };
}

class CartItem {
  CartItem({
    this.id,
    this.itemid,
    this.image,
    this.name,
    this.itemPrice,
    this.price,
    this.qty,
    this.size,
    this.color,
  });

  int id;
  String itemid;
  String image;
  String name;
  String itemPrice;
  String price;
  int qty;
  String size;
  String color;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["id"],
    itemid: json["itemid"],
    image: json["image"],
    name: json["name"],
    itemPrice: json["item_price"],
    price: json["price"],
    qty: json["qty"],
    size: json["size"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "itemid": itemid,
    "image": image,
    "name": name,
    "item_price": itemPrice,
    "price": price,
    "qty": qty,
    "size": size,
    "color": color,
  };
}
