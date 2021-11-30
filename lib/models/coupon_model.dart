// To parse this JSON data, do
//
//     final coupon = couponFromJson(jsonString);

import 'dart:convert';

Coupon couponFromJson(String str) => Coupon.fromJson(json.decode(str));

String couponToJson(Coupon data) => json.encode(data.toJson());

class Coupon {
  Coupon({
    this.the0,
    this.amount,
    this.code,
    this.discount,
    this.couponid,
    this.couponPrice,
  });

  dynamic the0;
  String amount;
  String code;
  dynamic discount;
  int couponid;
  String couponPrice;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    the0: json["0"],
    amount: json["amount"],
    code: json["code"],
    discount: json["discount"],
    couponid: json["couponid"],
    couponPrice: json["coupon->price"],
  );

  Map<String, dynamic> toJson() => {
    "0": the0,
    "amount": amount,
    "code": code,
    "discount": discount,
    "couponid": couponid,
    "coupon->price": couponPrice,
  };
}
