import 'dart:convert';

import 'package:http/http.dart';

class ReviewRepo{
  Future<Map<String, dynamic>> addReview(int product_id, String token,String review,int rating) async {
    String url = "https://muktomart.com/api/review_add/$token";
    var result;

    final Map<String, dynamic> data = {
      'rating': rating,
      'review': review,
      'product_id': product_id,
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
}