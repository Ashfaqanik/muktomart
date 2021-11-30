// To parse this JSON data, do
//
//     final bulkOrders = bulkOrdersFromJson(jsonString);

import 'dart:convert';

BulkOrders bulkOrdersFromJson(String str) => BulkOrders.fromJson(json.decode(str));

String bulkOrdersToJson(BulkOrders data) => json.encode(data.toJson());

class BulkOrders {
  BulkOrders({
    this.orders,
  });

  List<Order> orders;

  factory BulkOrders.fromJson(Map<String, dynamic> json) => BulkOrders(
    orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
  };
}

class Order {
  Order({
    this.id,
    this.userId,
    this.orderFile,
    this.orderId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  String orderFile;
  String orderId;
  int status;
  AtedAt createdAt;
  AtedAt updatedAt;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    userId: json["user_id"],
    orderFile: json["order_file"],
    orderId: json["order_id"],
    status: json["status"],
    createdAt: AtedAt.fromJson(json["created_at"]),
    updatedAt: AtedAt.fromJson(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "order_file": orderFile,
    "order_id": orderId,
    "status": status,
    "created_at": createdAt.toJson(),
    "updated_at": updatedAt.toJson(),
  };
}

class AtedAt {
  AtedAt({
    this.date,
    this.timezoneType,
    this.timezone,
  });

  DateTime date;
  int timezoneType;
  String timezone;

  factory AtedAt.fromJson(Map<String, dynamic> json) => AtedAt(
    date: DateTime.parse(json["date"]),
    timezoneType: json["timezone_type"],
    timezone: json["timezone"],
  );

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "timezone_type": timezoneType,
    "timezone": timezone,
  };
}
