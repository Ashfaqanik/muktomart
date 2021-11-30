import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:mukto_mart/models/local_search_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper extends ChangeNotifier{

  List<LocalSearchModel> _searchList=[];
  List<String> _searches=[];
  get searchList=> _searchList;
  get searches=> _searches;

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String searchTable='cart_table';
  String colId = 'id';
  String colName = 'name';
  String colTimestamp = 'timestamp';

  DatabaseHelper._createInstance(); //Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  void _createDB(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $searchTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colName TEXT,$colTimestamp TEXT)');
  }

  Future<Database> initializeDatabase() async {
    //Get the directory path for both android and iOS
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'search.db';
    var cartDatabase =
    await openDatabase(path, version: 1, onCreate: _createDB);
    return cartDatabase;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  //Fetch Map list from DB
  Future<List<Map<String, dynamic>>> getSearchMapList() async {
    Database db = await this.database;
    var result = await db.query(searchTable, orderBy: '$colTimestamp ASC');
    return result;
  }
  //Get the 'Map List' and convert it to 'Cart List
  Future<void> getSearchList() async {
    _searchList.clear();
    var searchMapList = await getSearchMapList();
    int count = searchMapList.length;
    for (int i = 0; i < count; i++) {
      _searchList.add(LocalSearchModel.fromMapObject(searchMapList[i]));
      _searches.add(_searchList[i].name);
    }
    notifyListeners();
  }

  // //update operation
  // Future<int> updateSearch(LocalSearchModel searchModel) async {
  //   Database db = await this.database;
  //   var result = await db.update(searchTable, searchModel.toMap(),
  //       where: '$colId = ?', whereArgs: [searchModel.id]);
  //   await getSearchList();
  //   return result;
  // }

  //Insert operation
  Future<int> insertCart(LocalSearchModel searchModel) async {
    Database db = await this.database;
    var result = await db.insert(searchTable, searchModel.toMap());
    await getSearchList();
    return result;
  }

  // //Delete operation
  // Future<int> deleteSearch(String pId) async {
  //   Database db = await this.database;
  //   var result =
  //   await db.rawDelete('DELETE FROM $searchTable WHERE $colId = $pId');
  //   await getSearchList();
  //   return result;
  // }
  //
  // //Delete operation
  Future<int> deleteAllSearchList() async {
    Database db = await this.database;
    var result =
    await db.rawDelete('DELETE FROM $searchTable');
    await getSearchList();
    return result;
  }
}