// To parse this JSON data, do
//
//     final stateList = stateListFromJson(jsonString);

import 'dart:convert';

StateList stateListFromJson(String str) => StateList.fromJson(json.decode(str));

String stateListToJson(StateList data) => json.encode(data.toJson());

class StateList {
  StateList({
    this.state,
  });

  List<States> state;

  factory StateList.fromJson(Map<String, dynamic> json) => StateList(
    state: List<States>.from(json["state"].map((x) => States.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "state": List<dynamic>.from(state.map((x) => x.toJson())),
  };
}

class States {
  States({
    this.id,
    this.countryId,
    this.diviName,
    this.diviNameBn,
    this.status,
  });

  int id;
  int countryId;
  String diviName;
  String diviNameBn;
  int status;

  factory States.fromJson(Map<String, dynamic> json) => States(
    id: json["id"],
    countryId: json["country_id"],
    diviName: json["divi_name"],
    diviNameBn: json["divi_name_bn"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "divi_name": diviName,
    "divi_name_bn": diviNameBn,
    "status": status,
  };
}
