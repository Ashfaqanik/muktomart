// To parse this JSON data, do
//
//     final subSubCategories = subSubCategoriesFromJson(jsonString);

import 'dart:convert';

List<SubSubCategories> subSubCategoriesFromJson(String str) => List<SubSubCategories>.from(json.decode(str).map((x) => SubSubCategories.fromJson(x)));

String subSubCategoriesToJson(List<SubSubCategories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubSubCategories {
  SubSubCategories({
    this.id,
    this.name,
    this.nameBn,
    this.slug,
    this.photo,
  });

  int id;
  String name;
  String nameBn;
  String slug;
  String photo;

  factory SubSubCategories.fromJson(Map<String, dynamic> json) => SubSubCategories(
    id: json["id"],
    name: json["name"],
    nameBn: json["name_bn"],
    slug: json["slug"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_bn": nameBn,
    "slug": slug,
    "photo": photo,
  };
}
