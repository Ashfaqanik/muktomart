import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/top_products_model.dart';
import 'package:mukto_mart/repo/top_products_repo.dart';

class TopProductsProvider extends ChangeNotifier{
  TopProductsRepo _topProductsRepo=TopProductsRepo();
  TopProducts _topProducts;
  TopProducts _topProductsPage;
  List<TopProductsDatum> _topList=[];

  get topProductsRepo => _topProductsRepo;
  TopProducts get topProducts => _topProducts;
  TopProducts get topProductsPage => _topProductsPage;
  List<TopProductsDatum> get topList=>_topList;

  Future<void> fetch(int page)async {
    var result = await _topProductsRepo.getTopProducts(page);
    _topProducts=result;
    notifyListeners();
  }
  Future<void> fetchList()async {
    _topList.addAll(_topProducts.data);
    print(_topList.length);
    //notifyListeners();
  }
  Future<void> fetchPage(int page)async {
    var result = await _topProductsRepo.getTopProducts(page);
    _topProductsPage=result;
    _topList.addAll(_topProductsPage.data);
    print(_topList.length);
    notifyListeners();
  }
}