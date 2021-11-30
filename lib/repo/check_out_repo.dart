import 'dart:convert';
import 'package:mukto_mart/models/checkout_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CheckOutRepo{
  // List<CheckOut> aldata=[];

  Future<CheckOut> getAllData(String token)async{
    try{
      String url = "https://muktomart.com/api/checkout/$token?coupon=";

      var response = await http.get(Uri.parse(url));

      CheckOut checkOut = checkOutFromJson(response.body);
      return checkOut;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> notifyPayment(String txnid, String status) async {
    String url = "https://muktomart.com/api/notify_payment";
    var result;

    final Map<String, dynamic> data = {
      'tran_id': txnid,
      'status': status
    };

    Response response = await post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
        // 'X-ApiKey': 'ZGlzIzEyMw=='
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);


      result = {'status': true, 'message': 'Successful', 'comment': data};
    } else {

      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;
  }

  Future<Map<String, dynamic>> submitCheckout(String token,int totalQty,dynamic total,String method,String shipping,String pickup_location,
      String email,String name,int shipping_cost,String shipping_title,int packing_cost,String packing_title,
      int tax,String phone,String address,String state,String shipping_state,String customer_country,String city,
      String zip,String shipping_email,String shipping_name,String shipping_phone,String shipping_address,
      String shipping_country,String shipping_city,String shipping_zip,String order_notes,String coupon_code,
      String coupon_discount,int dp,String txnid) async {
    String url = "https://muktomart.com/api/checkoutsubmit/$token";
    var result;

    final Map<String, dynamic> data = {
      'totalQty': totalQty,
      'total': total,
      'method': method,
      'shipping': shipping,
      'pickup_location': pickup_location,
      'email': email,
      'name': name,
      'shipping_cost': shipping_cost,
      'shipping_title': shipping_title,
      'packing_cost': packing_cost,
      'packing_title': packing_title,
      'tax': tax,
      'phone': phone,
      'address': address,
      'state': state,
      'shipping_state': shipping_state,
      'customer_country': customer_country,
      'city': city,
      'zip': zip,
      'shipping_email': shipping_email,
      'shipping_name': shipping_name,
      'shipping_phone': shipping_phone,
      'shipping_address': shipping_address,
      'shipping_country': shipping_country,
      'shipping_city': shipping_city,
      'shipping_zip': shipping_zip,
      'order_notes': order_notes,
      'coupon_code': null,
      'coupon_discount': null,
      'dp': dp,
      'vendor_shipping_id': 0,
      'Vendor_packing_id': 0,
      'wallet_price': 0,
      'affilate': 0,
      'coupon_id': null,
      'txnid': txnid,

    };

    Response response = await post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
        // 'X-ApiKey': 'ZGlzIzEyMw=='
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);



      result = {'status': true, 'message': 'Successful', 'data': data};
    } else {

      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;
  }
}