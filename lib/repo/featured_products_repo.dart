import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/featured_products_model.dart';

class FeaturedProductsRepo{
  Future<FeaturedProducts> getFeaturedProducts(int page)async{
    try{
      String url = "https://muktomart.com/api/product_list_featured/20?page=$page";

      var response = await http.get(Uri.parse(url));

      FeaturedProducts featuredProducts = featuredProductsFromJson(response.body);
      return featuredProducts;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}