import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/city_model.dart';
import 'package:mukto_mart/models/country_model.dart';
import 'package:mukto_mart/models/shipping_data_model.dart';
import 'package:mukto_mart/models/state_model.dart';
import 'package:mukto_mart/repo/shipping_charge_repo.dart';

class ShippingChargeProvider extends ChangeNotifier{
  ShippingChargeRepo _shippingChargeRepo=ShippingChargeRepo();
  CountryList _countryList;
  StateList _stateList;
  CityList _cityList;
  ShippingDataModel _shippingDataModel;

  get shippingChargeRepo => _shippingChargeRepo;
  CountryList get countryList => _countryList;
  StateList get stateList => _stateList;
  CityList get cityList => _cityList;
  ShippingDataModel get shippingDataModel => _shippingDataModel;

  Future<void> fetchCountries()async {
    var result = await _shippingChargeRepo.getCountryList();
    _countryList=result;

    notifyListeners();
  }

  Future<void> fetchStates1()async {

    var result = await _shippingChargeRepo.getStateList1();
    _stateList=result;

    notifyListeners();
  }
  Future<void> fetchCities1()async {
    var result = await _shippingChargeRepo.getCityList1();
    _cityList=result;
    notifyListeners();
  }
  Future<void> fetchStates(dynamic country_id)async {
    var result = await _shippingChargeRepo.getStateList(country_id);
    _stateList=result;
    notifyListeners();
  }
  Future<void> fetchCities(dynamic state_id)async {

    var result = await _shippingChargeRepo.getCityList(state_id);
    _cityList=result;
    notifyListeners();
  }

  Future<void> fetchShippingCharge(dynamic cartPrice,dynamic districtId)async {
    var result = await _shippingChargeRepo.getShippingCharge(cartPrice,districtId);
    _shippingDataModel=result;
    notifyListeners();
  }
}