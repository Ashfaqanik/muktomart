import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/order_model.dart';
class OrderRepo{
  Future<Orders> getAllOrders(String token)async{
    try{
      String url = "https://muktomart.com/api/order/$token";

      var response = await http.get(Uri.parse(url));

      Orders orders = ordersFromJson(response.body);
      return orders;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}