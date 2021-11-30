import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/big_products_model.dart';
import 'package:mukto_mart/repo/big_products_repo.dart';

class BigProductsProvider extends ChangeNotifier{
  BigProductsRepo _bigProductsRepo=BigProductsRepo();
  BigProducts _bigProducts;
  BigProducts _bigProductsPage;
  List<BigProductsDatum> _list=[];

  get bigProductsRepo => _bigProductsRepo;
  BigProducts get bigProducts => _bigProducts;
  BigProducts get bigProductsPage => _bigProductsPage;
  List<BigProductsDatum> get list=>_list;

  Future<void> fetch(int page)async {
    var result = await _bigProductsRepo.getBigProducts(page);
    _bigProducts=result;
    notifyListeners();
  }
  Future<void> fetchList()async {
    _list.addAll(_bigProducts.data);
    print(list.length);
    //notifyListeners();
  }
  Future<void> fetchPage(int page)async {
    var result = await _bigProductsRepo.getBigProducts(page);
    _bigProductsPage=result;
    _list.addAll(_bigProductsPage.data);
    notifyListeners();
  }
}