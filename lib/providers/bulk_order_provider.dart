import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/bulk_order_model.dart';
import 'package:mukto_mart/repo/bulk_order_repo.dart';

class BulkOrderProvider extends ChangeNotifier{
  BulkOrderRepo _bulkOrderRepo=BulkOrderRepo();
  BulkOrders _bulkOrders;

  get bulkOrderRepo => _bulkOrderRepo;
  BulkOrders get bulkOrders => _bulkOrders;

  Future<void> fetch(String token)async {
    var result = await _bulkOrderRepo.getAllBulkOrders(token);
    _bulkOrders=result;
    notifyListeners();
  }
}