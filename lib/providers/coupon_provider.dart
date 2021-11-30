import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/coupon_model.dart';
import 'package:mukto_mart/repo/coupon_repo.dart';

class CouponProvider extends ChangeNotifier{
  CouponRepo _couponRepo=CouponRepo();
  Coupon _coupon=Coupon();

  get couponRepo => _couponRepo;
  Coupon get coupon => _coupon;

  Future<void> fetch(String token,String code,int amount)async {
    var result = await _couponRepo.getCouponData(token,code,amount);
    _coupon=result;

    notifyListeners();
  }
}