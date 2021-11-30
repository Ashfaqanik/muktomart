// To parse this JSON data, do
//
//     final homeCategories = homeCategoriesFromJson(jsonString);

import 'dart:convert';

List<HomeCategories> homeCategoriesFromJson(String str) => List<HomeCategories>.from(json.decode(str).map((x) => HomeCategories.fromJson(x)));

String homeCategoriesToJson(List<HomeCategories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeCategories {
  HomeCategories({
    this.id,
    this.name,
    this.nameBn,
    this.slug,
    this.subcat,
    this.photo,
    this.image,
  });

  int id;
  String name;
  String nameBn;
  String slug;
  int subcat;
  String photo;
  String image;

  factory HomeCategories.fromJson(Map<String, dynamic> json) => HomeCategories(
    id: json["id"],
    name: json["name"],
    nameBn: json["name_bn"],
    slug: json["slug"],
    subcat: json["subcat"],
    photo: json["photo"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_bn": nameBn,
    "slug": slug,
    "subcat": subcat,
    "photo": photo,
    "image": image,
  };
}
