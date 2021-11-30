import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mukto_mart/providers/cart_provider.dart';
import 'package:mukto_mart/providers/coupon_provider.dart';
import 'package:mukto_mart/providers/messages_provider.dart';
import 'package:mukto_mart/providers/order_provider.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/providers/wish_provider.dart';
import 'package:mukto_mart/screens/account/account_screen.dart';
import 'package:mukto_mart/screens/chage_password/change_password_screen.dart';
import 'package:mukto_mart/screens/favourite_seller/favourite_seller_screen.dart';
import 'package:mukto_mart/screens/home/home_screen_page.dart';
import 'package:mukto_mart/screens/my_bulk_orders/my_bulk_order_screen.dart';
import 'package:mukto_mart/screens/my_order/my_order_screen.dart';
import 'package:mukto_mart/screens/wish_list/wish_list_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_menu.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    final CouponProvider couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final CartProvider cartProvider = Provider.of<CartProvider>(context,listen: false);
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final WishProvider wishProvider = Provider.of<WishProvider>(context,listen: false);
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context,listen: false);
    final MessagesProvider messagesProvider = Provider.of<MessagesProvider>(context,listen: false);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await profileProvider.fetch(userId);
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              profileProvider.userProfile==null?Icon(
                Icons.account_circle,
                size: 120,
                color: Colors.grey[700],
              ):profileProvider.userProfile.user==null?Icon(
                Icons.account_circle,
                size: 120,
                color: Colors.grey[700],
              ):profileProvider.userProfile.user.photo==null?Icon(
                Icons.account_circle,
                size: 120,
                color: Colors.grey[700],
              ):Container(
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
                    child: Icon(Icons.account_circle,
                        size: 120, color: Colors.grey[700]),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              // ProfilePic(),
              SizedBox(height: 10),
              profileProvider.userProfile == null
                  ? Text('No User')
                  : profileProvider.userProfile.user == null
                      ? Text('No User')
                      : Text(
                          '${profileProvider.userProfile.user.name ?? 'No User'}',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(height: 2),
              profileProvider.userProfile == null
                  ? Text('')
                  : profileProvider.userProfile.user == null
                      ? Text('')
                      : Text('${profileProvider.userProfile.user.email ?? ''}',
                          style: TextStyle(fontSize: 13)),
              SizedBox(height: 20),
              ProfileMenu(
                text: "My Account",
                icon: "assets/icons/User Icon.svg",
                press: () => {
                  profileProvider.userProfile != null
                      ? Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return AccountScreen();
                        }))
                      : _showToast('Please log in first', Colors.redAccent),
                },
              ),
              ProfileMenu(
                text: "My WishList",
                icon: "assets/icons/Heart Icon.svg",
                press: () => {
                  profileProvider.userProfile != null
                      ? Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return WishListScreen();
                        }))
                      : _showToast('Please log in first', Colors.redAccent),
                },
              ),
              ProfileMenu(
                text: "My Favourite seller",
                icon: "assets/icons/Heart Icon.svg",
                press: () => {
                  profileProvider.userProfile != null
                      ? Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return FavouriteSellerScreen();
                        }))
                      : _showToast('Please log in first', Colors.redAccent),
                },
              ),
              ProfileMenu(
                text: "My Orders",
                icon: "assets/icons/Parcel.svg",
                press: () {
                  profileProvider.userProfile != null?
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return MyOrders();
                  })): _showToast('Please log in first', Colors.redAccent);
                },
              ),
              ProfileMenu(
                text: "My Bulk Orders",
                icon: "assets/icons/Parcel.svg",
                press: () {
                  profileProvider.userProfile != null?
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return MyBulkOrders();
                  })): _showToast('Please log in first', Colors.redAccent);
                },
              ),
              ProfileMenu(
                text: "Change Password",
                icon: "assets/icons/Lock.svg",
                press: () {
                  profileProvider.userProfile != null
                      ? Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen()))
                      : _showToast('Please log in first', Colors.redAccent);
                },
              ),
              ProfileMenu(
                text: "Help Center",
                icon: "assets/icons/Question mark.svg",
                press: () {},
              ),
              ProfileMenu(
                text: "Log Out",
                icon: "assets/icons/Log out.svg",
                press: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomeScreenPage()));
                  _showToast('Logged Out', kPrimaryColor);
                },
              ),
            ],
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
