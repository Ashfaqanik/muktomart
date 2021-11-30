import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/components/default_button.dart';
import 'package:mukto_mart/components/rounded_icon_btn.dart';
import 'package:mukto_mart/providers/cart_provider.dart';
import 'package:mukto_mart/repo/cart_repo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mukto_mart/screens/check_out/check_out_screen.dart';
import 'package:mukto_mart/screens/home/home_screen_page.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:mukto_mart/providers/check_out_provider.dart';
import 'package:mukto_mart/providers/coupon_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/svg.dart';

class CartScreenWidget extends StatefulWidget {
  static String routeName = "/cart";

  @override
  _CartScreenWidgetState createState() => _CartScreenWidgetState();
}

class _CartScreenWidgetState extends State<CartScreenWidget> {
  String token;
  bool _isLoading = false;
  bool coupon = false;
  String couponText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('api_token');
    });
  }

  // Future<void> _fetch(CartProvider cartProvider) async {
  //   // cartProvider.clear();
  //   // cartProvider.fetch(token).then((value) {
  //   //   cartProvider.fetchPrice(token).then((value){
  //   //     setState(() {
  //   //       _isLoading = false;
  //   //     });
  //   //   });
  //   //
  //   // });
  //   cartProvider.fetch(token).then((value) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    final CheckOutProvider checkOutProvider =
        Provider.of<CheckOutProvider>(context, listen: false);
    final CouponProvider couponProvider =
        Provider.of<CouponProvider>(context, listen: false);
    final CartRepo cartRepo = CartRepo();

    return Stack(
      children: [
        WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            appBar: buildAppBar(context),
            body:
                Cart(cartProvider, cartRepo, couponProvider, checkOutProvider),
          ),
        ),
        _isLoading ? Center(child: CircularProgressIndicator()) : Container()
      ],
    );
  }

  Widget Cart(CartProvider cartProvider, CartRepo cartRepo,
      CouponProvider couponProvider, CheckOutProvider checkOutProvider) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
            child: cartProvider.carts!=null?cartProvider.carts.item!=null?cartProvider.carts.item.length!=0?Padding(
              padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
              child: ListView.builder(
                  itemCount: cartProvider.carts == null
                      ? 0
                      : cartProvider.carts.item == null
                      ? 0
                      : cartProvider.carts.item.length,
                  itemBuilder: (context, index){
                    //int qty=cartProvider.carts.item[index].qty;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Dismissible(
                          key: Key(cartProvider.carts.item[index].id.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() {
                              cartProvider.carts.item.removeAt(index);
                            });
                          },
                          background: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFE6E6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Spacer(),
                                SvgPicture.asset("assets/icons/Trash.svg"),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: size.width * .25,
                                child: AspectRatio(
                                  aspectRatio: 0.88,
                                  child: Container(
                                    padding:
                                    EdgeInsets.all(getProportionateScreenWidth(10)),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5F6F9),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: cartProvider.carts.item[index].image,
                                      placeholder: (context, url) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    )//Image.network(cartProvider.carts.item[index].image),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: size.width * .27,
                                    child: Text(
                                      cartProvider.carts.item[index].name,
                                      style:
                                      TextStyle(color: Colors.black, fontSize: 16),
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text.rich(
                                    TextSpan(
                                      text:
                                      "৳${cartProvider.carts.item[index].itemPrice}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: kPrimaryColor),
                                      // children: [
                                      //   TextSpan(
                                      //       text:
                                      //           " x${cartProvider.carts.item[index].qty}",
                                      //       style:
                                      //           Theme.of(context).textTheme.bodyText1),
                                      // ],
                                    ),
                                  )
                                ],
                              ),
                              RoundedIconBtn(
                                icon: Icons.remove,
                                press: () async{
                                  if(cartProvider.carts.item[index].qty>1){
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await cartRepo
                                        .reduceByOne(token, cartProvider.carts.item[index].id, cartProvider.carts.item[index].itemid);
                                    //.then((value) async {
                                    await cartProvider.fetch(token);
                                    setState(() {
                                      _isLoading = false;
                                    });

                                    //_showToast('1 item removed', kPrimaryColor);
                                    //});
                                  }
                                },
                              ),
                              Text.rich(
                                TextSpan(
                                  text:
                                  "${cartProvider.carts.item[index].qty}",
                                  style: TextStyle(color: Colors.black),

                                ),
                              ),
                              SizedBox(width: 5),
                              RoundedIconBtn(
                                icon: Icons.add,
                                showShadow: true,
                                press: () async{
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await cartRepo
                                      .addToCart(
                                      token, cartProvider.carts.item[index].id);
                                  //.then((value) async {
                                  await cartProvider.fetch(token);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  //_showToast('1 item added', kPrimaryColor);
                                  //});
                                },
                              ),
                              SizedBox(width: 10),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    cartRepo
                                        .removeCart(
                                        token, cartProvider.carts.item[index].id)
                                        .then((value) async {
                                      await cartProvider.fetch(token);
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      _showToast('Product removed', kPrimaryColor);
                                    });
                                  },
                                  child: Icon(Icons.delete_forever,
                                      color: Colors.grey[700]))
                            ],
                          )),
                    );
                  }
              ),
            ):Container(child: Center(child: Text('Cart is Empty')),)
        :Container(child: Center(child: Text('Cart is Empty'))):Container(child: Center(child: Text('Cart is Empty')),)
        ),
        cartProvider.carts!=null?cartProvider.carts.item!=null?cartProvider.carts.item.length!=0?Container(
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(15),
            horizontal: getProportionateScreenWidth(30),
          ),
          // height: 174,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -15),
                blurRadius: 20,
                color: Color(0xFFDADADA).withOpacity(0.15),
              )
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  InkWell(
                    child: Text(
                      "Have coupon code?",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: size.width * .04,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        coupon == true ? coupon = false : coupon = true;
                      });
                    },
                  ),
                  const SizedBox(width: 5),
                ]),
                SizedBox(height: getProportionateScreenHeight(10)),
                coupon == true
                    ? Container(
                  height: size.width * .15,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          maxLines: 1,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              hintText: "Enter coupon code..",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              couponText = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: size.width * .02),
                      InkWell(
                        onTap: () {
                          print(cartProvider.carts.totalPrice);
                          setState(() {
                            _isLoading = true;
                          });
                          couponProvider
                              .fetch(token, couponText,
                              cartProvider.carts.totalPrice)
                              .then((value) {
                            if (couponProvider.coupon.amount == null) {
                              _showToast(
                                  'Invalid coupon', Colors.redAccent);
                              setState(() {
                                _isLoading = false;
                              });
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              print(couponProvider.coupon.couponPrice);
                              _showToast(
                                  'Your coupon applied successfully',
                                  kPrimaryColor);
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                              getProportionateScreenWidth(5)),
                          height: size.width * .14,
                          width: getProportionateScreenWidth(80),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                              child: Text(
                                'Apply',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "Total:\n",
                        children: [
                          couponProvider.coupon.amount == null
                              ? TextSpan(
                            text: cartProvider.carts == null
                                ? '৳0'
                                : cartProvider.carts.totalPrice == null
                                ? '৳0'
                                : "৳${cartProvider.carts.totalPrice}",
                            style: TextStyle(
                                fontSize: 16, color: Colors.black),
                          )
                              : TextSpan(
                            text: "৳${couponProvider.coupon.amount}",
                            style: TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(190),
                      child: DefaultButton(
                        text: "Check Out",
                        press: () {
                          if (token != null) {
                            setState(() {
                              _isLoading = true;
                            });
                            checkOutProvider.fetch(token).then((value) {
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                    return CheckOutScreen();
                                  }));
                            });
                          } else {
                            _showToast('Please log in first', Colors.redAccent);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ):Container():Container():Container()
      ],
    );
  }

  Future<bool> _onBackPressed() async {
    setState(() {
      _isLoading=false;
    });
    final CouponProvider couponProvider =
        Provider.of<CouponProvider>(context, listen: false);
    couponProvider.coupon.amount = null;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
      return HomeScreenPage();  }),(Route<dynamic> route) => false);
    //Navigator.pushNamedAndRemoveUntil(context, MainPage.routeName,(Route<dynamic> route) => false);
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

  AppBar buildAppBar(BuildContext context) {
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    final CouponProvider couponProvider =
        Provider.of<CouponProvider>(context, listen: false);
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            _isLoading=false;
          });
          couponProvider.coupon.amount = null;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
            return HomeScreenPage();  }),(Route<dynamic> route) => false);
          //Navigator.pushNamedAndRemoveUntil(context, MainPage.routeName,(Route<dynamic> route) => false);
        },
      ),
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            cartProvider.carts == null
                ? "0 items"
                : cartProvider.carts.item == null
                    ? '0 items'
                    : "${cartProvider.carts.item.length} items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
