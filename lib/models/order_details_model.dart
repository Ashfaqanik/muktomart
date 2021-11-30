// To parse this JSON data, do
//
//     final orderDetails = orderDetailsFromJson(jsonString);

import 'dart:convert';

OrderDetails orderDetailsFromJson(String str) => OrderDetails.fromJson(json.decode(str));

String orderDetailsToJson(OrderDetails data) => json.encode(data.toJson());

class OrderDetails {
  OrderDetails({
    this.orders,
    this.cart,
  });

  Orders orders;
  List<Cart> cart;

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
    orders: Orders.fromJson(json["orders"]),
    cart: List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orders": orders.toJson(),
    "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
  };
}

class Cart {
  Cart({
    this.id,
    this.image,
    this.name,
    this.itemPrice,
    this.price,
    this.qty,
    this.size,
    this.color,
  });

  int id;
  String image;
  String name;
  String itemPrice;
  dynamic price;
  int qty;
  String size;
  String color;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json["id"],
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
    "image": image,
    "name": name,
    "item_price": itemPrice,
    "price": price,
    "qty": qty,
    "size": size,
    "color": color,
  };
}

class Orders {
  Orders({
    this.id,
    this.userId,
    this.method,
    this.shipping,
    this.pickupLocation,
    this.totalQty,
    this.payAmount,
    this.txnid,
    this.chargeId,
    this.orderNumber,
    this.paymentStatus,
    this.customerEmail,
    this.customerName,
    this.customerCountry,
    this.customerPhone,
    this.customerAddress,
    this.customerCity,
    this.customerZip,
    this.shippingName,
    this.shippingCountry,
    this.shippingEmail,
    this.shippingPhone,
    this.shippingAddress,
    this.shippingCity,
    this.shippingZip,
    this.orderNote,
    this.couponCode,
    this.couponDiscount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.affilateUser,
    this.affilateCharge,
    this.currencySign,
    this.currencyValue,
    this.shippingCost,
    this.packingCost,
    this.tax,
    this.dp,
    this.payId,
    this.vendorShippingId,
    this.vendorPackingId,
    this.walletPrice,
    this.shippingTitle,
    this.packingTitle,
    this.customerState,
    this.shippingState,
  });

  int id;
  int userId;
  String method;
  String shipping;
  dynamic pickupLocation;
  String totalQty;
  dynamic payAmount;
  String txnid;
  dynamic chargeId;
  String orderNumber;
  String paymentStatus;
  String customerEmail;
  String customerName;
  String customerCountry;
  String customerPhone;
  String customerAddress;
  String customerCity;
  dynamic customerZip;
  dynamic shippingName;
  String shippingCountry;
  dynamic shippingEmail;
  dynamic shippingPhone;
  dynamic shippingAddress;
  dynamic shippingCity;
  dynamic shippingZip;
  dynamic orderNote;
  dynamic couponCode;
  dynamic couponDiscount;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic affilateUser;
  dynamic affilateCharge;
  String currencySign;
  int currencyValue;
  int shippingCost;
  int packingCost;
  int tax;
  int dp;
  dynamic payId;
  dynamic vendorShippingId;
  dynamic vendorPackingId;
  dynamic walletPrice;
  String shippingTitle;
  dynamic packingTitle;
  String customerState;
  dynamic shippingState;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
    id: json["id"],
    userId: json["user_id"],
    method: json["method"],
    shipping: json["shipping"],
    pickupLocation: json["pickup_location"],
    totalQty: json["totalQty"],
    payAmount: json["pay_amount"].toDouble(),
    txnid: json["txnid"],
    chargeId: json["charge_id"],
    orderNumber: json["order_number"],
    paymentStatus: json["payment_status"],
    customerEmail: json["customer_email"],
    customerName: json["customer_name"],
    customerCountry: json["customer_country"],
    customerPhone: json["customer_phone"],
    customerAddress: json["customer_address"],
    customerCity: json["customer_city"],
    customerZip: json["customer_zip"],
    shippingName: json["shipping_name"],
    shippingCountry: json["shipping_country"],
    shippingEmail: json["shipping_email"],
    shippingPhone: json["shipping_phone"],
    shippingAddress: json["shipping_address"],
    shippingCity: json["shipping_city"],
    shippingZip: json["shipping_zip"],
    orderNote: json["order_note"],
    couponCode: json["coupon_code"],
    couponDiscount: json["coupon_discount"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    affilateUser: json["affilate_user"],
    affilateCharge: json["affilate_charge"],
    currencySign: json["currency_sign"],
    currencyValue: json["currency_value"],
    shippingCost: json["shipping_cost"],
    packingCost: json["packing_cost"],
    tax: json["tax"],
    dp: json["dp"],
    payId: json["pay_id"],
    vendorShippingId: json["vendor_shipping_id"],
    vendorPackingId: json["vendor_packing_id"],
    walletPrice: json["wallet_price"],
    shippingTitle: json["shipping_title"],
    packingTitle: json["packing_title"],
    customerState: json["customer_state"],
    shippingState: json["shipping_state"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "method": method,
    "shipping": shipping,
    "pickup_location": pickupLocation,
    "totalQty": totalQty,
    "pay_amount": payAmount,
    "txnid": txnid,
    "charge_id": chargeId,
    "order_number": orderNumber,
    "payment_status": paymentStatus,
    "customer_email": customerEmail,
    "customer_name": customerName,
    "customer_country": customerCountry,
    "customer_phone": customerPhone,
    "customer_address": customerAddress,
    "customer_city": customerCity,
    "customer_zip": customerZip,
    "shipping_name": shippingName,
    "shipping_country": shippingCountry,
    "shipping_email": shippingEmail,
    "shipping_phone": shippingPhone,
    "shipping_address": shippingAddress,
    "shipping_city": shippingCity,
    "shipping_zip": shippingZip,
    "order_note": orderNote,
    "coupon_code": couponCode,
    "coupon_discount": couponDiscount,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "affilate_user": affilateUser,
    "affilate_charge": affilateCharge,
    "currency_sign": currencySign,
    "currency_value": currencyValue,
    "shipping_cost": shippingCost,
    "packing_cost": packingCost,
    "tax": tax,
    "dp": dp,
    "pay_id": payId,
    "vendor_shipping_id": vendorShippingId,
    "vendor_packing_id": vendorPackingId,
    "wallet_price": walletPrice,
    "shipping_title": shippingTitle,
    "packing_title": packingTitle,
    "customer_state": customerState,
    "shipping_state": shippingState,
  };
}
