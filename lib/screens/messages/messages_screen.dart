import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/providers/order_provider.dart';
import 'package:mukto_mart/screens/cart/cart_screen_widget.dart';
import 'package:mukto_mart/screens/home/home_screen.dart';
import 'package:mukto_mart/screens/my_order/components/order_card.dart';
import 'package:mukto_mart/screens/notifications/components/notification_card.dart';
import 'package:mukto_mart/screens/profile/profile_screen_widget.dart';
import 'package:mukto_mart/screens/sign_in/sign_in_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chats.dart';
import 'package:mukto_mart/variables/size_config.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String token;
  int _selectedIndex = 1;
  String userId;
  bool _isLoading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(_selectedIndex==3){
      if(userId==''||userId==null){
        Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName,(Route<dynamic> route) => false);
      }
    }

  }
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString('userId');
      token = preferences.getString('api_token');
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    Widget widget = Container(); // default
    switch (_selectedIndex) {
      case 0:
        widget = HomeScreen();
        break;

      case 1:
        widget = tabBarView();
        break;

      case 2:
        widget = CartScreenWidget();
        break;
      case 3:
        userId==''?widget = tabBarView():userId==null?widget =tabBarView():widget =ProfileScreenWidget();
        break;
    }
    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: kSecondaryColor.withOpacity(0.2),
          appBar: _selectedIndex==1?AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicatorColor: kPrimaryColor,
              unselectedLabelColor: kSecondaryColor,
              labelColor: kPrimaryColor,
              labelStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * .032
              ),
              tabs: [
                Tab(icon: Icon(Icons.chat_outlined),text: 'Chats',),
                Tab(icon: Icon(Icons.event_note),text: 'Order',),
                //Tab(icon: Icon(Icons.notifications),text: 'Notification',),
                Tab(icon: Icon(Icons.surround_sound),text: 'Promos',),
              ],
            ),
            title: Text('Messages',style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * .040,color: Colors.black
            ),),
            centerTitle: true,
          ):null,
          body: Stack(
            children: [
              widget,
              _isLoading?Center(child: CircularProgressIndicator()):Container()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon:  Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon:  Icon(Icons.person),
                label: 'Account',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: inActiveIconColor,
            iconSize: MediaQuery.of(context).size.width*.07,
            onTap: _onItemTap,
            elevation: 5
        ),
        ),
      ),
    );
  }
  Future<bool> _onBackPressed() async {
    // if(_selectedIndex==0){
    //   exit(0);
    // }else{
    setState(() {
      _selectedIndex=0;
    });
    //}

    //Navigator.pushNamedAndRemoveUntil(context, MainPage.routeName,(Route<dynamic> route) => false);
  }
  Widget tabBarView(){
    return TabBarView(
      children: [
        Chats(),
        _Order(),
        //_Notifications(),
        _Promos()
      ],
    );
  }

  Widget _Order(){
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context,listen: false);
    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: ()async{
        await orderProvider.fetch(token);
      },
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            height: size.height,
            child: Padding(
              padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
              child: ListView.builder(
                itemCount: orderProvider.orders==null?0:orderProvider.orders.orders==null?0:orderProvider.orders.orders.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),//Color(0xFFFFE6E6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: OrderCard(orders: orderProvider.orders.orders[index]),
                  ),
                ),
              ),
            ),
          ),
          _isLoading?Center(child: CircularProgressIndicator()):Container()
        ],
      ),
    );
  }

  Widget _Notifications(){
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: size.height,
      child: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.1),//Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: NotificationCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _Promos(){
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      height: size.height,
    );
  }

}
