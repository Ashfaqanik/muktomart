import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/order_model.dart';
import 'package:mukto_mart/repo/order_repo.dart';

class OrderProvider extends ChangeNotifier{
  OrderRepo _orderRepo=OrderRepo();
  Orders _orders;

  get orderRepo => _orderRepo;
  Orders get orders => _orders;

  Future<void> fetch(String token)async {
    var result = await _orderRepo.getAllOrders(token);
    _orders=result;
    notifyListeners();
  }
}