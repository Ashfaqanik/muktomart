import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';

class UpdateProfileRepo {

  Future<Map<String, dynamic>> update(String name, String email,String phone,String address,String token) async {
    String updateProfileUrl = 'https://muktomart.com/api/profile/$token';
    var result;

    final Map<String, dynamic> updateData = {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      // 'state':'Chattagram',
      // 'city':'Chattogram'
    };

    Response response = await post(
      Uri.parse(updateProfileUrl),
      body: json.encode(updateData),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
        // 'X-ApiKey': 'ZGlzIzEyMw=='
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      result = {'status': true, 'message': 'Successful', 'user': updateData};
    } else {

      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;
  }

  Future<Map<String, dynamic>> updatePic(String imageFile,String token) async {
    String updatePicUrl = 'https://muktomart.com/api/profile/$token';
    var result;
    var request;

    // var uri = Uri.parse(updatePicUrl);
    //
    // request = new http.MultipartRequest("POST", uri);
    // request.files.add(
    //     http.MultipartFile(
    //         'user_image',
    //         imageFile.readAsBytes().asStream(),
    //         imageFile.lengthSync(),
    //         filename: basename(imageFile.path)
    //     )
    // );
    // var stream =
    // new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // var length = await imageFile.length();
    // var multipartFile = new http.MultipartFile('user_image', stream, length,
    //     filename: basename(imageFile.path));
    // request.files.add(multipartFile);
    // request.body.addAll({
    //   'photo': imageFile,
    // });
    // var response = await request.send();
    // await response.stream.transform(utf8.decoder).listen((value){
    //   result = value;
    // });
    // var jsonData= json.decode(result);
    // print(jsonData);
    // if(jsonData['status']=='SUCCESS'){
    //   print('Success');
    //   return Future.value(true);
    // }else return Future.value(false);

    final Map<String, String> updateData = {
      'photo': imageFile
    };
    Response response = await post(
      Uri.parse(updatePicUrl),
       body: json.encode(updateData),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
        // 'X-ApiKey': 'ZGlzIzEyMw=='
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      result = {'status': true, 'message': 'Successful', 'user': updateData};
      print(result);
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
}
