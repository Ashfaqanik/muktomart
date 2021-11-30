// To parse this JSON data, do
//
//     final checkOut = checkOutFromJson(jsonString);

import 'dart:convert';

CheckOut checkOutFromJson(String str) => CheckOut.fromJson(json.decode(str));

String checkOutToJson(CheckOut data) => json.encode(data.toJson());

class CheckOut {
  CheckOut({
    this.products,
    this.totalPrice,
    this.pickups,
    this.totalQty,
    this.gateways,
    this.shippingCost,
    this.digital,
    this.curr,
    this.shippingData,
    this.packageData,
    this.vendorShippingId,
    this.vendorPackingId,
  });

  List<Product> products;
  dynamic totalPrice;
  List<Pickup> pickups;
  int totalQty;
  List<dynamic> gateways;
  int shippingCost;
  int digital;
  Curr curr;
  List<ShippingDatum> shippingData;
  List<PackageDatum> packageData;
  dynamic vendorShippingId;
  dynamic vendorPackingId;

  factory CheckOut.fromJson(Map<String, dynamic> json) => CheckOut(
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    totalPrice: json["totalPrice"],
    pickups: List<Pickup>.from(json["pickups"].map((x) => Pickup.fromJson(x))),
    totalQty: json["totalQty"],
    gateways: List<dynamic>.from(json["gateways"].map((x) => x)),
    shippingCost: json["shipping_cost"],
    digital: json["digital"],
    curr: Curr.fromJson(json["curr"]),
    shippingData: List<ShippingDatum>.from(json["shipping_data"].map((x) => ShippingDatum.fromJson(x))),
    packageData: List<PackageDatum>.from(json["package_data"].map((x) => PackageDatum.fromJson(x))),
    vendorShippingId: json["vendor_shipping_id"],
    vendorPackingId: json["vendor_packing_id"],
  );

  Map<String, dynamic> toJson() => {
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "totalPrice": totalPrice,
    "pickups": List<dynamic>.from(pickups.map((x) => x.toJson())),
    "totalQty": totalQty,
    "gateways": List<dynamic>.from(gateways.map((x) => x)),
    "shipping_cost": shippingCost,
    "digital": digital,
    "curr": curr.toJson(),
    "shipping_data": List<dynamic>.from(shippingData.map((x) => x.toJson())),
    "package_data": List<dynamic>.from(packageData.map((x) => x.toJson())),
    "vendor_shipping_id": vendorShippingId,
    "vendor_packing_id": vendorPackingId,
  };
}

class Curr {
  Curr({
    this.id,
    this.name,
    this.sign,
    this.value,
    this.isDefault,
  });

  int id;
  String name;
  String sign;
  int value;
  int isDefault;

  factory Curr.fromJson(Map<String, dynamic> json) => Curr(
    id: json["id"],
    name: json["name"],
    sign: json["sign"],
    value: json["value"],
    isDefault: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "sign": sign,
    "value": value,
    "is_default": isDefault,
  };
}

class PackageDatum {
  PackageDatum({
    this.id,
    this.userId,
    this.title,
    this.subtitle,
    this.price,
  });

  int id;
  int userId;
  String title;
  String subtitle;
  dynamic price;

  factory PackageDatum.fromJson(Map<String, dynamic> json) => PackageDatum(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    subtitle: json["subtitle"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "subtitle": subtitle,
    "price": price,
  };
}

class Pickup {
  Pickup({
    this.id,
    this.location,
  });

  int id;
  String location;

  factory Pickup.fromJson(Map<String, dynamic> json) => Pickup(
    id: json["id"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
  };
}

class Product {
  Product({
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

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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

class ShippingDatum {
  ShippingDatum({
    this.id,
    this.userId,
    this.districtId,
    this.title,
    this.subtitle,
    this.price,
    this.forPickup,
    this.sConAmount,
    this.groupId,
    this.startDate,
    this.endDate,
    this.status,
  });

  int id;
  int userId;
  String districtId;
  String title;
  String subtitle;
  dynamic price;
  int forPickup;
  int sConAmount;
  int groupId;
  dynamic startDate;
  dynamic endDate;
  int status;

  factory ShippingDatum.fromJson(Map<String, dynamic> json) => ShippingDatum(
    id: json["id"],
    userId: json["user_id"],
    districtId: json["district_id"],
    title: json["title"],
    subtitle: json["subtitle"],
    price: json["price"],
    forPickup: json["for_pickup"],
    sConAmount: json["s_con_amount"],
    groupId: json["group_id"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "district_id": districtId,
    "title": title,
    "subtitle": subtitle,
    "price": price,
    "for_pickup": forPickup,
    "s_con_amount": sConAmount,
    "group_id": groupId,
    "start_date": startDate,
    "end_date": endDate,
    "status": status,
  };
}
