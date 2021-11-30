import 'dart:convert';
import 'package:mukto_mart/models/messages_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MessagesRepo{
  Future<Map<String, dynamic>> addMessage(String token,String email,String name,String subject,String message) async {
    String url = "https://muktomart.com/api/messageadd/$token";
    var result;

    final Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'subject': subject,
      'message': message
    };

    Response response = await post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
        // 'X-ApiKey': 'ZGlzIzEyMw=='
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);


      result = {'status': true, 'message': 'Successful', 'comment': data};
    } else {

      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;
  }

  Future<Messages> getAllMessages(String token)async{
    try{
      String url = "https://muktomart.com/api/messages/$token";

      var response = await http.get(Uri.parse(url));

      Messages messages = messagesFromJson(response.body);
      return messages;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> addConverdation(String token,int convId,String message,int sentUser) async {
    String url = "https://muktomart.com/api/postmessage/$token";
    var result;

    final Map<String, dynamic> data = {
      'conversation_id': convId,
      'message': message,
      'sent_user': sentUser,
    };

    Response response = await post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
        // 'X-ApiKey': 'ZGlzIzEyMw=='
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);


      result = {'status': true, 'message': 'Successful', 'comment': data};
    } else {

      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;
  }
  Future<void> deleteMessage(String token, int convId) async {

    try{
      String addUrl = 'https://muktomart.com/api/messagedelete/$token/$convId';

      var response = await http.get(Uri.parse(addUrl));
      if(response.statusCode==200){
        print('Success');
      }

    }catch(error){
      print(error.toString());
      return null;
    }
    //print(message);

  }

}