import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/feature_link_products.dart';
import 'package:mukto_mart/models/feature_links.dart';
import 'package:mukto_mart/models/featured_settings_model.dart';
import 'package:mukto_mart/models/product_list_feature1.dart';

// class FeaturedSettingsRepo{
//   Future<FeatureSettings> getFeaturedSettings()async{
//     try{
//       String url = "https://muktomart.com/api/feature_settings";
//
//       var response = await http.get(Uri.parse(url));
//
//       FeatureSettings featureSettings = featureSettingsFromJson(response.body);
//       return featureSettings;
//
//     }catch(error){
//       print(error.toString());
//       return null;
//     }
//   }
//
//   Future<ProductListFeature1> getProductListFeature1(int page)async{
//     try{
//       String url = "https://muktomart.com/api/product_list_feature_1/20?page=$page";
//
//       var response = await http.get(Uri.parse(url));
//
//       ProductListFeature1 productListFeature = productListFeature1FromJson(response.body);
//       return productListFeature;
//
//     }catch(error){
//       print(error.toString());
//       return null;
//     }
//   }
//   Future<ProductListFeature1> getProductListFeature2(int page)async{
//     try{
//       String url = "https://muktomart.com/api/product_list_feature_2/20?page=$page";
//
//       var response = await http.get(Uri.parse(url));
//
//       ProductListFeature1 productListFeature = productListFeature1FromJson(response.body);
//       return productListFeature;
//
//     }catch(error){
//       print(error.toString());
//       return null;
//     }
//   }
//   Future<ProductListFeature1> getProductListFeature3(int page)async{
//     try{
//       String url = "https://muktomart.com/api/product_list_feature_3/20?page=$page";
//
//       var response = await http.get(Uri.parse(url));
//
//       ProductListFeature1 productListFeature = productListFeature1FromJson(response.body);
//       return productListFeature;
//
//     }catch(error){
//       print(error.toString());
//       return null;
//     }
//   }
//   Future<ProductListFeature1> getProductListFeature4(int page)async{
//     try{
//       String url = "https://muktomart.com/api/product_list_feature_4/20?page=$page";
//
//       var response = await http.get(Uri.parse(url));
//
//       ProductListFeature1 productListFeature = productListFeature1FromJson(response.body);
//       return productListFeature;
//
//     }catch(error){
//       print(error.toString());
//       return null;
//     }
//   }
// }

class FeatureLinksRepo{
  Future<List<FeatureLinks>> getFeaturedLinks()async{
    try{
      String url = "https://muktomart.com/api/feature_links";

      var response = await http.get(Uri.parse(url));

      List<FeatureLinks> featureLinks = featureLinksFromJson(response.body);
      return featureLinks;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<FeatureLinkProducts> getFeatureLinkProducts(int page,int id)async{
    try{
      String url = "https://muktomart.com/api/feature_links_product/20?page=$page&id=$id";

      var response = await http.get(Uri.parse(url));

      FeatureLinkProducts featureLinkProducts = featureLinkProductsFromJson(response.body);
      return featureLinkProducts;

    }catch(error){
      print(error.toString());
      return null;
    }
  }
}