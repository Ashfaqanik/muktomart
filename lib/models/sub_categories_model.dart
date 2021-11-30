// To parse this JSON data, do
//
//     final subCategories = subCategoriesFromJson(jsonString);

import 'dart:convert';

List<SubCategories> subCategoriesFromJson(String str) => List<SubCategories>.from(json.decode(str).map((x) => SubCategories.fromJson(x)));

String subCategoriesToJson(List<SubCategories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubCategories {
  SubCategories({
    this.id,
    this.name,
    this.nameBn,
    this.slug,
    this.subcat,
    this.photo,
  });

  int id;
  String name;
  String nameBn;
  String slug;
  int subcat;
  String photo;

  factory SubCategories.fromJson(Map<String, dynamic> json) => SubCategories(
    id: json["id"],
    name: json["name"],
    nameBn: json["name_bn"],
    slug: json["slug"],
    subcat: json["subcat"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_bn": nameBn,
    "slug": slug,
    "subcat": subcat,
    "photo": photo,
  };
}
