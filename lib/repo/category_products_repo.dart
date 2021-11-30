import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/category_products_model.dart';

class CategoryProductsRepo{

  Future<CategoryProductsModel> getCategoryProducts(int cat,int subCat,int childCat,int page)async{
    try{
      String url = "https://muktomart.com/api/category_product/50?page=$page&cat=$cat&subcat=$subCat&childcat=$childCat&sort=(date_desc)";

      var response = await http.get(Uri.parse(url));

      CategoryProductsModel categoryProductsModel = categoryProductsModelFromJson(response.body);
      return categoryProductsModel;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}