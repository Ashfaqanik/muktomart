// To parse this JSON data, do
//
//     final featureSettings = featureSettingsFromJson(jsonString);

import 'dart:convert';

FeatureSettings featureSettingsFromJson(String str) => FeatureSettings.fromJson(json.decode(str));

String featureSettingsToJson(FeatureSettings data) => json.encode(data.toJson());

class FeatureSettings {
  FeatureSettings({
    this.feature1,
    this.feature1Name,
    this.feature2,
    this.feature2Name,
    this.feature3,
    this.feature3Name,
    this.feature4,
    this.feature4Name,
  });

  int feature1;
  String feature1Name;
  int feature2;
  String feature2Name;
  int feature3;
  String feature3Name;
  int feature4;
  String feature4Name;

  factory FeatureSettings.fromJson(Map<String, dynamic> json) => FeatureSettings(
    feature1: json["feature_1"],
    feature1Name: json["feature_1_name"],
    feature2: json["feature_2"],
    feature2Name: json["feature_2_name"],
    feature3: json["feature_3"],
    feature3Name: json["feature_3_name"],
    feature4: json["feature_4"],
    feature4Name: json["feature_4_name"],
  );

  Map<String, dynamic> toJson() => {
    "feature_1": feature1,
    "feature_1_name": feature1Name,
    "feature_2": feature2,
    "feature_2_name": feature2Name,
    "feature_3": feature3,
    "feature_3_name": feature3Name,
    "feature_4": feature4,
    "feature_4_name": feature4Name,
  };
}
