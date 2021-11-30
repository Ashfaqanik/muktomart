import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/sub_categories_model.dart';

class SubCategoryRepo{
  Future<List<SubCategories>> getSubCategories(int catId)async{
    try{
      String url = "https://muktomart.com/api/subcategorys/$catId";

      var response = await http.get(Uri.parse(url));

      List<SubCategories> categories = subCategoriesFromJson(response.body);
      return categories;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<List<SubCategories>> getFirstSubCategories()async {
    try {
      String url = "https://muktomart.com/api/subcategorys/4";

      var response = await http.get(Uri.parse(url));

      List<SubCategories> firstCategories = subCategoriesFromJson(
          response.body);
      return firstCategories;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}