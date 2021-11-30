import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/slider_model.dart';
import 'package:mukto_mart/repo/slider_repo.dart';

class SliderProvider extends ChangeNotifier{
  SliderRepo _sliderRepo=SliderRepo();
  List<Sliders> _slidersList = [];

  get sliderRepo => _sliderRepo;
  List<Sliders> get slidersList => _slidersList;

  Future<void> fetchSliders()async {
    _slidersList.clear();
    var result = await _sliderRepo.getSliderImages();
    _slidersList.addAll(result);
    notifyListeners();
  }

}