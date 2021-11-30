import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/popolar_products_model.dart';

class PopularProductsRepo{
  Future<PopularProducts> getPopularProducts(int page)async{
    try{
      String url = "https://muktomart.com/api/product_list_best/20?page=$page";

      var response = await http.get(Uri.parse(url));

      PopularProducts popularProducts = popularProductsFromJson(response.body);
      return popularProducts;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}