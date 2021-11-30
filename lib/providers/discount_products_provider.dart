import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/discount_products_model.dart';
import 'package:mukto_mart/repo/discount_product_repo.dart';

class DiscountProductsProvider extends ChangeNotifier{
  DiscountProductsRepo _discountProductsRepo=DiscountProductsRepo();
  DiscountProducts _discountProducts;
  DiscountProducts _discountProductsPage;
  List<DiscountProductsDatum> _discountList=[];

  get discountProductsRepo => _discountProductsRepo;
  DiscountProducts get discountProducts => _discountProducts;
  DiscountProducts get discountProductsPage => _discountProductsPage;
  List<DiscountProductsDatum> get discountList=>_discountList;

  Future<void> fetch(int page)async {
    var result = await _discountProductsRepo.getDiscountProducts(page);
    _discountProducts=result;
    notifyListeners();
  }
  Future<void> fetchList()async {
    _discountList.addAll(_discountProducts.data);
    print(_discountList.length);
    //notifyListeners();
  }
  Future<void> fetchPage(int page)async {
    var result = await _discountProductsRepo.getDiscountProducts(page);
    _discountProductsPage=result;
    _discountList.addAll(_discountProductsPage.data);
    print(_discountList.length);
    notifyListeners();
  }
}