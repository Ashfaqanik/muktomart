import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/popolar_products_model.dart';
import 'package:mukto_mart/repo/popular_products_repo.dart';

class PopularProductsProvider extends ChangeNotifier{
  PopularProductsRepo _popularProductsRepo=PopularProductsRepo();
  PopularProducts _popularProducts;
  PopularProducts _popularProductsPage;
  List<PopularProductsDatum> _popularList=[];

  get popularProductsRepo => _popularProductsRepo;
  PopularProducts get popularProducts => _popularProducts;
  PopularProducts get popularProductsPage => _popularProductsPage;
  List<PopularProductsDatum> get popularList=>_popularList;

  Future<void> fetch(int page)async {
    var result = await _popularProductsRepo.getPopularProducts(page);
    _popularProducts=result;
    print(_popularProducts.data.length);
    notifyListeners();
  }
  Future<void> fetchList()async {
    _popularList.addAll(_popularProducts.data);
    print(_popularList.length);
    //notifyListeners();
  }
  Future<void> fetchPage(int page)async {
    var result = await _popularProductsRepo.getPopularProducts(page);
    _popularProductsPage=result;
    _popularList.addAll(_popularProductsPage.data);
    print(_popularList.length);
    notifyListeners();
  }
}