import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/banner_model.dart';

class BannerRepo{
  List<Banners> banners=[];
  List<String> slidersList = [];
  Future<List<Banners>> getBanners()async{
    try{
      String url = "https://muktomart.com/api/feature_banner";

      var response = await http.get(Uri.parse(url));

      List<Banners> banners = bannersFromJson(response.body);
      return banners;

    }catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<List<String>> getBannerImages()async{
    try{
      String url = "https://muktomart.com/api/feature_banner";

      var response = await http.get(Uri.parse(url));
      var jsonData = await jsonDecode(response.body);

      for(var json in jsonData){
        Banners banner = Banners(
          cat: json["cat"],
          subCat: json["sub_cat"],
          childCat: json["child_cat"],
          appFeature1: json["app_feature_1"],
          appFeature2: json["app_feature_2"],
          appFeature3: json["app_feature_3"],
          appFeature4: json["app_feature_4"],
          photo: json["photo"],
        );
        slidersList.add(banner.photo);
      }
      return slidersList;
    }catch(error){
      print(error.toString());
      return null;
    }
  }

}