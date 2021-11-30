import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/all_products_model.dart';
import 'package:mukto_mart/models/all_products_name_model.dart';
import 'package:mukto_mart/repo/all_products_repo.dart';

class AllProductsProvider extends ChangeNotifier{
  AllProductsRepo _allProductsRepo=AllProductsRepo();
  AllProducts _allProducts;
  AllProducts _allProductsPage;
  List<Product> _allProductList=[];
  List<Products> _allProductNameList=[];

  get allProductsRepo => _allProductsRepo;
  AllProducts get allProducts => _allProducts;
  AllProducts get allProductsPage => _allProductsPage;
  List<Product> get allProductList=>_allProductList;
  List<Products> get allProductNameList=>_allProductNameList;

  Future<void> fetch(int page)async {
    var result = await _allProductsRepo.getAllProducts(page);
    _allProducts=result;
    notifyListeners();
  }
  Future<void> fetchList()async {
    _allProductList.addAll(_allProducts.data);
    print(_allProductList.length);
    //notifyListeners();
  }
  Future<void> fetchPage(int page)async {
    var result = await _allProductsRepo.getAllProducts(page);
    _allProductsPage=result;
    _allProductList.addAll(_allProductsPage.data);
    print(_allProductList.length);
    notifyListeners();
  }

  Future<void> fetchProductsName()async {
    var result = await _allProductsRepo.getAllProductsName();
    _allProductNameList=result.products;
    print(_allProductNameList.length);
    notifyListeners();
  }
}