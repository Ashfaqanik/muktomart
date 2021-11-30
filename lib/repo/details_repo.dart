import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/details_model.dart';

class DetailsRepo{
  Future<ProductDetails> getProductDetails(int productId)async{
    try{
      String url = "https://muktomart.com/api/product_detail/$productId";

      var response = await http.get(Uri.parse(url));

      ProductDetails productDetails = productDetailsFromJson(response.body);
      print(productDetails.product.galleries[0].images);
      return productDetails;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}