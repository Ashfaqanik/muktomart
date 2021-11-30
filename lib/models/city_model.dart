// To parse this JSON data, do
//
//     final cityList = cityListFromJson(jsonString);

import 'dart:convert';

CityList cityListFromJson(String str) => CityList.fromJson(json.decode(str));

String cityListToJson(CityList data) => json.encode(data.toJson());

class CityList {
  CityList({
    this.city,
  });

  List<City> city;

  factory CityList.fromJson(Map<String, dynamic> json) => CityList(
    city: List<City>.from(json["city"].map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "city": List<dynamic>.from(city.map((x) => x.toJson())),
  };
}

class City {
  City({
    this.id,
    this.divisionId,
    this.distName,
    this.distNameBn,
    this.status,
  });

  int id;
  int divisionId;
  String distName;
  String distNameBn;
  int status;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    divisionId: json["division_id"],
    distName: json["dist_name"],
    distNameBn: json["dist_name_bn"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "division_id": divisionId,
    "dist_name": distName,
    "dist_name_bn": distNameBn,
    "status": status,
  };
}
