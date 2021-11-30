import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/sale_products_model.dart';
import 'package:mukto_mart/repo/sale_products_repo.dart';


class SaleProductsProvider extends ChangeNotifier{
  SaleProductsRepo _saleProductsRepo=SaleProductsRepo();
  SaleProducts _saleProducts;
  SaleProducts _saleProductsPage;
  List<SaleProductsDatum> _saleList=[];

  get saleProductsRepo => _saleProductsRepo;
  SaleProducts get saleProducts => _saleProducts;
  SaleProducts get saleProductsPage => _saleProductsPage;
  List<SaleProductsDatum> get saleList=>_saleList;

  Future<void> fetch(int page)async {
    var result = await _saleProductsRepo.getSaleProducts(page);
    _saleProducts=result;
    notifyListeners();
  }
  Future<void> fetchList()async {
    saleList.addAll(_saleProducts.data);
    print(saleList.length);
    //notifyListeners();
  }
  Future<void> fetchPage(int page)async {
    var result = await _saleProductsRepo.getSaleProducts(page);
    _saleProductsPage=result;
    saleList.addAll(_saleProductsPage.data);
    print(saleList.length);
    notifyListeners();
  }
}