// To parse this JSON data, do
//
//     final countryList = countryListFromJson(jsonString);

import 'dart:convert';

CountryList countryListFromJson(String str) => CountryList.fromJson(json.decode(str));

String countryListToJson(CountryList data) => json.encode(data.toJson());

class CountryList {
  CountryList({
    this.country,
  });

  List<Country> country;

  factory CountryList.fromJson(Map<String, dynamic> json) => CountryList(
    country: List<Country>.from(json["country"].map((x) => Country.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "country": List<dynamic>.from(country.map((x) => x.toJson())),
  };
}

class Country {
  Country({
    this.id,
    this.countryCode,
    this.countryName,
    this.countryNameBn,
    this.status,
  });

  int id;
  String countryCode;
  String countryName;
  String countryNameBn;
  int status;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    countryCode: json["country_code"],
    countryName: json["country_name"],
    countryNameBn: json["country_name_bn"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_code": countryCode,
    "country_name": countryName,
    "country_name_bn": countryNameBn,
    "status": status,
  };
}
