class Customers {
  Customers({
    this.user,
    this.token,
  });

  User user;
  String token;

  factory Customers.fromJson(Map<String, dynamic> json) => Customers(
    user: User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "token": token,
  };
}

class User {
  User({
    this.name,
    this.phone,
    this.email,
    this.address,
    this.deviceToken,
    this.verificationLink,
    this.affilateCode,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String name;
  String phone;
  String email;
  String address;
  String deviceToken;
  String verificationLink;
  String affilateCode;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
    deviceToken: json["device_token"],
    verificationLink: json["verification_link"],
    affilateCode: json["affilate_code"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "email": email,
    "address": address,
    "device_token": deviceToken,
    "verification_link": verificationLink,
    "affilate_code": affilateCode,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
