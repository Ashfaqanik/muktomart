import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/top_products_model.dart';

class TopProductsRepo{
  Future<TopProducts> getTopProducts(int page)async{
    try{
      String url = "https://muktomart.com/api/product_list_top/20?page=$page";

      var response = await http.get(Uri.parse(url));

      TopProducts topProducts = topProductsFromJson(response.body);
      return topProducts;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}