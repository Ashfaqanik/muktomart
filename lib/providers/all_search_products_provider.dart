import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/all_search_products_model.dart';
import 'package:mukto_mart/repo/all_search_products_repo.dart';

class AllSearchProductsProvider extends ChangeNotifier{
  AllSearchProductsRepo _allSearchProductsRepo=AllSearchProductsRepo();
  //List<Datum> _allSearchProducts=[];
  AllSearchProducts _allSearchProducts=AllSearchProducts();

  get allSearchProductsRepo => _allSearchProductsRepo;
  AllSearchProducts get allSearchProducts => _allSearchProducts;

  Future<void> fetch(String search)async {
    var result = await _allSearchProductsRepo.getAllSearchProducts(search);
    _allSearchProducts=result;
    //print(_allSearchProducts.data.length);
    notifyListeners();
  }
}