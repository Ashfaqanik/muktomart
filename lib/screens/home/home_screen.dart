import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mukto_mart/providers/all_products_provider.dart';
import 'package:mukto_mart/providers/banner_provider.dart';
import 'package:mukto_mart/providers/big_products_provider.dart';
import 'package:mukto_mart/providers/bulk_order_provider.dart';
import 'package:mukto_mart/providers/cart_provider.dart';
import 'package:mukto_mart/providers/categories_provider.dart';
import 'package:mukto_mart/providers/coupon_provider.dart';
import 'package:mukto_mart/providers/details_provider.dart';
import 'package:mukto_mart/providers/discount_products_provider.dart';
import 'package:mukto_mart/providers/favourite_seller_provider.dart';
import 'package:mukto_mart/providers/featured_products_provider.dart';
import 'package:mukto_mart/providers/featured_settings_provider.dart';
import 'package:mukto_mart/providers/hot_products_provider.dart';
import 'package:mukto_mart/providers/latest_products_provider.dart';
import 'package:mukto_mart/providers/messages_provider.dart';
import 'package:mukto_mart/providers/order_provider.dart';
import 'package:mukto_mart/providers/popular_products_provider.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/providers/sale_products_provider.dart';
import 'package:mukto_mart/providers/slider_provider.dart';
import 'package:mukto_mart/providers/top_products_provider.dart';
import 'package:mukto_mart/providers/wish_provider.dart';
import 'package:mukto_mart/screens/account/account_screen.dart';
import 'package:mukto_mart/screens/cart/cart_screen.dart';
import 'package:mukto_mart/screens/categories/categories_screen.dart';
import 'package:mukto_mart/screens/my_bulk_orders/my_bulk_order_screen.dart';
import 'package:mukto_mart/screens/my_order/my_order_screen.dart';
import 'package:mukto_mart/screens/sign_in/sign_in_screen.dart';
import 'package:mukto_mart/screens/wish_list/wish_list_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'components/body.dart';
import 'components/icon_btn_with_counter.dart';
import 'components/search_field.dart';
import 'components/terms_page.dart';
import 'home_screen_page.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId;
  String token;
  int _counter=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context,listen: false);
    categoriesProvider.fetchCategory();
    _checkPreferences();
  }
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId');
      token = preferences.getString('api_token');
    });
  }
  Future<void> _fetch(CartProvider cartProvider,ProfileProvider profileProvider,
      WishProvider wishProvider,FavouriteSellerProvider favouriteSellerProvider,OrderProvider orderProvider,
      MessagesProvider messagesProvider,SaleProductsProvider saleProductsProvider,AllProductsProvider allProductsProvider,
      CategoriesProvider categoriesProvider,PopularProductsProvider popularProductsProvider,TopProductsProvider topProductsProvider,
      LatestProductsProvider latestProductsProvider,DiscountProductsProvider discountProductsProvider,FeaturedProductsProvider featuredProductsProvider,
      HotProductsProvider hotProductsProvider,BigProductsProvider bigProductsProvider,BannerProvider bannerProvider,
      SliderProvider sliderProvider, FeaturedSettingsProvider featuredSettingsProvider,BulkOrderProvider bulkOrderProvider)async{
    setState(()=> _counter++);
    if(profileProvider.userProfile==null)await profileProvider.fetch(userId);
    if(cartProvider.carts==null) await cartProvider.fetch(token);
    if(wishProvider.wishlists==null)await wishProvider.fetch(token);
    if(wishProvider.Idlist.length==0) {
      if(token != null)await wishProvider.fetchId(token);
    }
    if(favouriteSellerProvider.list==null)await favouriteSellerProvider.fetch(token);
    if(orderProvider.orders==null) {
      if(token != null)await orderProvider.fetch(token);
    }
    if(bulkOrderProvider.bulkOrders==null) {
      if(token != null)await bulkOrderProvider.fetch(token);
    }
    if(messagesProvider.messages==null) {
      if(token != null) messagesProvider.fetch(token);
    }
    if(wishProvider.Idlist.length==0) {
      if(token != null)wishProvider.fetchId(token);
    }
    if(favouriteSellerProvider.Idlist.length==0) {
      if (token != null) favouriteSellerProvider.fetchSellerId(token);
    }
    if(cartProvider.carts==null) await cartProvider.fetch(token);
    if(saleProductsProvider.saleProducts==null) await saleProductsProvider.fetch(1);
    if(allProductsProvider.allProducts==null) await allProductsProvider.fetch(1);
    if(categoriesProvider.subCategories==null) await categoriesProvider.fetchFirstSubCategories();
    if(categoriesProvider.homeCategories==null) await categoriesProvider.fetchHomeCategory();
    if(popularProductsProvider.popularProducts==null) await popularProductsProvider.fetch(1);
    if(topProductsProvider.topProducts==null)await topProductsProvider.fetch(1);
    if(latestProductsProvider.latestProducts==null)await latestProductsProvider.fetch(1);
    if(discountProductsProvider.discountProducts==null)await discountProductsProvider.fetch(1);
    if(featuredProductsProvider.featuredProducts==null)await featuredProductsProvider.fetch(1);
    if(hotProductsProvider.hotProducts==null) await hotProductsProvider.fetch(1);
    if(bigProductsProvider.bigProducts==null)await bigProductsProvider.fetch(1);
    if(allProductsProvider.allProductList.isEmpty)allProductsProvider.fetchList();
    if(bannerProvider.list.length==0)bannerProvider.fetch();
    if(sliderProvider.slidersList.length==0)sliderProvider.fetchSliders();
    if(featuredSettingsProvider.featureLinks.isEmpty)await featuredSettingsProvider.fetchLinks();
    // if(featuredSettingsProvider.featureSettings==null)await featuredSettingsProvider.fetch();
    // if(featuredSettingsProvider.productListFeature1==null)await featuredSettingsProvider.fetch1(1);
    // if(featuredSettingsProvider.productListFeature2==null)await featuredSettingsProvider.fetch2(1);
    // if(featuredSettingsProvider.productListFeature3==null)await featuredSettingsProvider.fetch3(1);
    // if(featuredSettingsProvider.productListFeature4==null)await featuredSettingsProvider.fetch4(1);
  }
  @override
  Widget build(BuildContext context) {
    final CouponProvider couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final CartProvider cartProvider = Provider.of<CartProvider>(context,listen: false);
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context,listen: false);
    final CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context,listen: false);
    final WishProvider wishProvider = Provider.of<WishProvider>(context,listen: false);
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context,listen: false);
    final MessagesProvider messagesProvider = Provider.of<MessagesProvider>(context,listen: false);
    final SaleProductsProvider saleProductsProvider = Provider.of<SaleProductsProvider>(context,listen: false);
    final AllProductsProvider allProductsProvider = Provider.of<AllProductsProvider>(context,listen: false);
    final PopularProductsProvider popularProductsProvider = Provider.of<PopularProductsProvider>(context,listen: false);
    final TopProductsProvider topProductsProvider = Provider.of<TopProductsProvider>(context,listen: false);
    final LatestProductsProvider latestProductsProvider = Provider.of<LatestProductsProvider>(context,listen: false);
    final DiscountProductsProvider discountProductsProvider = Provider.of<DiscountProductsProvider>(context,listen: false);
    final FeaturedProductsProvider featuredProductsProvider = Provider.of<FeaturedProductsProvider>(context,listen: false);
    final HotProductsProvider hotProductsProvider = Provider.of<HotProductsProvider>(context,listen: false);
    final BigProductsProvider bigProductsProvider = Provider.of<BigProductsProvider>(context,listen: false);
    final FavouriteSellerProvider favouriteSellerProvider = Provider.of<FavouriteSellerProvider>(context,listen: false);
    final BannerProvider bannerProvider = Provider.of<BannerProvider>(context,listen: false);
    final SliderProvider sliderProvider = Provider.of<SliderProvider>(context,listen: false);
    final BulkOrderProvider bulkOrderProvider = Provider.of<BulkOrderProvider>(context,listen: false);
    final FeaturedSettingsProvider featuredSettingsProvider = Provider.of<FeaturedSettingsProvider>(context,listen: false);

    if(_counter==0) _fetch(cartProvider,profileProvider, wishProvider,favouriteSellerProvider,orderProvider,messagesProvider,saleProductsProvider,
        allProductsProvider,categoriesProvider,popularProductsProvider,topProductsProvider,latestProductsProvider,
        discountProductsProvider,featuredProductsProvider,hotProductsProvider,bigProductsProvider,bannerProvider,sliderProvider,
        featuredSettingsProvider,bulkOrderProvider);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
