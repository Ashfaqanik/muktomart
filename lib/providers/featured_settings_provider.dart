import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/feature_links.dart';
import 'package:mukto_mart/models/feature_link_products.dart';
import 'package:mukto_mart/repo/featured_settings_repo.dart';

class FeaturedSettingsProvider extends ChangeNotifier{
  FeatureLinksRepo _featureLinksRepo=FeatureLinksRepo();
  List<FeatureLinks> _featureLinks=[];
  FeatureLinkProducts _featureLinkProducts;
  List<Datum> _featureLinkProductList=[];
  // ProductListFeature1 _productListFeature1;
  // ProductListFeature1 _productListFeature2;
  // ProductListFeature1 _productListFeature3;
  // ProductListFeature1 _productListFeature4;
  // List<Datum1> _productList1=[];
  // List<Datum1> _productList2=[];
  // List<Datum1> _productList3=[];
  // List<Datum1> _productList4=[];

  get featureLinksRepo => _featureLinksRepo;
  FeatureLinkProducts get featureLinkProducts => _featureLinkProducts;
  List<FeatureLinks> get featureLinks => _featureLinks;
  List<Datum> get featureLinkProductList => _featureLinkProductList;
  // ProductListFeature1 get productListFeature1 => _productListFeature1;
  // ProductListFeature1 get productListFeature2 => _productListFeature2;
  // ProductListFeature1 get productListFeature3 => _productListFeature3;
  // ProductListFeature1 get productListFeature4 => _productListFeature4;
  // List<Datum1> get productList1 => _productList1;
  // List<Datum1> get productList2 => _productList2;
  // List<Datum1> get productList3 => _productList3;
  // List<Datum1> get productList4 => _productList4;


  // Future<void> fetch()async {
  //   var result = await _featuredSettingsRepo.getFeaturedSettings();
  //   _featureSettings=result;
  //   notifyListeners();
  // }
  //
  // Future<void> fetch1(int page)async {
  //   var result = await _featuredSettingsRepo.getProductListFeature1(page);
  //   _productListFeature1=result;
  //   notifyListeners();
  // }
  // Future<void> fetch1List()async {
  //   _productListFeature1!=null?_productListFeature1.data.isNotEmpty?_productList1.addAll(_productListFeature1.data):null:null;
  //   //print(_productList1.length);
  //   //notifyListeners();
  // }
  // Future<void> fetch1Page(int page)async {
  //   var result = await _featuredSettingsRepo.getProductListFeature1(page);
  //   _productListFeature1=result;
  //   _productListFeature1!=null?_productListFeature1.data.isNotEmpty?_productList1.addAll(_productListFeature1.data):null:null;
  //   print(_productList1.length);
  //   notifyListeners();
  // }


  // Future<void> fetch2(int page)async {
  //   var result = await _featuredSettingsRepo.getProductListFeature2(page);
  //   _productListFeature2=result;
  //   notifyListeners();
  // }
  // Future<void> fetch2List()async {
  //   _productListFeature2!=null?_productListFeature2.data.isNotEmpty?_productList2.addAll(_productListFeature2.data):null:null;
  //   print(_productList2.length);
  //   //notifyListeners();
  // }
  // Future<void> fetch2Page(int page)async {
  //   var result = await _featuredSettingsRepo.getProductListFeature2(page);
  //   _productListFeature2 = result;
  //   _productListFeature2!=null?_productListFeature2.data.isNotEmpty?_productList2.addAll(_productListFeature2.data):null:null;
  //   print(_productList2.length);
  //   notifyListeners();
  // }
  //
  //
  // Future<void> fetch3(int page)async {
  //   var result = await _featuredSettingsRepo.getProductListFeature3(page);
  //   _productListFeature3=result;
  //   notifyListeners();
  // }
  // Future<void> fetch3List()async {
  //   _productListFeature3!=null?_productListFeature3.data.isNotEmpty?_productList3.addAll(_productListFeature3.data):null:null;
  // }
  // Future<void> fetch3Page(int page)async {
  //   var result = await _featuredSettingsRepo.getProductListFeature3(page);
  //   _productListFeature3 = result;
  //   _productListFeature3!=null?_productListFeature3.data.isNotEmpty?_productList3.addAll(_productListFeature3.data):null:null;
  //   print(_productList3.length);
  //   notifyListeners();
  // }
  //
  // Future<void> fetch4(int page)async {
  //   var result = await _featuredSettingsRepo.getProductListFeature4(page);
  //   _productListFeature4=result;
  //   notifyListeners();
  // }
  // Future<void> fetch4List()async {
  //   _productListFeature4!=null?_productListFeature4.data.isNotEmpty?_productList4.addAll(_productListFeature4.data):null:null;
  //   print(_productList4.length);
  //   //notifyListeners();
  // }
  // Future<void> fetch4Page(int page)async {
  //   var result = await _featuredSettingsRepo.getProductListFeature4(page);
  //   _productListFeature4 = result;
  //   _productListFeature4!=null?_productListFeature4.data.isNotEmpty?_productList4.addAll(_productListFeature4.data):null:null;
  //   print(_productList4.length);
  //   notifyListeners();
  // }


  Future<void> fetchLinks()async {
    var result = await _featureLinksRepo.getFeaturedLinks();
    _featureLinks=result;
    notifyListeners();
  }

  Future<void> fetchProducts(int page,int id)async {
    var result = await _featureLinksRepo.getFeatureLinkProducts(page,id);
    _featureLinkProducts=result;
    notifyListeners();
  }
  Future<void> fetch1List()async {
    _featureLinkProducts!=null?_featureLinkProducts.data.isNotEmpty?_featureLinkProductList.addAll(_featureLinkProducts.data):null:null;
    //print(_productList1.length);
    //notifyListeners();
  }
  Future<void> fetch1Page(int page,int id)async {
    var result = await _featureLinksRepo.getFeatureLinkProducts(page,id);
    _featureLinkProducts=result;
    _featureLinkProducts!=null?_featureLinkProducts.data.isNotEmpty?_featureLinkProductList.addAll(_featureLinkProducts.data):null:null;
    print(_featureLinkProductList.length);
    notifyListeners();
  }
}