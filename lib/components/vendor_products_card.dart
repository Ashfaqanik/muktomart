import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/models/details_model.dart';
import 'package:mukto_mart/models/popolar_products_model.dart';
import 'package:mukto_mart/providers/cart_provider.dart';
import 'package:mukto_mart/providers/details_provider.dart';
import 'package:mukto_mart/providers/wish_provider.dart';
import 'package:mukto_mart/repo/cart_repo.dart';
import 'package:mukto_mart/repo/wish_list_repo.dart';
import 'package:mukto_mart/screens/details/details_screen.dart';
import 'package:mukto_mart/screens/sign_in/sign_in_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:mukto_mart/providers/comment_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorCard extends StatefulWidget {
  final Vendor product;

  const VendorCard({Key key, @required this.product}) : super(key: key);


  @override
  _VendorCardState createState() => _VendorCardState();
}

class _VendorCardState extends State<VendorCard> {
  bool isFavourite=false;
  bool _isLoading = false;
  WishListRepo wishListRepo = WishListRepo();
  String token;
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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final WishProvider wishProvider = Provider.of<WishProvider>(context,listen: false);
    final DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context,listen: false);
    final CartProvider cartProvider = Provider.of<CartProvider>(context,listen: false);
    CartRepo cartRepo = CartRepo();
    if(wishProvider.Idlist!=null){
      if(wishProvider.Idlist.contains(widget.product.id)){
        setState(() {
          isFavourite=true;
        });
      }
    }
    return GestureDetector(
      onTap: () async{
        detailsProvider.backed=0;
        await Navigator.push(context,MaterialPageRoute(builder: (_) {
          return AllDetailsScreen(productDetails:detailsProvider.productDetails,favourite: isFavourite,
            productId: widget.product.id);  }));
      },
      child: Container(
        color: kSecondaryColor.withOpacity(0.1),
        padding: const EdgeInsets.all(3.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: size.height*.20,
                  width: size.width,
                  child: Hero(
                    tag: widget.product.id.toString(),
                    child: Image.network(widget.product.photo,fit: BoxFit.fill),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.product.name,
                  style: TextStyle(color: Colors.black),
                  maxLines: 2,
                ),
                Text(
                  "${widget.product.price}",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                widget.product.previousPrice!=0?Text(
                  "${widget.product.previousPrice}",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],decoration: TextDecoration.lineThrough
                  ),
                ):Container(),
                // Row(
                //   children: [
                //     widget.product.rating=='1.0'?Icon(Icons.star,size: 15,color: Colors.yellow,):widget.product.rating=='0.5'?Icon(Icons.star_half,size: 15,color: Colors.yellow,):Icon(Icons.star_border,size: 15),
                //     widget.product.rating=='2.0'?Icon(Icons.star,size: 15,color: Colors.yellow,):widget.product.rating=='1.5'?Icon(Icons.star_half,size: 15,color: Colors.yellow,):Icon(Icons.star_border,size: 15),
                //     widget.product.rating=='3.0'?Icon(Icons.star,size: 15,color: Colors.yellow,):widget.product.rating=='2.5'?Icon(Icons.star_half,size: 15,color: Colors.yellow,):Icon(Icons.star_border,size: 15),
                //     widget.product.rating=='4.0'?Icon(Icons.star,size: 15,color: Colors.yellow,):widget.product.rating=='3.5'?Icon(Icons.star_half,size: 15,color: Colors.yellow,):Icon(Icons.star_border,size: 15),
                //     widget.product.rating=='5.0'?Icon(Icons.star,size: 15,color: Colors.yellow,):widget.product.rating=='4.5'?Icon(Icons.star_half,size: 15,color: Colors.yellow,):Icon(Icons.star_border,size: 15),
                //   ],
                // ),

                //const SizedBox(height: 8),
              ],
            ),
            InkWell(
              onTap: (){
                setState(() {
                  _isLoading = true;
                });
                token==''? Navigator.pushNamed(context, SignInScreen.routeName):token==null?
                Navigator.pushNamed(context, SignInScreen.routeName):cartRepo.addToCart(token, widget.product.id).then((value){
                  setState(() {
                    _isLoading = false;
                  });
                  _showToast('Product added to cart', kPrimaryColor);
                  //cartProvider.clear();
                  cartProvider.fetch(token);
                  //cartProvider.fetchPrice(token);
                });
              },
              child: _isLoading?Center(child: CupertinoActivityIndicator()):Container(
                width: size.width*.5,
                height: size.height*.05,
                child: Center(child: Text('Add to cart',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
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
}
