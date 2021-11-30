import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/all_products_model.dart';
import 'package:mukto_mart/models/all_products_name_model.dart';

class AllProductsRepo{
  List<String> productsName=[];
  Future<AllProducts> getAllProducts(int page)async{
    try{
      String url = "https://muktomart.com/api/product_list/100?page=$page";

      var response = await http.get(Uri.parse(url));

      AllProducts allProducts = allProductsFromJson(response.body);
      return allProducts;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<AllProductsName> getAllProductsName()async{
    try{
      String url = "https://muktomart.com/api/product_list_all";

      var response = await http.get(Uri.parse(url));

      AllProductsName allProductsName = allProductsNameFromJson(response.body);
      return allProductsName;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  // Future<List<String>> getAllProductsName()async{
  //   try{
  //     String url = "https://muktomart.com/api/product_list_all";
  //
  //     var response = await http.get(Uri.parse(url));
  //     var jsonData = await jsonDecode(response.body);
  //
  //     for(var json in jsonData['products']){
  //       Products products = Products(
  //         name: json["name"],
  //       );
  //       productsName.add(products.name);
  //     }
  //
  //     return productsName;
  //
  //   }catch(error){
  //     print(error.toString());
  //     return null;
  //   }
  // }
}