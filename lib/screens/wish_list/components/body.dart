import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/providers/details_provider.dart';
import 'package:mukto_mart/providers/wish_provider.dart';
import 'package:mukto_mart/repo/wish_list_repo.dart';
import 'package:mukto_mart/screens/details/details_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isLoading = false;
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
    final WishProvider wishProvider = Provider.of<WishProvider>(context);
    final DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context,listen: false);
    WishListRepo wishListRepo = WishListRepo();

    final size=MediaQuery.of(context).size;

    return Stack(
      children: [
        wishProvider.wishlists!=null?wishProvider.wishlists.wishlist!=null?wishProvider.wishlists.wishlist.length!=0?Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: ListView.builder(
            itemCount: wishProvider.wishlists==null?0:wishProvider.wishlists.wishlist==null?0:wishProvider.wishlists.wishlist.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Dismissible(
                key: Key(wishProvider.wishlists.wishlist[index].id.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    wishProvider.wishlists.wishlist.removeAt(index);
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
                child: InkWell(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (_) {
                      return AllDetailsScreen(productDetails:detailsProvider.productDetails,favourite: true,
                        productId: wishProvider.wishlists.wishlist[index].productId,);  }));
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 88,
                        child: AspectRatio(
                          aspectRatio: 0.88,
                          child: Container(
                            padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F6F9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: wishProvider.wishlists.wishlist[index].photo,
                              placeholder: (context, url) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            )//Image.network(wishProvider.wishlists.wishlist[index].photo),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width*.4,
                            child: Text(
                              wishProvider.wishlists.wishlist[index].name,
                              style: TextStyle(color: Colors.black, fontSize: 16),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              text: "\$${wishProvider.wishlists.wishlist[index].price}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, color: kPrimaryColor),
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 20),
                      InkWell(
                          onTap: ()async{
                            setState(() {
                              _isLoading=true;
                            });
                            await wishListRepo.removeWish(token, wishProvider.wishlists.wishlist[index].id);
                              await wishProvider.fetch(token);
                            setState(() {
                              _isLoading=false;
                            });
                            _showToast('Product removed from wishList', kPrimaryColor);
                              wishProvider.fetchId(token);
                          },
                          child: Icon(Icons.highlight_remove_sharp,color: Colors.grey[700]))
                    ],
                  ),
                )
              ),
            ),
          ),
        ):
        Container(child: Center(child: Text('WishList is Empty')),):
        Container(child: Center(child: Text('WishList is Empty'))):Container(child: Center(child: Text('WishList is Empty')),),
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
}
