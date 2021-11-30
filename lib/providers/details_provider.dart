import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/details_model.dart';
import 'package:mukto_mart/repo/details_repo.dart';

class DetailsProvider extends ChangeNotifier{
  DetailsRepo _detailsRepo=DetailsRepo();
  ProductDetails _productDetails;
  int _backed=0;

  get detailsRepo => _detailsRepo;
  get backed => _backed;
  ProductDetails get productDetails => _productDetails;
  set backed(int val) {
    _backed = val;
    notifyListeners();
  }

  Future<void> fetch(int productId)async {
    var result = await _detailsRepo.getProductDetails(productId);
    _productDetails=result;
    notifyListeners();
  }


}