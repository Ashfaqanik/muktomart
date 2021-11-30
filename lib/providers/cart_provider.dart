import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/cart_model.dart';
import 'package:mukto_mart/repo/cart_repo.dart';

class CartProvider extends ChangeNotifier{
  CartRepo _cartRepo=CartRepo();
  Carts _carts;

  get cartRepo => _cartRepo;
  Carts get carts => _carts;

  Future<void> fetch(String token)async {
    var result = await _cartRepo.getCartItems(token);
    _carts=result;
    notifyListeners();
  }
  // Future<void> fetchPrice(String token)async {
  //   dynamic result1=await _cartRepo.getTotalPrice(token);
  //   _totalPrice=result1;
  //   notifyListeners();
  // }
}