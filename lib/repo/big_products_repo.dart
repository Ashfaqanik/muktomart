import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/big_products_model.dart';

class BigProductsRepo{
  Future<BigProducts> getBigProducts(int page)async{
    try{
      String url = "https://muktomart.com/api/product_list_big/20?page=$page";

      var response = await http.get(Uri.parse(url));

      BigProducts bigProducts = bigProductsFromJson(response.body);
      return bigProducts;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}