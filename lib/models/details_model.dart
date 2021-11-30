// To parse this JSON data, do
//
//     final productDetails = productDetailsFromJson(jsonString);

import 'dart:convert';

ProductDetails productDetailsFromJson(String str) => ProductDetails.fromJson(json.decode(str));

String productDetailsToJson(ProductDetails data) => json.encode(data.toJson());

class ProductDetails {
  ProductDetails({
    this.product,
    this.curr,
    this.vendors,
    this.rating,
    this.vendorEmail,
  });

  Product product;
  Curr curr;
  List<Vendor> vendors;
  String rating;
  String vendorEmail;

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
    product: Product.fromJson(json["product"]),
    curr: Curr.fromJson(json["curr"]),
    vendors: List<Vendor>.from(json["vendors"].map((x) => Vendor.fromJson(x))),
    rating: json["rating"],
    vendorEmail: json["vendor_email"],
  );

  Map<String, dynamic> toJson() => {
    "product": product.toJson(),
    "curr": curr.toJson(),
    "vendors": List<dynamic>.from(vendors.map((x) => x.toJson())),
    "rating": rating,
    "vendor_email": vendorEmail,
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

class Product {
  Product({
    this.category,
    this.subcategory,
    this.childcategory,
    this.name,
    this.slug,
    this.galleries,
    this.stock,
    this.price,
    this.previousPrice,
    this.percent,
    this.youtube,
    this.type,
    this.platform,
    this.region,
    this.licenceType,
    this.size,
    this.color,
    this.sku,
    this.details,
    this.policy,
    this.attributes,
    this.ratings,
    this.userId,
    this.comments,
  });

  String category;
  String subcategory;
  String childcategory;
  String name;
  String slug;
  List<Gallery> galleries;
  int stock;
  String price;
  String previousPrice;
  String percent;
  dynamic youtube;
  String type;
  dynamic platform;
  dynamic region;
  dynamic licenceType;
  Size size;
  List<dynamic> color;
  String sku;
  String details;
  String policy;
  dynamic attributes;
  List<dynamic> ratings;
  int userId;
  List<Comment> comments;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    category: json["category"],
    subcategory: json["subcategory"],
    childcategory: json["childcategory"],
    name: json["name"],
    slug: json["slug"],
    galleries: List<Gallery>.from(json["galleries"].map((x) => Gallery.fromJson(x))),
    stock: json["stock"],
    price: json["price"],
    previousPrice: json["previous_price"],
    percent: json["percent"],
    youtube: json["youtube"],
    type: json["type"],
    platform: json["platform"],
    region: json["region"],
    licenceType: json["licence_type"],
    size: Size.fromJson(json["size"]),
    color: List<dynamic>.from(json["color"].map((x) => x)),
    sku: json["sku"],
    details: json["details"],
    policy: json["policy"],
    attributes: json["attributes"],
    ratings: List<dynamic>.from(json["ratings"].map((x) => x)),
    userId: json["user_id"],
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "subcategory": subcategory,
    "childcategory": childcategory,
    "name": name,
    "slug": slug,
    "galleries": List<dynamic>.from(galleries.map((x) => x.toJson())),
    "stock": stock,
    "price": price,
    "previous_price": previousPrice,
    "percent": percent,
    "youtube": youtube,
    "type": type,
    "platform": platform,
    "region": region,
    "licence_type": licenceType,
    "size": size.toJson(),
    "color": List<dynamic>.from(color.map((x) => x)),
    "sku": sku,
    "details": details,
    "policy": policy,
    "attributes": attributes,
    "ratings": List<dynamic>.from(ratings.map((x) => x)),
    "user_id": userId,
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
  };
}

class Comment {
  Comment({
    this.id,
    this.userId,
    this.productId,
    this.text,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  int productId;
  String text;
  DateTime createdAt;
  DateTime updatedAt;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    userId: json["user_id"],
    productId: json["product_id"],
    text: json["text"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "product_id": productId,
    "text": text,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Gallery {
  Gallery({
    this.images,
  });

  String images;

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
    images: json["images"],
  );

  Map<String, dynamic> toJson() => {
    "images": images,
  };
}

class Size {
  Size();

  factory Size.fromJson(Map<String, dynamic> json) => Size(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Vendor {
  Vendor({
    this.id,
    this.name,
    this.photo,
    this.price,
    this.previousPrice,
    this.percent,
  });

  int id;
  String name;
  String photo;
  String price;
  dynamic previousPrice;
  String percent;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
    id: json["id"],
    name: json["name"],
    photo: json["photo"],
    price: json["price"],
    previousPrice: json["previous_price"],
    percent: json["percent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo": photo,
    "price": price,
    "previous_price": previousPrice,
    "percent": percent,
  };
}
