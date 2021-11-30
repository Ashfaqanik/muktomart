import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/sub_sub_categories_model.dart';

class SubSubCategoryRepo{
  Future<List<SubSubCategories>> getSubSubCategories()async{
    try{
      String url = "https://muktomart.com/api/childcategorys";

      var response = await http.get(Uri.parse(url));

      List<SubSubCategories> subSubCategories = subSubCategoriesFromJson(response.body);
      return subSubCategories;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
  Future<List<SubSubCategories>> getSubSubCategoriesId(int id)async{
    try{
      String url = "https://muktomart.com/api/childcategorys/$id";

      var response = await http.get(Uri.parse(url));

      List<SubSubCategories> subSubCategoriesId = subSubCategoriesFromJson(response.body);
      return subSubCategoriesId;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}