class Customers {
  Customers({
    this.seller,
  });

  List<Seller> seller;

  factory Customers.fromJson(Map<String, dynamic> json) => Customers(
    seller: List<Seller>.from(json["seller"].map((x) => Seller.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "seller": List<dynamic>.from(seller.map((x) => x.toJson())),
  };
}

class Seller {
  Seller({
    this.id,
    this.shopName,
    this.ownerName,
    this.shopAddress,
    this.vendorId,
  });

  int id;
  dynamic shopName;
  dynamic ownerName;
  dynamic shopAddress;
  int vendorId;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    id: json["id"],
    shopName: json["shop_name"],
    ownerName: json["owner_name"],
    shopAddress: json["shop_address"],
    vendorId: json["vendor_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "shop_name": shopName,
    "owner_name": ownerName,
    "shop_address": shopAddress,
    "vendor_id": vendorId,
  };
}
