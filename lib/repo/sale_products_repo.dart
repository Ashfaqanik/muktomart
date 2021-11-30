import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/sale_products_model.dart';

class SaleProductsRepo{
  Future<SaleProducts> getSaleProducts(int page)async{
    try{
      String url = "https://muktomart.com/api/product_list_sale/20?page=$page";

      var response = await http.get(Uri.parse(url));

      SaleProducts saleProducts = saleProductsFromJson(response.body);
      return saleProducts;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}