import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mukto_mart/providers/banner_provider.dart';
import 'package:mukto_mart/providers/categories_provider.dart';
import 'package:mukto_mart/providers/featured_settings_provider.dart';
import 'package:mukto_mart/providers/slider_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mukto_mart/screens/home/home_screen_page.dart';
import 'package:mukto_mart/screens/splash/update_version_screen.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:mukto_mart/providers/all_products_provider.dart';
import 'package:mukto_mart/providers/big_products_provider.dart';
import 'package:mukto_mart/providers/discount_products_provider.dart';
import 'package:mukto_mart/providers/featured_products_provider.dart';
import 'package:mukto_mart/providers/hot_products_provider.dart';
import 'package:mukto_mart/providers/latest_products_provider.dart';
import 'package:mukto_mart/providers/popular_products_provider.dart';
import 'package:mukto_mart/providers/sale_products_provider.dart';
import 'package:mukto_mart/providers/top_products_provider.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int count=0;
  String running_version;
  String update_version;

  void initState() {
    // TODO: implement initState
    super.initState();
    //_checkPreferences();
    final CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context,listen: false);
    final PopularProductsProvider popularProductsProvider = Provider.of<PopularProductsProvider>(context,listen: false);
    final TopProductsProvider topProductsProvider = Provider.of<TopProductsProvider>(context,listen: false);
    final LatestProductsProvider latestProductsProvider = Provider.of<LatestProductsProvider>(context,listen: false);
    final DiscountProductsProvider discountProductsProvider = Provider.of<DiscountProductsProvider>(context,listen: false);
    final FeaturedProductsProvider featuredProductsProvider = Provider.of<FeaturedProductsProvider>(context,listen: false);
    final HotProductsProvider hotProductsProvider = Provider.of<HotProductsProvider>(context,listen: false);
    final BigProductsProvider bigProductsProvider = Provider.of<BigProductsProvider>(context,listen: false);
    final SaleProductsProvider saleProductsProvider = Provider.of<SaleProductsProvider>(context,listen: false);
    final AllProductsProvider allProductsProvider = Provider.of<AllProductsProvider>(context,listen: false);
    final BannerProvider bannerProvider = Provider.of<BannerProvider>(context,listen: false);
    final SliderProvider sliderProvider = Provider.of<SliderProvider>(context,listen: false);
    final FeaturedSettingsProvider featuredSettingsProvider = Provider.of<FeaturedSettingsProvider>(context,listen: false);
    sliderProvider.fetchSliders();
    bannerProvider.fetch();
    allProductsProvider.fetch(1);
    featuredProductsProvider.fetch(1);
    hotProductsProvider.fetch(1);
    latestProductsProvider.fetch(1);
    discountProductsProvider.fetch(1);
    topProductsProvider.fetch(1);
    popularProductsProvider.fetch(1);
    categoriesProvider.fetchHomeCategory();
    categoriesProvider.fetchFirstSubCategories();
    bigProductsProvider.fetch(1);
    saleProductsProvider.fetch(1);
    featuredSettingsProvider.fetchLinks();
    // featuredSettingsProvider.fetch1(1);
    // featuredSettingsProvider.fetch2(1);
    // featuredSettingsProvider.fetch3(1);
    // featuredSettingsProvider.fetch4(1);
  }

  Future<void> _check()async{
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      running_version = packageInfo.version;
      print('running version = $running_version');
    });
    await FirebaseFirestore.instance.collection('UpdatedVersion')
        .doc('123456').get().then((snapshot){
        update_version=snapshot['versionNo'];
        print(update_version);
    });
    if(running_version!=update_version){
      Timer(
          Duration(seconds: 1),
              () =>
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
                    return UpdateScreenScreen(running_version: running_version);  }), (Route<dynamic> route) => false));
    }else{
      Timer(
          Duration(seconds: 1),
              () =>
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
                    return HomeScreenPage();  }), (Route<dynamic> route) => false));
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _check();
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/splash.png"),
                fit: BoxFit.fitWidth),
            borderRadius: BorderRadius.circular(5)),
      ),
      // SafeArea(
      //   child: SizedBox(
      //     width: double.infinity,
      //     child: Column(
      //       children: <Widget>[
      //         Expanded(
      //           flex: 3,
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: <Widget>[
      //               Spacer(),
      //
      //               // Text(
      //               //   "Mukto Mart",
      //               //   style: TextStyle(
      //               //     fontSize: getProportionateScreenWidth(36),
      //               //     color: Colors.white,
      //               //     fontWeight: FontWeight.bold,
      //               //   ),
      //               // ),
      //               // Text(
      //               //   text,
      //               //   style: TextStyle(color: Colors.grey[400]),
      //               //   textAlign: TextAlign.center,
      //               // ),
      //               Spacer(),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
