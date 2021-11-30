// To parse this JSON data, do
//
//     final comments = commentsFromJson(jsonString);

import 'dart:convert';

Comments commentsFromJson(String str) => Comments.fromJson(json.decode(str));

String commentsToJson(Comments data) => json.encode(data.toJson());

class Comments {
  Comments({
    this.comdata,
  });

  List<Comdatum> comdata;

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
    comdata: List<Comdatum>.from(json["comdata"].map((x) => Comdatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "comdata": List<dynamic>.from(comdata.map((x) => x.toJson())),
  };
}

class Comdatum {
  Comdatum({
    this.id,
    this.userId,
    this.username,
    this.userphoto,
    this.productId,
    this.text,
    this.createdAt,
    this.updatedAt,
    this.replies,
  });

  int id;
  int userId;
  String username;
  String userphoto;
  int productId;
  String text;
  String createdAt;
  String updatedAt;
  List<Comdatum> replies;

  factory Comdatum.fromJson(Map<String, dynamic> json) => Comdatum(
    id: json["id"],
    userId: json["user_id"],
    username: json["username"],
    userphoto: json["userphoto"],
    productId: json["product_id"] == null ? null : json["product_id"],
    text: json["text"],
    createdAt: json["created_at"]["date"],
    updatedAt: json["updated_at"]["date"],
    replies: json["replies"] == null ? null : List<Comdatum>.from(json["replies"].map((x) => Comdatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "username": username,
    "userphoto": userphoto,
    "product_id": productId == null ? null : productId,
    "text": text,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "replies": replies == null ? null : List<dynamic>.from(replies.map((x) => x.toJson())),
  };
}

class AtedAt {
  AtedAt({
    this.date,
    this.timezoneType,
    this.timezone,
  });

  DateTime date;
  int timezoneType;
  String timezone;

  factory AtedAt.fromJson(Map<String, dynamic> json) => AtedAt(
    date: DateTime.parse(json["date"]),
    timezoneType: json["timezone_type"],
    timezone: json["timezone"],
  );

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "timezone_type": timezoneType,
    "timezone": timezone,
  };
}
