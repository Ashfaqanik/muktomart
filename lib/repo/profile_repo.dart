import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mukto_mart/models/profile_model.dart';

class ProfileRepo{
  Response responses;

  Future<Customers> getProfileData(String userId)async{
      try{
        String url = "https://muktomart.com/api/userinfo/$userId";

        var response = await http.get(Uri.parse(url));

        Customers customers = customersFromJson(response.body);
        return customers;

      }catch(error){
        print(error.toString());
        return null;
      }

  }

  Future<Customers> getProfileDataByPhone(String phone)async{
    try{
      String url = "https://muktomart.com/api/checkuserbymobile/$phone";

      var response = await http.get(Uri.parse(url));

      Customers customers = customersFromJson(response.body);
      return customers;

    }catch(error){
      print(error.toString());
      return null;
    }

  }
  Future<Customers> getProfileDataByEmail(String email)async{
    try{
      String url = "https://muktomart.com/api/checkuserbymobile/$email";

      var response = await http.get(Uri.parse(url));

      Customers customers = customersFromJson(response.body);
      return customers;

    }catch(error){
      print(error.toString());
      return null;
    }

  }

  Future<http.Response> getProfileResponseByEmail(String email)async{
    try{
      String url = "https://muktomart.com/api/checkuserbymobile/$email";

      var response = await http.get(Uri.parse(url));
      responses=response;
      return responses;

    }catch(error){
      print(error.toString());
      return null;
    }

  }
}