import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mukto_mart/models/banner_model.dart';
import 'package:mukto_mart/models/slider_model.dart';

class SliderRepo{
  List<Sliders> slidersList = [];
  Future<List<Sliders>> getSliderImages()async{
    try {
      String url = "https://muktomart.com/api/sliders";

      var response = await http.get(Uri.parse(url));
      List<Sliders> sliders = slidersFromJson(response.body);
      slidersList.addAll(sliders);
      return slidersList;
    }catch(error){
      print(error.toString());
      return null;
    }
  }

}