import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/models/details_model.dart';
import 'package:mukto_mart/providers/cart_provider.dart';
import 'package:mukto_mart/providers/details_provider.dart';
import 'package:mukto_mart/providers/local_search_provider.dart';
import 'package:mukto_mart/screens/cart/cart_screen.dart';
import 'package:mukto_mart/screens/sign_in/sign_in_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product_description.dart';
import 'package:mukto_mart/repo/cart_repo.dart';
import 'top_rounded_container.dart';

class AllProductBody extends StatefulWidget {
  final ProductDetails productDetails;
  final bool favourite;
  final int productId;

  const AllProductBody({Key key, @required this.productDetails,this.favourite,this.productId}) : super(key: key);

  @override
  _AllProductBodyState createState() => _AllProductBodyState();
}

class _AllProductBodyState extends State<AllProductBody> {
  String token;
  CartRepo cartRepo = CartRepo();
  bool _isLoading = false;
  bool _isLoading1 = false;
  bool _isLoadingCart = false;
  bool _isLoadingBuy = false;
  var selectedImage = 0;
  int _counter=0;

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
    _checkPreferences();
  }
  Future<void> _fetch(DetailsProvider detailsProvider)async{
    setState(()=> _counter++);
    setState(() {
      _isLoading1=true;
    });
    print(DateTime.now().second);
    detailsProvider.fetch(widget.productId).then((value){
        setState(() {
          _isLoading1=false;
        });
        print(DateTime.now().second);
    });
  }
  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context,listen: false);
    final DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context,listen: false);
    final size= MediaQuery.of(context).size;
    final DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context,listen: false);
    String image=detailsProvider.productDetails!=null?detailsProvider.productDetails.product.galleries[selectedImage].images:'';
    if(_counter==0) _fetch(detailsProvider);
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _isLoading1?Container():Column(
                    children: [
                      Container(
                        height: size.height*.35,
                        width: size.height*.35,
                        child: Hero(
                            tag: selectedImage.toString(),
                            child: CachedNetworkImage(
                              imageUrl: image,
                              placeholder: (context, url) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset("assets/images/placeholder.png")
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.fitHeight,
                            )//Image.network(image,fit: BoxFit.fill),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(detailsProvider.productDetails!=null?detailsProvider.productDetails.product.galleries.length:0,
                                  (index) => buildSmallProductPreview(index)),
                        ],
                      )
                    ],
                  ),
                  TopRoundedContainer(
                    color: Colors.white,
                    child: _isLoading1?Container():ProductDescription(
                      productDetails: detailsProvider.productDetails,
                      favourite: widget.favourite,
                      productId: widget.productId,
                      pressOnSeeMore: () {},
                    ),
                  ),
                ],
              ),
            ),
            TopRoundedContainer(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.screenWidth * 0.05,
                  right: SizeConfig.screenWidth * 0.05,
                  bottom: getProportionateScreenWidth(20),
                  //top: getProportionateScreenWidth(2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: getProportionateScreenHeight(56),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: _isLoadingCart==false?kPrimaryLightColor:Colors.grey,
                            onPressed: () {
                              if(_isLoading==false){
                                setState(() {
                                  _isLoading = true;
                                  _isLoadingCart = true;
                                });
                                token==null?
                                Navigator.pushNamed(context, SignInScreen.routeName):
                                cartRepo.addToCart(token, widget.productId).then((value){
                                  //cartProvider.clear();
                                  cartProvider.fetch(token);
                                  setState(() {
                                    _isLoading = false;
                                    _isLoadingCart = false;
                                  });
                                  _showToast('Product added to cart', kPrimaryColor);

                                });
                              }

                            },
                          child: Text(
                            "Add To Cart",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                      // DefaultButton(
                      //   text: "Add To Cart",
                      //   press: () {
                      //     setState(() {
                      //       _isLoading = true;
                      //     });
                      //     token==''? Navigator.pushNamed(context, SignInScreen.routeName):token==null?
                      //     Navigator.pushNamed(context, SignInScreen.routeName):_isLoading?null:cartRepo.addToCart(token, widget.productId).then((value){
                      //       //cartProvider.clear();
                      //       cartProvider.fetch(token).then((value){
                      //         //cartProvider.fetchPrice(token);
                      //         setState(() {
                      //           _isLoading = false;
                      //         });
                      //         _showToast('Product added to cart', kPrimaryColor);
                      //       });
                      //
                      //     });
                      //
                      //   },
                      // ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(10)),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: getProportionateScreenHeight(56),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: _isLoadingBuy==false?kPrimaryColor:Colors.grey,
                          onPressed: () {
                            if(_isLoading==false){
                              setState(() {
                                _isLoading = true;
                                _isLoadingBuy=true;
                              });
                              token==''? Navigator.pushNamed(context, SignInScreen.routeName):token==null?
                              Navigator.pushNamed(context, SignInScreen.routeName):cartRepo.addToCart(token, widget.productId).then((value)async{
                                //cartProvider.carts!=null?cartProvider.clear():null;
                                await cartProvider.fetch(token);
                                setState(() {
                                  _isLoading = false;
                                  _isLoadingBuy=false;
                                });
                                Navigator.pushNamed(context, CartScreen.routeName);
                              });
                            }

                          },
                          child: Text(
                            "Buy Now",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )

                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        _isLoading ? Center(child: CircularProgressIndicator()) : Container()
      ],
    );
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

  GestureDetector buildSmallProductPreview(int index) {
    final DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context,listen: false);
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
          duration: defaultDuration,
          margin: EdgeInsets.only(right: 15),
          padding: EdgeInsets.all(8),
          height: getProportionateScreenWidth(48),
          width: getProportionateScreenWidth(48),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
          ),
          child: CachedNetworkImage(
            imageUrl: detailsProvider.productDetails.product.galleries[index].images,
            placeholder: (context, url) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(),
            ),
            errorWidget: (context, url, error) =>
                Icon(Icons.error),
            fit: BoxFit.fill,
          )//Image.network(detailsProvider.productDetails.product.galleries[index].images),
      ),
    );
  }
}
