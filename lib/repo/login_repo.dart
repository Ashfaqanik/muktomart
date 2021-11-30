import 'dart:convert';
import 'package:http/http.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepo {

  static const String loginUrl = 'https://muktomart.com/api/login';

  Future<Map<String, dynamic>> login(String phone, String password,ProfileProvider profileProvider) async {
      var result;

      final Map<String, dynamic> loginData = {
        'user': phone,
        'password': password
      };

      Response response = await post(
        Uri.parse(loginUrl),
        body: json.encode(loginData),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
          // 'X-ApiKey': 'ZGlzIzEyMw=='
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
        int userId=responseData['user_id'];
        print(responseData['user_id']);
        _Pref(responseData['user_id'],responseData['token']);
        profileProvider.fetch('$userId');

        result = {'status': true, 'message': 'Successful', 'user': loginData};
      } else {

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
  void _Pref(int id,String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('userId', '$id');
    pref.setString('api_token', token);
  }
}
