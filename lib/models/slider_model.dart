import 'dart:convert';

List<Sliders> slidersFromJson(String str) => List<Sliders>.from(json.decode(str).map((x) => Sliders.fromJson(x)));

String slidersToJson(List<Sliders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sliders {
  Sliders({
    this.id,
    this.titleText,
    this.detailsText,
    this.photo,
  });

  int id;
  dynamic titleText;
  dynamic detailsText;
  String photo;

  factory Sliders.fromJson(Map<String, dynamic> json) => Sliders(
    id: json["id"],
    titleText: json["title_text"],
    detailsText: json["details_text"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title_text": titleText,
    "details_text": detailsText,
    "photo": photo,
  };
}
