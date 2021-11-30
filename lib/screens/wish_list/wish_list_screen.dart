import 'package:flutter/material.dart';
import 'package:mukto_mart/providers/wish_provider.dart';
import 'package:provider/provider.dart';
import 'components/body.dart';

class WishListScreen extends StatefulWidget {
  static String routeName = "/wishList";

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    final WishProvider wishProvider = Provider.of<WishProvider>(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: buildAppBar(context,wishProvider),
        body: Column(
          children: [
            Expanded(child: Body()),
          ],
        ),
        // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.favourite),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
    //   return MainPage();  }));
  }

  AppBar buildAppBar(BuildContext context,WishProvider wishProvider) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () {
        Navigator.pop(context);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        //   return MainPage();  }));
      },),
      title: Column(
        children: [
          Text(
            "Your WishList",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            wishProvider.wishlists == null
                ? "0 items":wishProvider.wishlists.wishlist==null?'0 items'
                : "${wishProvider.wishlists.wishlist.length} items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
