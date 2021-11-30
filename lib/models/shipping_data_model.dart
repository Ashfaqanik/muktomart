// To parse this JSON data, do
//
//     final shippingDataModel = shippingDataModelFromJson(jsonString);

import 'dart:convert';

ShippingDataModel shippingDataModelFromJson(String str) => ShippingDataModel.fromJson(json.decode(str));

String shippingDataModelToJson(ShippingDataModel data) => json.encode(data.toJson());

class ShippingDataModel {
  ShippingDataModel({
    this.shipping,
  });

  List<Shipping> shipping;

  factory ShippingDataModel.fromJson(Map<String, dynamic> json) => ShippingDataModel(
    shipping: List<Shipping>.from(json["shipping"].map((x) => Shipping.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "shipping": List<dynamic>.from(shipping.map((x) => x.toJson())),
  };
}

class Shipping {
  Shipping({
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
  int price;
  int forPickup;
  int sConAmount;
  int groupId;
  dynamic startDate;
  dynamic endDate;
  int status;

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
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
