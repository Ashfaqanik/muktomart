import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/latest_products_model.dart';
import 'package:mukto_mart/repo/latest_product_repo.dart';

class LatestProductsProvider extends ChangeNotifier{
  LatestProductsRepo _latestProductsRepo=LatestProductsRepo();
  LatestProducts _latestProducts;
  LatestProducts _latestProductsPage;
  List<LatestProductsDatum> _latestList=[];

  get latestProductsRepo => _latestProductsRepo;
  LatestProducts get latestProducts => _latestProducts;
  LatestProducts get latestProductsPage => _latestProductsPage;
  List<LatestProductsDatum> get latestList=>_latestList;

  Future<void> fetch(int page)async {
    var result = await _latestProductsRepo.getLatestProducts(page);
    _latestProducts=result;
    notifyListeners();
  }
  Future<void> fetchList()async {
    _latestList.addAll(_latestProducts.data);
    print(_latestList.length);
    //notifyListeners();
  }
  Future<void> fetchPage(int page)async {
    var result = await _latestProductsRepo.getLatestProducts(page);
    _latestProductsPage=result;
    _latestList.addAll(_latestProductsPage.data);
    print(_latestList.length);
    notifyListeners();
  }
}