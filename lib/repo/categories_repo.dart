import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/categories_model.dart';
import 'package:mukto_mart/models/home_categories_mode.dart';

class CategoryRepo{
  Future<List<Categories>> getCategories()async{
    try{
      String url = "https://muktomart.com/api/categorys";

      var response = await http.get(Uri.parse(url));

      List<Categories> categories = categoriesFromJson(response.body);
      return categories;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<List<HomeCategories>> getHomeCategories()async{
    try{
      String url = "https://muktomart.com/api/featuredcategorys";

      var response = await http.get(Uri.parse(url));

      List<HomeCategories> homeCategories = homeCategoriesFromJson(response.body);
      return homeCategories;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}