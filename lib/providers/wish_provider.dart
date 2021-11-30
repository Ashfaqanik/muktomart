import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/wish_list_model.dart';
import 'package:mukto_mart/repo/wish_list_repo.dart';

class WishProvider extends ChangeNotifier{
  WishListRepo _wishListRepo=WishListRepo();
  GetWishList _wishlists;
  List<int> _Idlist=[];

  get wishListRepo => _wishListRepo;
  GetWishList get wishlists => _wishlists;
  List<int> get Idlist => _Idlist;

  Future<void> fetch(String token)async {
    var result = await _wishListRepo.getWishLists(token);
    _wishlists = result;
    notifyListeners();
  }
  Future<void> fetchId(String token)async {
    Idlist!=null?Idlist.clear():null;
    var result = await _wishListRepo.getWishListsId(token);
    _Idlist = result;
    //print(_Idlist.length);
    notifyListeners();
  }
}