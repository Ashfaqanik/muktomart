import 'package:flutter/material.dart';

class LocalSearchModel{
  //int _id;
  String _name;
  String _timestamp;


  LocalSearchModel(
    //this._id,
    this._name,
    this._timestamp);

  //int get id => _id;
  String get name => _name;
  String get timestamp => _timestamp;


  set name(String newName){
    this._name = newName;
  }

  set timestamp(String newTimestamp){
    this._timestamp = newTimestamp;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    // if(id!=null){
    //   map['id']= _id;
    // }
    map['name'] = _name;
    map['timestamp'] = _timestamp;

    return map;
  }

  LocalSearchModel.fromMapObject(Map<String,dynamic> map){
    //this._id = map['id'];
    this._name = map['name'];
    this._timestamp = map['timestamp'];

  }
}