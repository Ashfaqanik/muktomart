import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/components/all_product_card_home.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mukto_mart/providers/all_products_provider.dart';
import 'package:mukto_mart/providers/banner_provider.dart';
import 'package:mukto_mart/providers/big_products_provider.dart';
import 'package:mukto_mart/providers/cart_provider.dart';
import 'package:mukto_mart/providers/categories_provider.dart';
import 'package:mukto_mart/providers/discount_products_provider.dart';
import 'package:mukto_mart/providers/featured_products_provider.dart';
import 'package:mukto_mart/providers/featured_settings_provider.dart';
import 'package:mukto_mart/providers/hot_products_provider.dart';
import 'package:mukto_mart/providers/latest_products_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mukto_mart/providers/order_provider.dart';
import 'package:mukto_mart/providers/popular_products_provider.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/providers/sale_products_provider.dart';
import 'package:mukto_mart/providers/slider_provider.dart';
import 'package:mukto_mart/providers/top_products_provider.dart';
import 'package:mukto_mart/providers/wish_provider.dart';
import 'package:mukto_mart/screens/all_products/feature1_products_screen.dart';
import 'package:mukto_mart/screens/all_products/feature2_products_screen.dart';
import 'package:mukto_mart/screens/all_products/feature3_products_screen.dart';
import 'package:mukto_mart/screens/all_products/feature4_products_screen.dart';
import 'package:mukto_mart/screens/all_products/feature_link_products.dart';
import 'package:mukto_mart/screens/home/components/sale_products.dart';
import 'package:mukto_mart/screens/home/components/top_products.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'big_products.dart';
import 'discount_banner.dart';
import 'discount_products.dart';
import 'featured_products.dart';
import 'hot_products.dart';
import 'latest_products.dart';
import 'popular_product.dart';
import 'category_items.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  ScrollController controller;
  String userId;
  bool _isLoading=false;
  bool _isFeature=false;
  String token;
  int count=0;
  int page=2;
  Future<void> _fetchList(AllProductsProvider provider){
    provider.allProductList!=null?provider.allProductList.clear():null;
    provider.fetchList().then((value){
      setState(() {
        count++;
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
    final AllProductsProvider provider = Provider.of<AllProductsProvider>(context,listen: false);

    controller = ScrollController();
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange) {
        setState(() {
          _isLoading=true;
        });
        provider.fetchPage(page).then((value){
          setState(() {
            _isLoading=false;
            page++;
          });
        });
      }
    });
  }
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId');
      token = preferences.getString('api_token');
    });
  }
  void dispose(){
    // Don't forget to dispose the ScrollController.
    controller.dispose();
    super.dispose();
  }
  Future<void> _fetch()async{
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
    final FeaturedSettingsProvider featuredSettingsProvider = Provider.of<FeaturedSettingsProvider>(context,listen: false);
    await featuredSettingsProvider.fetchLinks();
    await categoriesProvider.fetchFirstSubCategories();
    await popularProductsProvider.fetch(1);
    await featuredProductsProvider.fetch(1);
    await hotProductsProvider.fetch(1);
    await latestProductsProvider.fetch(1);
    await discountProductsProvider.fetch(1);
    await topProductsProvider.fetch(1);
    await bigProductsProvider.fetch(1);
    await saleProductsProvider.fetch(1);
    await allProductsProvider.fetch(1);
    allProductsProvider.allProductList.clear();
    allProductsProvider.fetchList();
  }
  @override
  Widget build(BuildContext context) {
    final PopularProductsProvider popularProductsProvider =
    Provider.of<PopularProductsProvider>(context, listen: false);
    final LatestProductsProvider latestProductsProvider =
        Provider.of<LatestProductsProvider>(context, listen: false);
    final DiscountProductsProvider discountProductsProvider =
        Provider.of<DiscountProductsProvider>(context, listen: false);
    final TopProductsProvider topProductsProvider =
        Provider.of<TopProductsProvider>(context, listen: false);
    final FeaturedProductsProvider featuredProductsProvider =
        Provider.of<FeaturedProductsProvider>(context, listen: false);
    final HotProductsProvider hotProductsProvider =
        Provider.of<HotProductsProvider>(context, listen: false);
    final BigProductsProvider bigProductsProvider =
        Provider.of<BigProductsProvider>(context, listen: false);
    final SaleProductsProvider saleProductsProvider =
        Provider.of<SaleProductsProvider>(context, listen: false);
    final AllProductsProvider allProductsProvider =
        Provider.of<AllProductsProvider>(context, listen: false);
    final SliderProvider sliderProvider =
    Provider.of<SliderProvider>(context,listen: false);
    final FeaturedSettingsProvider featuredSettingsProvider =
    Provider.of<FeaturedSettingsProvider>(context,listen: false);

    if(count==0)_fetchList(allProductsProvider);

    if(featuredSettingsProvider.featureLinks!=null){
      if(featuredSettingsProvider.featureLinks.isNotEmpty){
        // if(featuredSettingsProvider.featureSettings.feature1==0&&featuredSettingsProvider.featureSettings.feature2==0&&
        //     featuredSettingsProvider.featureSettings.feature3==0&&featuredSettingsProvider.featureSettings.feature4==0){
        //   setState(() {
        //     _isFeature=true;
        //   });
        // }
        setState(() {
          _isFeature=true;
        });
      }
    }
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{
          return _fetch();
        },
        child: SafeArea(
          child: ListView(
            controller: controller,
            children: [
              SizedBox(height: getProportionateScreenWidth(10)),
              sliderProvider.slidersList != null ?sliderProvider.slidersList.isNotEmpty?DiscountBanner():Container():Container(),
              //Categories(),
              SizedBox(height: getProportionateScreenWidth(20)),
              _isFeature==false?Container():
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left:10.0,right: 10.0),
                  child: StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    physics: new ClampingScrollPhysics(),
                    itemCount: featuredSettingsProvider.featureLinks.length,
                    crossAxisCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      // if (demoProducts[index].isPopular)
                      return InkWell(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (_) {
                            return FeatureLinkProductsScreen(name: featuredSettingsProvider.featureLinks[index].name,id: featuredSettingsProvider.featureLinks[index].id,);  }));
                        },
                        child: Container(
                            padding: EdgeInsets.only(left:10.0,right: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blueGrey.shade100
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(left:5.0,right: 12,bottom: 5,top: 5),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: featuredSettingsProvider.featureLinks[index].photo,
                                      imageBuilder: (context, imageProvider) => Container(
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider, fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(width: 10),
                                    Text(featuredSettingsProvider.featureLinks[index].name??'',style: TextStyle(
                                        color: Colors.grey[800],fontWeight: FontWeight.bold
                                    ),),
                                  ],
                                )
                            )
                        ),
                      );
                      // return SizedBox
                      //     .shrink(); // here by default width and height is 0
                    },
                    staggeredTileBuilder: (int index) =>
                    new StaggeredTile.fit(1),
                    mainAxisSpacing: 6.0,
                    crossAxisSpacing: 15.0,

                  ),
                ),
              ),
              // Container(
              //   height: 40,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left:10.0,right: 10.0),
              //     child: ListView(
              //       shrinkWrap: true,
              //       scrollDirection: Axis.horizontal,
              //       children: [
              //         featuredSettingsProvider.featureSettings==null?Container():featuredSettingsProvider.featureSettings.feature1==1?
              //         InkWell(
              //           onTap: (){
              //             Navigator.push(context,MaterialPageRoute(builder: (_) {
              //               return Feature1ProductsScreen(name: featuredSettingsProvider.featureSettings.feature1Name,);  }));
              //           },
              //           child: Container(
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(10),
              //               color: Colors.green[100]
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.only(left:10.0,right: 10.0),
              //               child: Center(child: Text(featuredSettingsProvider.featureSettings.feature1Name??'',style: TextStyle(
              //                 color: Colors.grey[800],fontWeight: FontWeight.bold
              //               ),)),
              //             ),
              //           ),
              //         ):Container(),
              //         SizedBox(width: 6),
              //         featuredSettingsProvider.featureSettings==null?Container():featuredSettingsProvider.featureSettings.feature2==1?
              //         InkWell(
              //           onTap: (){
              //             Navigator.push(context,MaterialPageRoute(builder: (_) {
              //               return Feature2ProductsScreen(name: featuredSettingsProvider.featureSettings.feature2Name,);  }));
              //           },
              //           child: Container(
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10),
              //                 color: Colors.green[100]
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.only(left:10.0,right: 10.0),
              //               child: Center(child: Text(featuredSettingsProvider.featureSettings.feature2Name??'',style: TextStyle(
              //                   color: Colors.grey[800],fontWeight: FontWeight.bold
              //               ),)),
              //             ),
              //           ),
              //         ):Container(),
              //         SizedBox(width: 6),
              //         featuredSettingsProvider.featureSettings==null?Container():featuredSettingsProvider.featureSettings.feature3==1?
              //         InkWell(
              //           onTap: (){
              //             Navigator.push(context,MaterialPageRoute(builder: (_) {
              //               return Feature3ProductsScreen(name: featuredSettingsProvider.featureSettings.feature3Name,);  }));
              //           },
              //           child: Container(
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10),
              //                 color: Colors.green[100]
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.only(left:10.0,right: 10.0),
              //               child: Center(child: Text(featuredSettingsProvider.featureSettings.feature3Name??'',style: TextStyle(
              //                   color: Colors.grey[800],fontWeight: FontWeight.bold
              //               ),)),
              //             ),
              //           ),
              //         ):Container(),
              //         SizedBox(width: 6),
              //         featuredSettingsProvider.featureSettings==null?Container():featuredSettingsProvider.featureSettings.feature4==1?
              //         InkWell(
              //           onTap: (){
              //             Navigator.push(context,MaterialPageRoute(builder: (_) {
              //               return Feature4ProductsScreen(name: featuredSettingsProvider.featureSettings.feature4Name,);  }));
              //           },
              //           child: Container(
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10),
              //                 color: Colors.green[100]
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.only(left:10.0,right: 10.0),
              //               child: Center(child: Text(featuredSettingsProvider.featureSettings.feature4Name??'',style: TextStyle(
              //                   color: Colors.grey[800],fontWeight: FontWeight.bold
              //               ),)),
              //             ),
              //           ),
              //         ):Container(),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: getProportionateScreenWidth(10)),
              CategoryItems(),
              SizedBox(height: getProportionateScreenWidth(20)),
              popularProductsProvider.popularProducts != null ?popularProductsProvider.popularProducts.data != null ? popularProductsProvider.popularProducts.data.isNotEmpty ?PopularProducts()
                  :Container()
                  :Container()
                  :Container(),
              popularProductsProvider.popularProducts != null ?popularProductsProvider.popularProducts.data != null ? popularProductsProvider.popularProducts.data.isNotEmpty ?SizedBox(height: getProportionateScreenWidth(30))
                  :Container()
                  :Container()
                  :Container(),
              latestProductsProvider.latestProducts != null ?latestProductsProvider.latestProducts.data != null ? latestProductsProvider.latestProducts.data.isNotEmpty ? LatestProducts()
                  : Container()
                  : Container()
                  : Container(),
              latestProductsProvider.latestProducts != null ?latestProductsProvider.latestProducts.data != null ? latestProductsProvider.latestProducts.data.isNotEmpty ?SizedBox(height: getProportionateScreenWidth(30))
                  : Container()
                  : Container()
                  : Container(),
              discountProductsProvider.discountProducts != null ?discountProductsProvider.discountProducts.data != null ? discountProductsProvider.discountProducts.data.isNotEmpty ? DiscountProducts()
                  : Container()
                  : Container()
                  : Container(),
              discountProductsProvider.discountProducts != null ?discountProductsProvider.discountProducts.data != null ? discountProductsProvider.discountProducts.data.isNotEmpty ?SizedBox(height: getProportionateScreenWidth(30))
                  : Container()
                  : Container()
                  : Container(),
              topProductsProvider.topProducts != null ?topProductsProvider.topProducts.data != null ? topProductsProvider.topProducts.data.isNotEmpty ?TopProducts()
                  : Container()
                  : Container()
                  : Container(),
              topProductsProvider.topProducts != null ?topProductsProvider.topProducts.data != null ? topProductsProvider.topProducts.data.isNotEmpty ? SizedBox(height: getProportionateScreenWidth(30))
                  : Container()
                  : Container()
                  : Container(),
              featuredProductsProvider.featuredProducts != null ?featuredProductsProvider.featuredProducts.data != null ? featuredProductsProvider.featuredProducts.data.isNotEmpty ?FeaturedProducts()
                  : Container()
                  : Container()
                  : Container(),
              featuredProductsProvider.featuredProducts != null ?featuredProductsProvider.featuredProducts.data != null ? featuredProductsProvider.featuredProducts.data.isNotEmpty ? SizedBox(height: getProportionateScreenWidth(30))
                  : Container()
                  : Container()
                  : Container(),
              hotProductsProvider.hotProducts != null ?hotProductsProvider.hotProducts.data != null ? hotProductsProvider.hotProducts.data.isNotEmpty?HotProducts()
                  : Container()
                  : Container()
                  : Container(),
              hotProductsProvider.hotProducts != null ?hotProductsProvider.hotProducts.data != null ? hotProductsProvider.hotProducts.data.isNotEmpty? SizedBox(height: getProportionateScreenWidth(30))
                  : Container()
                  : Container()
                  : Container(),
              bigProductsProvider.bigProducts!= null ?bigProductsProvider.bigProducts.data != null ? bigProductsProvider.bigProducts.data.isNotEmpty? BigProducts()
                  : Container()
                  : Container()
                  : Container(),
              bigProductsProvider.bigProducts!= null ?bigProductsProvider.bigProducts.data != null ? bigProductsProvider.bigProducts.data.isNotEmpty? SizedBox(height: getProportionateScreenWidth(30))
                  : Container()
                  : Container()
                  : Container(),
              saleProductsProvider.saleProducts != null ?saleProductsProvider.saleProducts.data != null ? saleProductsProvider.saleProducts.data.isNotEmpty? SaleProducts()
                  : Container()
                  : Container()
                  : Container(),
              saleProductsProvider.saleProducts != null ?saleProductsProvider.saleProducts.data != null ? saleProductsProvider.saleProducts.data.isNotEmpty?SizedBox(height: getProportionateScreenWidth(30))
                  : Container()
                  : Container()
                  : Container(),
              // JustForYou(),
              // SizedBox(height: getProportionateScreenWidth(30)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "All Products",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(height: getProportionateScreenWidth(20)),
              allProductsProvider.allProducts != null ?allProductsProvider.allProducts.data != null ? allProductsProvider.allProducts.data.isNotEmpty?
              StaggeredGridView.countBuilder(
                shrinkWrap: true,
                physics: new ClampingScrollPhysics(),
                itemCount: allProductsProvider.allProductList.length,                crossAxisCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  // if (demoProducts[index].isPopular)
                  return AllProductCardHome(product: allProductsProvider.allProductList[index]);
                  // return SizedBox
                  //     .shrink(); // here by default width and height is 0
                },
                staggeredTileBuilder: (int index) =>
                new StaggeredTile.fit(1),
                mainAxisSpacing: 6.0,

              )
              // GridView.builder(
              //   shrinkWrap: true,
              //   physics: new ClampingScrollPhysics(),
              //   itemCount: allProductsProvider.allProductList.length,
              //   gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2, mainAxisSpacing: 6,childAspectRatio: 7.4/9),
              //   itemBuilder: (BuildContext context, int index) {
              //     return AllProductCardHome(product: allProductsProvider.allProductList[index]);
              //     // here by default width and height is 0
              //   },
              // )
              //AllProducts()
                  : Container()
                  : Container()
                  : Container(),
              _isLoading?CupertinoActivityIndicator():Container(),
              //SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        )
      ),
    );
  }
}
