import 'dart:convert';

Messages messagesFromJson(String str) => Messages.fromJson(json.decode(str));

String messagesToJson(Messages data) => json.encode(data.toJson());

class Messages {
  Messages({
    this.user,
    this.convs,
  });

  User user;
  List<Conv> convs;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
    user: User.fromJson(json["user"]),
    convs: List<Conv>.from(json["convs"].map((x) => Conv.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "convs": List<dynamic>.from(convs.map((x) => x.toJson())),
  };
}

class Conv {
  Conv({
    this.id,
    this.subject,
    this.sentUser,
    this.recievedUser,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.messages,
  });

  int id;
  String subject;
  int sentUser;
  int recievedUser;
  String message;
  AtedAt createdAt;
  AtedAt updatedAt;
  List<Message> messages;

  factory Conv.fromJson(Map<String, dynamic> json) => Conv(
    id: json["id"],
    subject: json["subject"],
    sentUser: json["sent_user"],
    recievedUser: json["recieved_user"],
    message: json["message"],
    createdAt: AtedAt.fromJson(json["created_at"]),
    updatedAt: AtedAt.fromJson(json["updated_at"]),
    messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subject": subject,
    "sent_user": sentUser,
    "recieved_user": recievedUser,
    "message": message,
    "created_at": createdAt.toJson(),
    "updated_at": updatedAt.toJson(),
    "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
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

class Message {
  Message({
    this.id,
    this.conversationId,
    this.message,
    this.sentUser,
    this.recievedUser,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int conversationId;
  String message;
  int sentUser;
  String recievedUser;
  AtedAt createdAt;
  AtedAt updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    conversationId: json["conversation_id"],
    message: json["message"],
    sentUser: json["sent_user"],
    recievedUser: json["recieved_user"],
    createdAt: AtedAt.fromJson(json["created_at"]),
    updatedAt: AtedAt.fromJson(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "conversation_id": conversationId,
    "message": message,
    "sent_user": sentUser,
    "recieved_user": recievedUser,
    "created_at": createdAt.toJson(),
    "updated_at": updatedAt.toJson(),
  };
}

class User {
  User({
    this.id,
    this.name,
    this.photo,
    this.zip,
    this.city,
    this.country,
    this.state,
    this.address,
    this.phone,
    this.email,
    this.fax,
    this.createdAt,
    this.updatedAt,
    this.isProvider,
    this.status,
    this.verificationLink,
    this.emailVerified,
    this.affilateCode,
    this.affilateIncome,
    this.shopName,
    this.ownerName,
    this.shopNumber,
    this.shopAddress,
    this.regNumber,
    this.shopMessage,
    this.shopDetails,
    this.shopImage,
    this.fUrl,
    this.gUrl,
    this.tUrl,
    this.lUrl,
    this.isVendor,
    this.fCheck,
    this.gCheck,
    this.tCheck,
    this.lCheck,
    this.mailSent,
    this.shippingCost,
    this.currentBalance,
    this.date,
    this.ban,
    this.balance,
    this.dob,
    this.areaId,
    this.shopCountryId,
    this.shopStateId,
    this.shopCityId,
    this.shopAreaId,
    this.vendorType,
    this.groupId,
    this.apiToken,
    this.deviceToken,
    this.resetToken,
    this.gender,
  });

  int id;
  String name;
  dynamic photo;
  dynamic zip;
  String city;
  String country;
  String state;
  String address;
  String phone;
  String email;
  dynamic fax;
  DateTime createdAt;
  DateTime updatedAt;
  int isProvider;
  int status;
  String verificationLink;
  String emailVerified;
  String affilateCode;
  int affilateIncome;
  dynamic shopName;
  dynamic ownerName;
  dynamic shopNumber;
  dynamic shopAddress;
  dynamic regNumber;
  dynamic shopMessage;
  dynamic shopDetails;
  dynamic shopImage;
  dynamic fUrl;
  dynamic gUrl;
  dynamic tUrl;
  dynamic lUrl;
  int isVendor;
  int fCheck;
  int gCheck;
  int tCheck;
  int lCheck;
  int mailSent;
  int shippingCost;
  int currentBalance;
  dynamic date;
  int ban;
  String balance;
  dynamic dob;
  dynamic areaId;
  dynamic shopCountryId;
  dynamic shopStateId;
  dynamic shopCityId;
  dynamic shopAreaId;
  int vendorType;
  int groupId;
  String apiToken;
  String deviceToken;
  String resetToken;
  dynamic gender;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    photo: json["photo"],
    zip: json["zip"],
    city: json["city"],
    country: json["country"],
    state: json["state"],
    address: json["address"],
    phone: json["phone"],
    email: json["email"],
    fax: json["fax"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isProvider: json["is_provider"],
    status: json["status"],
    verificationLink: json["verification_link"],
    emailVerified: json["email_verified"],
    affilateCode: json["affilate_code"],
    affilateIncome: json["affilate_income"],
    shopName: json["shop_name"],
    ownerName: json["owner_name"],
    shopNumber: json["shop_number"],
    shopAddress: json["shop_address"],
    regNumber: json["reg_number"],
    shopMessage: json["shop_message"],
    shopDetails: json["shop_details"],
    shopImage: json["shop_image"],
    fUrl: json["f_url"],
    gUrl: json["g_url"],
    tUrl: json["t_url"],
    lUrl: json["l_url"],
    isVendor: json["is_vendor"],
    fCheck: json["f_check"],
    gCheck: json["g_check"],
    tCheck: json["t_check"],
    lCheck: json["l_check"],
    mailSent: json["mail_sent"],
    shippingCost: json["shipping_cost"],
    currentBalance: json["current_balance"],
    date: json["date"],
    ban: json["ban"],
    balance: json["balance"],
    dob: json["dob"],
    areaId: json["area_id"],
    shopCountryId: json["shop_country_id"],
    shopStateId: json["shop_state_id"],
    shopCityId: json["shop_city_id"],
    shopAreaId: json["shop_area_id"],
    vendorType: json["vendor_type"],
    groupId: json["group_id"],
    apiToken: json["api_token"],
    deviceToken: json["device_token"],
    resetToken: json["reset_token"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo": photo,
    "zip": zip,
    "city": city,
    "country": country,
    "state": state,
    "address": address,
    "phone": phone,
    "email": email,
    "fax": fax,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "is_provider": isProvider,
    "status": status,
    "verification_link": verificationLink,
    "email_verified": emailVerified,
    "affilate_code": affilateCode,
    "affilate_income": affilateIncome,
    "shop_name": shopName,
    "owner_name": ownerName,
    "shop_number": shopNumber,
    "shop_address": shopAddress,
    "reg_number": regNumber,
    "shop_message": shopMessage,
    "shop_details": shopDetails,
    "shop_image": shopImage,
    "f_url": fUrl,
    "g_url": gUrl,
    "t_url": tUrl,
    "l_url": lUrl,
    "is_vendor": isVendor,
    "f_check": fCheck,
    "g_check": gCheck,
    "t_check": tCheck,
    "l_check": lCheck,
    "mail_sent": mailSent,
    "shipping_cost": shippingCost,
    "current_balance": currentBalance,
    "date": date,
    "ban": ban,
    "balance": balance,
    "dob": dob,
    "area_id": areaId,
    "shop_country_id": shopCountryId,
    "shop_state_id": shopStateId,
    "shop_city_id": shopCityId,
    "shop_area_id": shopAreaId,
    "vendor_type": vendorType,
    "group_id": groupId,
    "api_token": apiToken,
    "device_token": deviceToken,
    "reset_token": resetToken,
    "gender": gender,
  };
}
