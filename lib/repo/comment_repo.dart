import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mukto_mart/models/comment_model.dart';

class CommentsRepo{
  //List<Comdatum> alComments=[];

  Future<Comments> getAllComments(int productId)async{
    try{
      String url = "https://muktomart.com/api/comment/$productId";

      var response = await http.get(Uri.parse(url));

      Comments comments = commentsFromJson(response.body);
      return comments;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
  Future<Map<String, dynamic>> addComment(int product_id, String token,String text) async {
    String url = "https://muktomart.com/api/comment_add/$token";
    var result;

    final Map<String, dynamic> data = {
      'product_id': product_id,
      'text': text
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
    print(response.statusCode);

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

  Future<Map<String, dynamic>> replyComment(int comment_id, String token,String text) async {
    String replyUrl = "https://muktomart.com/api/reply_add/$token";
    var result;

    final Map<String, dynamic> data = {
      'comment_id': comment_id,
      'text': text
    };

    Response response = await post(
      Uri.parse(replyUrl),
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

  Future<Map<String, dynamic>> editComment(int comment_id, String token,String text) async {
    String editUrl = "https://muktomart.com/api/comment_edit/$token/$comment_id";
    var result;

    final Map<String, dynamic> data = {
      'text': text
    };

    Response response = await post(
      Uri.parse(editUrl),
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
  Future<Map<String, dynamic>> editReply(int reply_id, String token,String text) async {
    String editReplyUrl = "https://muktomart.com/api/reply_edit/$token/$reply_id";
    var result;

    final Map<String, dynamic> data = {
      'text': text
    };

    Response response = await post(
      Uri.parse(editReplyUrl),
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

  Future<void> deleteComment(String token, int commentId) async {

    try{
      String addUrl = 'https://muktomart.com/api/comment_delete/$token/$commentId';

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
  Future<void> deleteReply(String token, int replyId) async {

    try{
      String addUrl = 'https://muktomart.com/api/reply_delete/$token/$replyId';

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