import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/latest_products_model.dart';

class LatestProductsRepo{
  Future<LatestProducts> getLatestProducts(int page)async{
    try{
      String url = "https://muktomart.com/api/product_list_latest/20?page=$page";

      var response = await http.get(Uri.parse(url));

      LatestProducts latestProducts = latestProductsFromJson(response.body);
      return latestProducts;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}