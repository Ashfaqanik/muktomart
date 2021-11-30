import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/city_model.dart';
import 'package:mukto_mart/models/country_model.dart';
import 'package:mukto_mart/models/latest_products_model.dart';
import 'package:mukto_mart/models/shipping_data_model.dart';
import 'package:mukto_mart/models/state_model.dart';

class ShippingChargeRepo{
  Future<CountryList> getCountryList()async{
    try{
      String url = "https://muktomart.com/api/country_list";

      var response = await http.get(Uri.parse(url));

      CountryList countryList = countryListFromJson(response.body);
      return countryList;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<StateList> getStateList(dynamic country_id)async{
    try{
      String url = "https://muktomart.com/api/state_list/$country_id";

      var response = await http.get(Uri.parse(url));

      StateList stateList = stateListFromJson(response.body);
      return stateList;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
  Future<StateList> getStateList1()async{
    try{
      String url = "https://muktomart.com/api/state_list";

      var response = await http.get(Uri.parse(url));

      StateList stateList = stateListFromJson(response.body);
      return stateList;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<CityList> getCityList(dynamic state_id)async{
    try{
      String url = "https://muktomart.com/api/city_list/$state_id";

      var response = await http.get(Uri.parse(url));

      CityList cityList = cityListFromJson(response.body);
      return cityList;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<CityList> getCityList1()async{
    try{
      String url = "https://muktomart.com/api/city_list";

      var response = await http.get(Uri.parse(url));

      CityList cityList = cityListFromJson(response.body);
      return cityList;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<ShippingDataModel> getShippingCharge(dynamic cartPrice,dynamic districtId)async{
    try{
      String url = "https://muktomart.com/api/sipping_cost/$cartPrice/$districtId";

      var response = await http.get(Uri.parse(url));

      ShippingDataModel shippingDataModel = shippingDataModelFromJson(response.body);
      return shippingDataModel;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}