import 'package:mukto_mart/models/coupon_model.dart';
import 'package:http/http.dart' as http;
class CouponRepo{
  Coupon coupon=Coupon();
  Future<Coupon> getCouponData(String token,String code,int amount)async{
    try{
      String url = "https://muktomart.com/api/coupon/$token?code=$code&total=$amount";

      var response = await http.get(Uri.parse(url));

      print(response.statusCode);

      Coupon coupon = couponFromJson(response.body);
      return coupon;

    }catch(error){
      print(error.toString());
      return null;
    }
  }



}