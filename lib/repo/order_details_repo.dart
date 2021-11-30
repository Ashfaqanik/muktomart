import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/order_details_model.dart';
class OrderDetailsRepo{
  Future<OrderDetails> getOrderDetails(String token,int orderId)async{
    try{
      String url = "https://muktomart.com/api/order_details/$token?orderid=$orderId";

      var response = await http.get(Uri.parse(url));

      OrderDetails orderDetails = orderDetailsFromJson(response.body);
      return orderDetails;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}