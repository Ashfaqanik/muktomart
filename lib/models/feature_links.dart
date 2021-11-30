// To parse this JSON data, do
//
//     final featureLinks = featureLinksFromJson(jsonString);

import 'dart:convert';

List<FeatureLinks> featureLinksFromJson(String str) => List<FeatureLinks>.from(json.decode(str).map((x) => FeatureLinks.fromJson(x)));

String featureLinksToJson(List<FeatureLinks> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeatureLinks {
  FeatureLinks({
    this.id,
    this.name,
    this.photo,
  });

  int id;
  String name;
  String photo;

  factory FeatureLinks.fromJson(Map<String, dynamic> json) => FeatureLinks(
    id: json["id"],
    name: json["name"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo": photo,
  };
}
