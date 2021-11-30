import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/checkout_model.dart';
import 'package:mukto_mart/repo/check_out_repo.dart';

class CheckOutProvider extends ChangeNotifier{
  CheckOutRepo _checkOutRepo=CheckOutRepo();
  CheckOut _checkOut;

  get checkOutRepo => _checkOutRepo;
  CheckOut get checkOut => _checkOut;

  Future<void> fetch(String token)async {
    var result = await _checkOutRepo.getAllData(token);
    _checkOut=result;
    //print(_checkOut.products.length);
    notifyListeners();
  }
}