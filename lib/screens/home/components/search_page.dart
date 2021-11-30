import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/helper/keyboard.dart';
import 'package:mukto_mart/models/all_products_name_model.dart';
import 'package:mukto_mart/models/local_search_model.dart';
import 'package:mukto_mart/providers/all_products_provider.dart';
import 'package:mukto_mart/providers/cart_provider.dart';
import 'package:mukto_mart/providers/details_provider.dart';
import 'package:mukto_mart/providers/local_search_provider.dart';
import 'package:mukto_mart/providers/wish_provider.dart';
import 'package:mukto_mart/repo/cart_repo.dart';
import 'package:mukto_mart/screens/sign_in/sign_in_screen.dart';
import 'package:mukto_mart/screens/details/details_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:mukto_mart/providers/all_search_products_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_screen_page.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Products> filteredProducts = [];
  List<Products> productList = [];
  int _counterProduct = 0;
  CartRepo cartRepo = CartRepo();
  String token;
  int suggest=0;
  int count=0;
  int _counter = 0;
  var image;
  List<String> items=[];
  bool isFavourite=false;
  bool _isLoading = false;
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('api_token');
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final AllProductsProvider allProductsProvider = Provider.of<AllProductsProvider>(context,listen: false);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context,listen: false);
    databaseHelper.searches.clear();
    databaseHelper.getSearchList();
    _checkPreferences();
  }
  @override
  Widget build(BuildContext context) {
    final AllSearchProductsProvider allSearchProductsProvider = Provider.of<AllSearchProductsProvider>(context,listen: false);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context,listen: false);
    final AllProductsProvider allProductsProvider = Provider.of<AllProductsProvider>(context,listen: false);
    final size = MediaQuery.of(context).size;
    if(_counterProduct==0){
      allProductsProvider.fetchProductsName().then((value){
        setState(() {
          _counterProduct++;
          productList=allProductsProvider.allProductNameList;
          filteredProducts=productList;
        });
      });

    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return HomeScreenPage();  }));
              },),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: SizeConfig.screenWidth * 0.85,
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                       onChanged: (value) {
                         setState(() {
                           suggest++;
                           filteredProducts = productList
                               .where((u) => (u.name
                               .toLowerCase()
                               .contains(value.toLowerCase())))
                               .toList();
                         });
                         if(value==''){
                           setState(() {
                             suggest=0;
                             _counter=0;
                           });
                         }
                       },
                      onSubmitted: (val)async{
                        final String timestamp=DateTime.now().millisecondsSinceEpoch.toString();
                        LocalSearchModel localSearch=LocalSearchModel(val, timestamp);
                        if(databaseHelper.searches.contains(val)){
                        }else{
                          await databaseHelper.insertCart(localSearch);
                        }
                          print(databaseHelper.searchList.length);
                        allSearchProductsProvider.allSearchProducts.data!=null?allSearchProductsProvider.allSearchProducts.data.clear():null;
                        setState(() {
                          _counter++;
                          _isLoading=true;
                          suggest=0;
                        });
                        allSearchProductsProvider.fetch(val).then((value){
                          setState(() {
                            _isLoading=false;
                          });
                        });
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20),
                              vertical: getProportionateScreenWidth(6)),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "What would you like to buy",
                          hintStyle: TextStyle(fontSize: size.width*.037),
                          prefixIcon: Icon(Icons.search)),
                    ),

                  ),
                ),
              ],
            ),
            body: _bodyUI()
          ),
          _isLoading?Center(child: CircularProgressIndicator()):Container()
        ],
      ),
    );
  }
  Future<bool> _onBackPressed() async {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return HomeScreenPage();  }),);
  }
  Widget _bodyUI() {
    final size = MediaQuery.of(context).size;
    final WishProvider wishProvider = Provider.of<WishProvider>(context,listen: false);
    final CartProvider cartProvider = Provider.of<CartProvider>(context,listen: false);
    final DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context,listen: false);
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context,listen: false);
    final AllProductsProvider allProductsProvider = Provider.of<AllProductsProvider>(context,listen: false);
    final AllSearchProductsProvider allSearchProductsProvider = Provider.of<AllSearchProductsProvider>(context,listen: false);
    return suggest==0?_counter==0?
    searchHistory(databaseHelper,allSearchProductsProvider)
    // Container(
    //   color: Colors.white,
    //   child: Center(child: Text('Search Products',style: TextStyle(color: Colors.black),)),
    // )
        :_isLoading?Container():allSearchProductsProvider.allSearchProducts==null?Container(
      color: Colors.white,
      child: Center(child: Text('No Products Found',style: TextStyle(color: Colors.black),)),
    ):allSearchProductsProvider.allSearchProducts.data==null?Container():
    allSearchProductsProvider.allSearchProducts.data.isEmpty?Container(
      color: Colors.white,
      child: Center(child: Text('No Products Found',style: TextStyle(color: Colors.black),)),
    ):
    Container(
      height: size.height,width: size.width,
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: allSearchProductsProvider.allSearchProducts==null?0:allSearchProductsProvider.allSearchProducts.data.isEmpty?0:allSearchProductsProvider.allSearchProducts.data.length,
          itemBuilder: (context, index) {

            //image = base64.decode(allSearchProductsProvider.allSearchProducts.data[index].thumbnail);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  if(count==0){
                    if(wishProvider.Idlist.contains(allSearchProductsProvider.allSearchProducts.data[index].id)){
                      setState(() {
                        isFavourite=true;
                        count++;
                      });
                    }
                  }
                      Navigator.push(context,MaterialPageRoute(builder: (_) {
                        return AllDetailsScreen(productDetails:detailsProvider.productDetails,favourite: isFavourite,productId: allSearchProductsProvider.allSearchProducts.data[index].id,);  }));

                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * .25,
                          child: AspectRatio(
                            aspectRatio: 0.88,
                            child: Container(
                              padding: EdgeInsets.all(
                                  getProportionateScreenWidth(10)),
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F6F9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.network(allSearchProductsProvider.allSearchProducts.data[index].thumbnail),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: size.width * .35,
                              child: Text(
                                allSearchProductsProvider.allSearchProducts.data[index].name,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: size.width * .35,
                              child: Text(
                                     "${allSearchProductsProvider.allSearchProducts.data[index].price}",
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 16),
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              width: size.width * .42,
                              child: allSearchProductsProvider.allSearchProducts.data[index].percent!='0'?Text(
                                "${allSearchProductsProvider.allSearchProducts.data[index].previousPrice}",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16,decoration: TextDecoration.lineThrough),
                                maxLines: 2,
                              ):null,
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: (){
                            if(_isLoading==false){
                              setState(() {
                                _isLoading = true;
                              });
                              token==''? Navigator.pushNamed(context, SignInScreen.routeName):token==null?
                              Navigator.pushNamed(context, SignInScreen.routeName):cartRepo.addToCart(token, allSearchProductsProvider.allSearchProducts.data[index].id).then((value){
                                //cartProvider.clear();
                                cartProvider.fetch(token).then((value){
                                  //cartProvider.fetchPrice(token);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  _showToast('Product added to cart', kPrimaryColor);
                                });

                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            height: size.width*.1,
                            width: size.width*.23,
                            child: Center(child: Text('Add to Cart',style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10)
                  ],
                ),
              )
            );
          }),
    ):Suggesions(allProductsProvider,allSearchProductsProvider,wishProvider,detailsProvider,cartProvider);
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

  Widget searchHistory(DatabaseHelper databaseHelper,AllSearchProductsProvider allSearchProductsProvider){
    return Column(
      children: [
        databaseHelper.searches.length!=0?Padding(
          padding: const EdgeInsets.only(left:12.0,right: 8.0,bottom: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Search History'),
              InkWell(
                onTap: ()async{
                  KeyboardUtil.hideKeyboard(context);
                  databaseHelper.deleteAllSearchList();
                    databaseHelper.searches.clear();
                },
                  child: Icon(Icons.delete_forever,color: Colors.grey[600],))
            ],
          ),
        ):Container(),
        Padding(
          padding: const EdgeInsets.only(left:12.0,right: 8.0,top: 4.0),
          child: Container(
            child: StaggeredGridView.countBuilder(
              shrinkWrap: true,
              physics: new ClampingScrollPhysics(),
              itemCount: databaseHelper.searches.length<10?databaseHelper.searches.length:10,
              crossAxisCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){
                    allSearchProductsProvider.allSearchProducts!=null?allSearchProductsProvider.allSearchProducts.data!=null?allSearchProductsProvider.allSearchProducts.data.clear():null:null;
                    setState(() {
                      _counter++;
                      _isLoading=true;
                    });
                    KeyboardUtil.hideKeyboard(context);
                    allSearchProductsProvider.fetch(databaseHelper.searches[index]).then((value){
                      setState(() {
                        _isLoading=false;
                      });
                    });
                  },
                  child: databaseHelper.searches[index]!=''?Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(600)),
                    ),
                    child: Center(child: Text(databaseHelper.searches[index],style: TextStyle(color: Colors.black),))
                  ):Container(),
                );
              },
              staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(1, .4),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 6,

            ),
          ),
        ),
      ],
    );
  }

  Widget Suggesions(AllProductsProvider allProductsProvider,AllSearchProductsProvider allSearchProductsProvider,
      WishProvider wishProvider,DetailsProvider detailsProvider,CartProvider cartProvider){
    final size = MediaQuery.of(context).size;
    return Container(
      child: ListView.builder(
        itemCount: filteredProducts.length,
          itemBuilder: (BuildContext context,int index){
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                if(count==0){
                  if(wishProvider.Idlist.contains(filteredProducts[index].id)){
                    setState(() {
                      isFavourite=true;
                      count++;
                    });
                  }
                }
                Navigator.push(context,MaterialPageRoute(builder: (_) {
                  return AllDetailsScreen(productDetails:detailsProvider.productDetails,favourite: isFavourite,productId: filteredProducts[index].id,);  }));

              },
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * .25,
                        child: AspectRatio(
                          aspectRatio: 0.88,
                          child: Container(
                            padding: EdgeInsets.all(
                                getProportionateScreenWidth(10)),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F6F9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.network(filteredProducts[index].image),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width * .35,
                            child: Text(
                              filteredProducts[index].name,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: size.width * .35,
                            child: Text(
                              "${filteredProducts[index].price}",
                              style: TextStyle(
                                  color: kPrimaryColor, fontSize: 16),
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            width: size.width * .42,
                            child: filteredProducts[index].percent!='0'?Text(
                              "${filteredProducts[index].previousPrice}",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 16,decoration: TextDecoration.lineThrough),
                              maxLines: 2,
                            ):null,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          if(_isLoading==false){
                            setState(() {
                              _isLoading = true;
                            });
                            token==''? Navigator.pushNamed(context, SignInScreen.routeName):token==null?
                            Navigator.pushNamed(context, SignInScreen.routeName):cartRepo.addToCart(token, filteredProducts[index].id).then((value){
                              //cartProvider.clear();
                              cartProvider.fetch(token).then((value){
                                //cartProvider.fetchPrice(token);
                                setState(() {
                                  _isLoading = false;
                                });
                                _showToast('Product added to cart', kPrimaryColor);
                              });

                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          height: size.width*.1,
                          width: size.width*.23,
                          child: Center(child: Text('Add to Cart',style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10)
                ],
              ),
            )
        );
            // Column(
        //   children: [
        //     InkWell(
        //       onTap: (){
        //         allSearchProductsProvider.allSearchProducts!=null?allSearchProductsProvider.allSearchProducts.data!=null?allSearchProductsProvider.allSearchProducts.data.clear():null:null;
        //         setState(() {
        //           _counter++;
        //           suggest=0;
        //           _isLoading=true;
        //         });
        //         KeyboardUtil.hideKeyboard(context);
        //         allSearchProductsProvider.fetch(filteredProducts[index].name).then((value){
        //           setState(() {
        //             _isLoading=false;
        //           });
        //         });
        //       },
        //       child: ListTile(
        //         title: Text(filteredProducts[index].name),
        //       ),
        //     ),
        //     Divider(height: 5.0,color: Colors.grey.shade900)
        //   ],
        // );
      }),
    );
  }
}
