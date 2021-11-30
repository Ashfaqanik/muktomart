import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/favourite_seller_model.dart';
import 'package:mukto_mart/repo/favourite_seller_repo.dart';

class FavouriteSellerProvider extends ChangeNotifier{
  FavouriteSellerRepo _favouriteSellerRepo=FavouriteSellerRepo();
  List<Seller> _list=[];
  List<int> _Idlist=[];

  get favouriteSellerRepo => _favouriteSellerRepo;
  List<Seller> get list => _list;
  List<int> get Idlist => _Idlist;

  Future<void> fetch(String token)async {
    _list!=null?_list.clear():null;
    var result = await _favouriteSellerRepo.getFavouriteSeller(token);
    _list = result;
    notifyListeners();
  }
  Future<void> fetchSellerId(String token)async {
    Idlist!=null?Idlist.clear():null;
    var result = await _favouriteSellerRepo.getSellerId(token);
    _Idlist = result;
    notifyListeners();
  }
}