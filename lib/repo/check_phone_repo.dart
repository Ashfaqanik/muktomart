import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/all_products_model.dart';
import 'package:mukto_mart/models/chek_phone_model.dart';

class CheckPhoneRepo{

  int exist;

  Future<int> getPhone(String phone)async{
    try{
      String url = "https://muktomart.com/api/userphonecheck/$phone";

      var response = await http.get(Uri.parse(url));
      var jsonData = await jsonDecode(response.body);

        CheckPhone checkPhone = CheckPhone(
          exist: jsonData["exist"]
        );

           exist=checkPhone.exist;
    }catch(error){
      print(error.toString());
      return null;
    }
    print(exist);
    return exist;

  }
}