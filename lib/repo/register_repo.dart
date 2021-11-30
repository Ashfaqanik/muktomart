import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterRepo{
  static const String registerUrl = 'https://muktomart.com/api/register';

  Future<Map<String, dynamic>> registerPhone(String name, String phone, String address,String password, String passwordConfirmation,String deviceToken) async {
    final Map<String, dynamic> apiBodyData = {
      'name': name,
      'email': null,
      'phone': phone,
      'address': address,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'device_token': deviceToken
    };

    return await post(
        Uri.parse(registerUrl),
        body: json.encode(apiBodyData),
        headers: {'Content-Type':'application/json'}
    ).then(onValue)
        .catchError(onError);
  }

  Future<Map<String, dynamic>> registerEmail(String name, String email, String address,String password, String passwordConfirmation,String deviceToken) async {
    final Map<String, dynamic> apiBodyData = {
      'name': name,
      'email': email,
      'phone': null,
      'address': address,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'device_token': deviceToken
    };

    return await post(
        Uri.parse(registerUrl),
        body: json.encode(apiBodyData),
        headers: {'Content-Type':'application/json'}
    ).then(onValue)
        .catchError(onError);
  }
   Future<FutureOr> onValue (Response response) async {
    var result ;

    final Map<String, dynamic> responseData = json.decode((response.body));

    print(response.statusCode);

    if(response.statusCode == 200 ){

      print(responseData['user']['id']);
      _Pref(responseData['user']['id'],responseData['token']);

      result = {
        'status':true,
        'message':'Successfully registered',
        'data':responseData
      };

    }else{
      result = {
        'status':false,
        'message':'Unsuccessful registration',
        'data':responseData
      };
      print(result);
    }
    return result;
  }

  static onError(error){
    print('the error is ${error.toString()}');
    return {
      'status':false,
      'message':'Unsuccessful Request',
      'data':error
    };
  }

  void _Pref(int id,String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('userId', '$id');
    pref.setString('api_token', token);
  }

}