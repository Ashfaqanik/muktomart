import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/hot_products_model.dart';
import 'package:mukto_mart/repo/hot_products_repo.dart';

class HotProductsProvider extends ChangeNotifier{
  HotProductsRepo _hotProductsRepo=HotProductsRepo();
  HotProducts _hotProducts;
  HotProducts _hotProductsPage;
  List<HotProductsDatum> _hotList=[];

  get hotProductsRepo => _hotProductsRepo;
  HotProducts get hotProducts => _hotProducts;
  HotProducts get hotProductsPage => _hotProductsPage;
  List<HotProductsDatum> get hotList=>_hotList;

  Future<void> fetch(int page)async {
    var result = await _hotProductsRepo.getHotProducts(page);
    _hotProducts=result;
    notifyListeners();
  }
  Future<void> fetchList()async {
    _hotList.addAll(_hotProducts.data);
    print(_hotList.length);
    //notifyListeners();
  }
  Future<void> fetchPage(int page)async {
    var result = await _hotProductsRepo.getHotProducts(page);
    _hotProductsPage=result;
    _hotList.addAll(_hotProductsPage.data);
    print(_hotList.length);
    notifyListeners();
  }
}