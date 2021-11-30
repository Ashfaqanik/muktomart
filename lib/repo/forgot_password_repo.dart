import 'dart:convert';

import 'package:http/http.dart';

class ForgotPasswordRepo{
  static const String sendTokenUrl = 'https://muktomart.com/api/forgotpassword';


  Future<Map<String, dynamic>> sendToken(String phone) async {
    var result;

    final Map<String, dynamic> tokenData = {
      'phone': phone,
    };

    Response response = await post(
      Uri.parse(sendTokenUrl),
      body: json.encode(tokenData),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
        // 'X-ApiKey': 'ZGlzIzEyMw=='
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      result = {'status': true, 'message': 'Successful', 'user': tokenData};
    } else {

      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;
  }


  Future<Map<String, dynamic>> resetPass(String key,String newpass,String renewpass) async {
    String resetUrl = 'https://muktomart.com/api/forgotresetpassword/$key';
    var result;

    final Map<String, dynamic> resetData = {
      'newpass': newpass,
      'renewpass':renewpass
    };

    Response response = await post(
      Uri.parse(resetUrl),
      body: json.encode(resetData),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
        // 'X-ApiKey': 'ZGlzIzEyMw=='
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      result = {'status': true, 'message': 'Successful', 'user': resetData};
    } else {
      print(response.statusCode);
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;
  }

  Future<Map<String, dynamic>> changePass(String token,String currentPass,String newPass,String renewPass) async {
    String resetUrl = 'https://muktomart.com/api/resetpassword/$token';
    var result;

    final Map<String, dynamic> changeData = {
      'password':currentPass,
      'newpass': newPass,
      'renewpass':renewPass
    };

    Response response = await post(
      Uri.parse(resetUrl),
      body: json.encode(changeData),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
        // 'X-ApiKey': 'ZGlzIzEyMw=='
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      result = {'status': true, 'message': 'Successful', 'user': changeData};
    } else {
      print(response.statusCode);
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;
  }

  static onError(error) {
    print('the error is ${error.detail}');
    return {
      'status': false,
      'message': 'Unsuccessful Request',
      'data': error
    };
  }
}