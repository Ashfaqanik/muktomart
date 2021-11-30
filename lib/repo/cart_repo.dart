import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/cart_model.dart';

class CartRepo {
  List<CartItem> items=[];
  dynamic totalPrice;

  Future<void> addToCart(String token, int productId) async {

    try{
      String addUrl = 'https://muktomart.com/api/addcart/$token?id=$productId&qty=1&size=&color=&size_qty=&size_price=&size_key=&keys=&values=&prices=';

      var response = await http.get(Uri.parse(addUrl));
      var jsonData = await jsonDecode(response.body);

      // print(response.statusCode);
      if(response.statusCode==200)print('product added to cart');
    }catch(error){
      print(error.toString());
      return null;
    }

  }


  Future<Carts> getCartItems(String token)async{
      try{
        String url = "https://muktomart.com/api/carts/$token";

        var response = await http.get(Uri.parse(url));

        Carts carts = cartsFromJson(response.body);
        return carts;

      }catch(error){
        print(error.toString());
        return null;
      }
  }

  // Future<dynamic> getTotalPrice(String token)async{
  //   try{
  //     String url = "https://muktomart.com/api/carts/$token";
  //
  //     var response = await http.get(Uri.parse(url));
  //     var jsonData = await jsonDecode(response.body);
  //
  //     Carts price = Carts(
  //       totalPrice: jsonData["totalPrice"],
  //       );
  //     totalPrice=price.totalPrice;
  //     return totalPrice;
  //   }catch(error){
  //     print(error.toString());
  //     return null;
  //   }
  // }

  Future<void> reduceByOne(String token,int id, String itemId) async {

    try{
      String addUrl = 'https://muktomart.com/api/reducebyone/$token?id=$id&itemid=$itemId&size_qty=&size_price=';

      var response = await http.get(Uri.parse(addUrl));
      var jsonData = await jsonDecode(response.body);

      if(response.statusCode==200)print('One item from cart');

    }catch(error){
      print(error.toString());
      return null;
    }
    return null;

  }

  Future<void> removeCart(String token,int id) async {

    try{
      String addUrl = 'https://muktomart.com/api/removecart/$token/$id';

      var response = await http.get(Uri.parse(addUrl));
      var jsonData = await jsonDecode(response.body);

      if(response.statusCode==200)print('product removed from cart');

    }catch(error){
      print(error.toString());
      return null;
    }
    return null;

  }

}
