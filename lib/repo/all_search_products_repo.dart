import 'dart:convert';

import 'package:mukto_mart/models/all_search_products_model.dart';
import 'package:http/http.dart' as http;

class AllSearchProductsRepo{
  //List<AllSearchProducts> alSearchProducts=[];
  Future<AllSearchProducts> getAllSearchProducts(String search)async{
    try{
      String url = "https://muktomart.com/api/all_products_search/$search";
      var response = await http.get(Uri.parse(url));

    AllSearchProducts allSearchProducts = allSearchProductsFromJson(response.body);
    print(response.statusCode);
      return allSearchProducts;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

//       var response = await http.get(Uri.parse(url));
//       var jsonData = await jsonDecode(response.body);
//
//       for(var json in jsonData['data']){
//         Datum allSearchProductsDatum = Datum(
//           id: json["id"],
//           name: json["name"],
//           categoryId: json["category_id"],
//           subcategoryId: json["subcategory_id"] == null ? null : json["subcategory_id"],
//           childcategoryId: json["childcategory_id"] == null ? null : json["childcategory_id"],
//           discountDateStart: json["discount_date_start"] == null ? null : json["discount_date_start"],
//           discountDate: json["discount_date"],
//           price: json["price"],
//           status: json["status"],
//           previousPrice: json["previous_price"],
//           percent: json["percent"],
//           thumbnail: json["thumbnail"],
//           rating: json["rating"],
//         );
//         alSearchProducts.add(allSearchProductsDatum);
//       }
//       return alSearchProducts;
//     }catch(error){
//       print(error.toString());
//       return null;
//     }
//   }
}