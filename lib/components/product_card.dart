import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/models/popolar_products_model.dart';
import 'package:mukto_mart/providers/details_provider.dart';
import 'package:mukto_mart/providers/wish_provider.dart';
import 'package:mukto_mart/repo/wish_list_repo.dart';
import 'package:mukto_mart/screens/details/details_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key key,
    this.width = 140,
    this.aspectRatio = 1.02,
    @required this.product,
  }) : super(key: key);

  final double width, aspectRatio;
  final PopularProductsDatum product;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavourite=false;
  var image;
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
    final size= MediaQuery.of(context).size;
    final WishProvider wishProvider = Provider.of<WishProvider>(context,listen: false);
    final DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context,listen: false);
    if(wishProvider.Idlist!=null){
      if(wishProvider.Idlist.contains(widget.product.id)){
        setState(() {
          isFavourite=true;
        });
      }
    }
    // setState(() {
    //   image = base64.decode(widget.product.thumbnail);
    // });
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(8)),
      child: SizedBox(
        width: getProportionateScreenWidth(widget.width),
        child: GestureDetector(
          onTap: () {
            detailsProvider.backed=0;
            Navigator.push(context,MaterialPageRoute(builder: (_) {
              return AllDetailsScreen(productDetails:detailsProvider.productDetails,favourite: isFavourite,
                productId: widget.product.id,);  }));
          },
          child: Container(
            color: kSecondaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: size.height*.20,
                    width: size.width,
                    //padding: EdgeInsets.all(getProportionateScreenWidth(2)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Hero(
                      tag: widget.product.id.toString(),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.thumbnail,
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                        fit: BoxFit.fill,
                      )//Image.network(widget.product.thumbnail,fit: BoxFit.fitWidth),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.name,
                    style: TextStyle(color: Colors.black),
                    maxLines: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.product.price}",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          if (token == '' || token == null) {
                            _showToast(
                                'Please log in first..', Colors.redAccent);
                          } else {
                            setState(() {
                              isFavourite == false
                                  ? isFavourite = true
                                  : null;
                            });
                            isFavourite == true
                                ? wishListRepo
                                .addWishList(token, widget.product.id)
                                .then((value) {
                              _showToast(
                                  'Product added to your wishlist',
                                  kPrimaryColor);
                              wishProvider.fetch(token);
                              wishProvider.fetchId(token);
                            })
                                : null;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(getProportionateScreenWidth(6)),
                          height: getProportionateScreenWidth(25),
                          width: getProportionateScreenWidth(25),
                          decoration: BoxDecoration(
                            color: isFavourite
                                ? kPrimaryColor.withOpacity(0.15)
                                : kSecondaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/Heart Icon_2.svg",
                            color: isFavourite
                                ? Color(0xFFFF4848)
                                : Color(0xFFDBDEE4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  widget.product.previousPrice!='৳0'?Text(
                    "${widget.product.previousPrice}",
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(12),
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],decoration: TextDecoration.lineThrough
                    ),
                  ):Text(''),
                  Row(
                    children: [
                      widget.product.rating=='1.0'?Icon(Icons.star,size: 15,color: Colors.yellow,):widget.product.rating=='0.5'?Icon(Icons.star_half,size: 15,color: Colors.yellow,):Icon(Icons.star_border,size: 15),
                      widget.product.rating=='2.0'?Icon(Icons.star,size: 15,color: Colors.yellow,):widget.product.rating=='1.5'?Icon(Icons.star_half,size: 15,color: Colors.yellow,):Icon(Icons.star_border,size: 15),
                      widget.product.rating=='3.0'?Icon(Icons.star,size: 15,color: Colors.yellow,):widget.product.rating=='2.5'?Icon(Icons.star_half,size: 15,color: Colors.yellow,):Icon(Icons.star_border,size: 15),
                      widget.product.rating=='4.0'?Icon(Icons.star,size: 15,color: Colors.yellow,):widget.product.rating=='3.5'?Icon(Icons.star_half,size: 15,color: Colors.yellow,):Icon(Icons.star_border,size: 15),
                      widget.product.rating=='5.0'?Icon(Icons.star,size: 15,color: Colors.yellow,):widget.product.rating=='4.5'?Icon(Icons.star_half,size: 15,color: Colors.yellow,):Icon(Icons.star_border,size: 15),
                    ],
                  )
            ],
          ),
        ),
      ),
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
