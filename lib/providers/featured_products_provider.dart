import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/featured_products_model.dart';
import 'package:mukto_mart/repo/featured_products_repo.dart';

class FeaturedProductsProvider extends ChangeNotifier{
  FeaturedProductsRepo _featuredProductsRepo=FeaturedProductsRepo();
  FeaturedProducts _featuredProducts;
  FeaturedProducts _featuredProductsPage;
  List<FeaturedProductsDatum> _featuredlist=[];

  get featuredProductsRepo => _featuredProductsRepo;
  FeaturedProducts get featuredProducts => _featuredProducts;
  FeaturedProducts get featuredProductsPage => _featuredProductsPage;
  List<FeaturedProductsDatum> get featuredlist=>_featuredlist;

  Future<void> fetch(int page)async {
    var result = await _featuredProductsRepo.getFeaturedProducts(page);
    _featuredProducts=result;
    notifyListeners();
  }
  Future<void> fetchList()async {
    _featuredlist.addAll(_featuredProducts.data);
    print(_featuredlist.length);
    //notifyListeners();
  }
  Future<void> fetchPage(int page)async {
    var result = await _featuredProductsRepo.getFeaturedProducts(page);
    _featuredProductsPage=result;
    _featuredlist.addAll(_featuredProductsPage.data);
    notifyListeners();
  }
}