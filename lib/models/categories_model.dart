// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

List<Categories> categoriesFromJson(String str) => List<Categories>.from(json.decode(str).map((x) => Categories.fromJson(x)));

String categoriesToJson(List<Categories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Categories {
  Categories({
    this.id,
    this.name,
    this.nameBn,
    this.slug,
    this.isFeatured,
    this.subcat,
    this.photo,
    this.image,
  });

  int id;
  String name;
  String nameBn;
  String slug;
  int isFeatured;
  int subcat;
  String photo;
  String image;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
    id: json["id"],
    name: json["name"],
    nameBn: json["name_bn"],
    slug: json["slug"],
    isFeatured: json["is_featured"],
    subcat: json["subcat"],
    photo: json["photo"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_bn": nameBn,
    "slug": slug,
    "is_featured": isFeatured,
    "subcat": subcat,
    "photo": photo,
    "image": image,
  };
}
