import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/order_details_model.dart';
import 'package:mukto_mart/repo/order_details_repo.dart';

class OrderDetailsProvider extends ChangeNotifier{
  OrderDetailsRepo _orderDetailsRepo=OrderDetailsRepo();
  OrderDetails _orderDetails;

  get orderDetailsRepo => _orderDetailsRepo;
  OrderDetails get orderDetails => _orderDetails;

  Future<void> fetch(String token,int orderId)async {
    var result = await _orderDetailsRepo.getOrderDetails(token,orderId);
    _orderDetails=result;

    notifyListeners();
  }
}