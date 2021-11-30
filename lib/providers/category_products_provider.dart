import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/category_products_model.dart';
import 'package:mukto_mart/repo/category_products_repo.dart';

class CategoryProductsProvider extends ChangeNotifier{
  CategoryProductsRepo _categoryProductsRepo=CategoryProductsRepo();
  CategoryProductsModel _categoryProductsModel;
  CategoryProductsModel _categoryProductsModelPage;
  List<CategoryProductsModelDatum> _categoryProductList=[];

  get categoryProductsRepo => _categoryProductsRepo;
  CategoryProductsModel get categoryProductsModel => _categoryProductsModel;
  List<CategoryProductsModelDatum> get categoryProductList=>_categoryProductList;

  Future<void> fetch(int cat,int subCat,int childCat,int page)async {
    var result = await _categoryProductsRepo.getCategoryProducts(cat,subCat,childCat,page);
    _categoryProductsModel=result;
    notifyListeners();
  }
  Future<void> fetchList()async {
    _categoryProductList.addAll(_categoryProductsModel.data);
    print(_categoryProductList.length);
    //notifyListeners();
  }
  Future<void> fetchPage(int cat,int subCat,int childCat,int page)async {
    var result = await _categoryProductsRepo.getCategoryProducts(cat,subCat,childCat,page);
    _categoryProductsModelPage=result;
    _categoryProductList.addAll(_categoryProductsModelPage.data);
    print(_categoryProductList.length);
    notifyListeners();
  }
}