//            header
              new UserAccountsDrawerHeader(
                accountName: token==null?Text('No User'):profileProvider.userProfile!=null?profileProvider.userProfile.user!=null?Text('${profileProvider.userProfile.user.name??''}'):Text('No User'):Text('No User'),
                accountEmail: token==null?Text(''):profileProvider.userProfile!=null?profileProvider.userProfile.user!=null?Text('${profileProvider.userProfile.user.email??''}'):Text(''):Text(''),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: userId==null?Icon(Icons.person, color: Colors.white,size: 50,):profileProvider.userProfile!=null?profileProvider.userProfile.userImage ==
                        'https://muktomart.com/assets/images/users'
                        ? Icon(Icons.person, color: Colors.white,size: 50,)
                        : Container(
                      height: 130,
                      width: 130,
                      child: CachedNetworkImage(
                        imageUrl: profileProvider.userProfile.userImage,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 80.0,
                          height: 80.0,
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
                      // decoration: BoxDecoration(
                      //     border: Border.all(
                      //       color: kPrimaryColor,
                      //       width: 1,
                      //     ),
                      //     borderRadius: BorderRadius.circular(55),
                      //     image: DecorationImage(
                      //       fit: BoxFit.cover,
                      //       image: NetworkImage(profileProvider
                      //           .userProfile.userImage),
                      //     )),
                    ):Icon(Icons.person, color: Colors.white,size: 50,),
                  ),
                ),
                decoration: new BoxDecoration(
                    color: kPrimaryColor
                ),
              ),

