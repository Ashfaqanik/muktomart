import 'dart:convert';

class AddWishListModel {
  AddWishListModel({
    this.msg,
  });

  String msg;

  factory AddWishListModel.fromJson(Map<String, dynamic> json) => AddWishListModel(
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
  };
}

GetWishList getWishListFromJson(String str) => GetWishList.fromJson(json.decode(str));

String getWishListToJson(GetWishList data) => json.encode(data.toJson());

class GetWishList {
  GetWishList({
    this.wishlist,
  });

  List<Wishlists> wishlist;

  factory GetWishList.fromJson(Map<String, dynamic> json) => GetWishList(
    wishlist: List<Wishlists>.from(json["wishlist"].map((x) => Wishlists.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "wishlist": List<dynamic>.from(wishlist.map((x) => x.toJson())),
  };
}

class Wishlists {
  Wishlists({
    this.id,
    this.productId,
    this.name,
    this.photo,
    this.price,
    this.previousPrice,
  });

  int id;
  int productId;
  String name;
  String photo;
  String price;
  String previousPrice;

  factory Wishlists.fromJson(Map<String, dynamic> json) => Wishlists(
    id: json["id"],
    productId: json["product_id"],
    name: json["name"],
    photo: json["photo"],
    price: json["price"],
    previousPrice: json["previous_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "name": name,
    "photo": photo,
    "price": price,
    "previous_price": previousPrice,
  };
}


