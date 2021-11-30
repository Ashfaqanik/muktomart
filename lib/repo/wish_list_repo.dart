import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/wish_list_model.dart';

class WishListRepo {
  String message;
  String removeMessage;
  List<Wishlists> wishes=[];
  List<int> wishesId=[];

  Future<String> addWishList(String token, int productId) async {

    try{
      String addUrl = 'https://muktomart.com/api/addwish/$token/$productId';

      var response = await http.get(Uri.parse(addUrl));
      var jsonData = await jsonDecode(response.body);

      AddWishListModel addWishListModel = AddWishListModel(
          msg: jsonData["msg"]
      );

      message=addWishListModel.msg;
    }catch(error){
      print(error.toString());
      return null;
    }
    //print(message);
    return message;

  }


  Future<GetWishList> getWishLists(String token)async{
      try{
        String url = "https://muktomart.com/api/wishlists/$token";

        var response = await http.get(Uri.parse(url));

        GetWishList getWishList = getWishListFromJson(response.body);
        return getWishList;

      }catch(error){
        print(error.toString());
        return null;
      }
  }

  Future<List<int>> getWishListsId(String token)async{
    try{
      String url = "https://muktomart.com/api/wishlists/$token";

      var response = await http.get(Uri.parse(url));
      var jsonData = await jsonDecode(response.body);

      for(var json in jsonData['wishlist']){
        Wishlists wishlists = Wishlists(
          //id: json["id"],
          productId: json["product_id"],
          // name: json["name"],
          // photo: json["photo"],
          // price: json["price"],
          // previousPrice: json["previous_price"],
        );
        wishesId.add(wishlists.productId);
      }

      return wishesId;
    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<String> removeWish(String token, int id) async {

    try{
      String addUrl = 'https://muktomart.com/api/removewish/$token/$id';

      var response = await http.get(Uri.parse(addUrl));
      var jsonData = await jsonDecode(response.body);

      AddWishListModel removeWishModel = AddWishListModel(
          msg: jsonData["msg"]
      );

      removeMessage=removeWishModel.msg;
    }catch(error){
      print(error.toString());
      return null;
    }
    print(removeMessage);
    return removeMessage;

  }

}