//            body

              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Text('Home Page'),
                  leading: Icon(Icons.home),
                ),
              ),

              InkWell(
                onTap: (){
                  if(userId==''||userId==null){
                    Navigator.pushNamed(context, SignInScreen.routeName);
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return AccountScreen();  }));
                  }

                },
                child: ListTile(
                  title: Text('My account'),
                  leading: Icon(Icons.person),
                ),
              ),

              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return MyOrders();  }));
                },
                child: ListTile(
                  title: Text('My Orders'),
                  leading: Icon(Icons.shopping_basket),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return MyBulkOrders();
                  }));
                },
                child: ListTile(
                  title: Text('My Bulk Orders'),
                  leading: Icon(Icons.shopping_basket),
                ),
              ),

              InkWell(
                onTap: (){
                  categoriesProvider.subCategories!=null?Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return CategoriesScreen();  })):null;
                },
                child: ListTile(
                  title: Text('Categories'),
                  leading: Icon(Icons.dashboard),
                ),
              ),

              InkWell(
                onTap: (){
                  userId!=null?Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return WishListScreen();})):Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return SignInScreen();}));
                },
                child: ListTile(
                  title: Text('Favourites'),
                  leading: Icon(Icons.favorite),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return TermsPage(appBarName: 'Privacy & Policy',url: 'https://muktomart.com/app_pages/privacy.php',);}));
                },
                child: ListTile(
                  title: Text('Privacy & Policy'),
                  leading: Icon(FontAwesomeIcons.userSecret,size: 20,),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return TermsPage(appBarName: 'Refund and Return Policy',url: 'https://muktomart.com/app_pages/return.php',);}));
                },
                child: ListTile(
                  title: Text('Refund and Return Policy'),
                  leading: Icon(FontAwesomeIcons.undo,size: 20,),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return TermsPage(appBarName: 'Terms & Condition',url: 'https://muktomart.com/app_pages/terms.php',);}));
                },
                child: ListTile(
                  title: Text('Terms & Condition'),
                  leading: Icon(FontAwesomeIcons.gavel,size: 20,),
                ),
              ),

              Divider(),

              userId==''?Container():userId==null?Container():InkWell(
                onTap: ()async{
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  // pref.setString('userId', '');
                  // pref.setString('api_token', '');
                  pref.clear();
                  GoogleSignIn().signOut();
                  FacebookAuth.instance.logOut();
                  couponProvider.coupon.amount= null;
                  cartProvider.carts.totalPrice = null;
                  orderProvider.orders!=null?orderProvider.orders.orders=null:null;
                  cartProvider.carts!=null?cartProvider.carts.item=null:null;
                  profileProvider.userProfile.user=null;
                  wishProvider.wishlists.wishlist=null;
                  wishProvider.Idlist.clear();
                  messagesProvider.messages!=null?messagesProvider.messages.convs=null:null;
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      HomeScreenPage()));
                  _showToast('Logged Out', kPrimaryColor);
                },
                child: ListTile(
                  title: Text('Log out'),
                  leading: Icon(Icons.transit_enterexit, color: Colors.grey,),
                ),
              ),

            ],
          ),
        ),
        appBar: AppBar(
          actions: [
            Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchField(),
            )),
            SizedBox(width: 1),
            Center(
              child: IconBtnWithCounter(
                svgSrc: "assets/icons/Cart Icon.svg",
                numOfitem: cartProvider.carts==null?0:cartProvider.carts.item==null?0:cartProvider.carts.item.length,
                press: () => Navigator.pushNamedAndRemoveUntil(context, CartScreen.routeName,(Route<dynamic> route) => false),
              ),
            ),
            SizedBox(width: 3),
          ],
        ),
        body: Body(), //CustomBottomNavBar(selectedMenu: MenuState.home),
      ),
    );
  }
  Future<bool> _onBackPressed() async {
    _showDialog();
    //Navigator.pushNamedAndRemoveUntil(context, MainPage.routeName,(Route<dynamic> route) => false);
  }
  _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {

          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Colors.white,
              scrollable: true,
              contentPadding: EdgeInsets.all(20),
              title: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .030,
                  ),
                  Text(
                    'Do you really want to exit?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .050,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          exit(0);
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void _showToast(String message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

}
