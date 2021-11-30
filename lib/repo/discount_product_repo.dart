import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/discount_products_model.dart';

class DiscountProductsRepo{
  Future<DiscountProducts> getDiscountProducts(int page)async{
    try{
      String url = "https://muktomart.com/api/product_list_discount/20?page=$page";

      var response = await http.get(Uri.parse(url));

      DiscountProducts discountProducts = discountProductsFromJson(response.body);
      return discountProducts;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}