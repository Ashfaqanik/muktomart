// To parse this JSON data, do
//
//     final banners = bannersFromJson(jsonString);

import 'dart:convert';

List<Banners> bannersFromJson(String str) => List<Banners>.from(json.decode(str).map((x) => Banners.fromJson(x)));

String bannersToJson(List<Banners> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Banners {
  Banners({
    this.cat,
    this.subCat,
    this.childCat,
    this.appFeature1,
    this.appFeature2,
    this.appFeature3,
    this.appFeature4,
    this.photo,
  });

  int cat;
  String subCat;
  String childCat;
  String appFeature1;
  String appFeature2;
  String appFeature3;
  String appFeature4;
  String photo;

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
    cat: json["cat"],
    subCat: json["sub_cat"],
    childCat: json["child_cat"],
    appFeature1: json["app_feature_1"],
    appFeature2: json["app_feature_2"],
    appFeature3: json["app_feature_3"],
    appFeature4: json["app_feature_4"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "cat": cat,
    "sub_cat": subCat,
    "child_cat": childCat,
    "app_feature_1": appFeature1,
    "app_feature_2": appFeature2,
    "app_feature_3": appFeature3,
    "app_feature_4": appFeature4,
    "photo": photo,
  };
}
