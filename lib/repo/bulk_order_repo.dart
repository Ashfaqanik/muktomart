import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/bulk_order_model.dart';
import 'package:path/path.dart';
class BulkOrderRepo{
  Future<BulkOrders> getAllBulkOrders(String token)async{
    try{
      String url = "https://muktomart.com/api/orderupload/$token";

      var response = await http.get(Uri.parse(url));

      BulkOrders bulkOrders = bulkOrdersFromJson(response.body);
      return bulkOrders;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<void> deleteBulkOrder(String token,int id) async {

    try{
      String addUrl = 'https://muktomart.com/api/orderupload/delete/$token/$id';

      var response = await http.get(Uri.parse(addUrl));

      if(response.statusCode==200)print('Order deleted');

    }catch(error){
      print(error.toString());
      return null;
    }
    return null;

  }

  Future<bool> uploadFile(File file,String token) async {
    String uploadUrl = 'https://muktomart.com/api/orderupload/$token';
    var result;
    var request;

    var uri = Uri.parse(uploadUrl);

    request = new http.MultipartRequest("POST", uri);
    request.files.add(
        http.MultipartFile(
            'order_file',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: basename(file.path)
        )
    );
    var stream =
    new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var multipartFile = new http.MultipartFile('order_file', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);

    var response = await request.send();
    await response.stream.transform(utf8.decoder).listen((value){
      result = value;
    });
    var jsonData= json.decode(result);
    print(jsonData);
    if(jsonData['status']=='SUCCESS'){
      print('Success');
      return Future.value(true);
    }else return Future.value(false);
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