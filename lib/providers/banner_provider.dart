import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/banner_model.dart';
import 'package:mukto_mart/repo/banner_repo.dart';

class BannerProvider extends ChangeNotifier{
  BannerRepo _bannerRepo=BannerRepo();
  List<Banners> _list=[];

  get bannerRepo => _bannerRepo;
  List<Banners> get list => _list;

  Future<void> fetch()async {
    _list.clear();
    var result = await _bannerRepo.getBanners();
    _list.addAll(result);
    notifyListeners();
  }

}