import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/hot_products_model.dart';

class HotProductsRepo{
  Future<HotProducts> getHotProducts(int page)async{
    try{
      String url = "https://muktomart.com/api/product_list_hot/20?page=$page";

      var response = await http.get(Uri.parse(url));

      HotProducts hotProducts = hotProductsFromJson(response.body);
      return hotProducts;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}