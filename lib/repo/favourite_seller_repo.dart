import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/favourite_seller_model.dart';

class FavouriteSellerRepo {
  String message;
  String removeMessage;
  List<Seller> sellers=[];
  List<int> sellersId=[];

  Future<void> addFavouriteSeller(String token, int vendorId) async {

    try{
      String addUrl = 'https://muktomart.com/api/favoriteadd/$token/$vendorId';

      var response = await http.get(Uri.parse(addUrl));
      var jsonData = await jsonDecode(response.body);

     if(response.statusCode==200){
       print('success');
     }
    }catch(error){
      print(error.toString());
      return null;
    }

  }


  Future<List<Seller>> getFavouriteSeller(String token)async{
    try{
      String url = "https://muktomart.com/api/favorites/$token";

      var response = await http.get(Uri.parse(url));
      var jsonData = await jsonDecode(response.body);

      for(var json in jsonData['seller']){
        Seller seller = Seller(
          id: json["id"],
          shopName: json["shop_name"],
          ownerName: json["owner_name"],
          shopAddress: json["shop_address"],
          vendorId: json["vendor_id"],
        );
        sellers.add(seller);
      }
      //print(wishes.length);
      return sellers;
    }catch(error){
      print(error.toString());
      return null;
    }
  }
  Future<List<int>> getSellerId(String token)async{
    try{
      String url = "https://muktomart.com/api/favorites/$token";

      var response = await http.get(Uri.parse(url));
      var jsonData = await jsonDecode(response.body);

      for(var json in jsonData['seller']){
        Seller seller = Seller(
          // id: json["id"],
          // shopName: json["shop_name"],
          // ownerName: json["owner_name"],
          // shopAddress: json["shop_address"],
          vendorId: json["vendor_id"],
        );
        sellersId.add(seller.vendorId);
      }
      //print(wishes.length);
      return sellersId;
    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<String> removeSeller(String token, int id) async {

    try{
      String removeUrl = 'https://muktomart.com/api/favoritedelete/$token/$id';

      var response = await http.get(Uri.parse(removeUrl));
      var jsonData = await jsonDecode(response.body);

      if(response.statusCode==200){
        print('removed');
      }
    }catch(error){
      print(error.toString());
      return null;
    }
  }

}
