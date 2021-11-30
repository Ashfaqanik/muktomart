import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/models/order_details_model.dart';
import 'package:mukto_mart/providers/order_provider.dart';
import 'package:mukto_mart/screens/cart/cart_screen_widget.dart';
import 'package:mukto_mart/screens/home/home_screen.dart';
import 'package:mukto_mart/screens/my_order/components/order_card.dart';
import 'package:mukto_mart/screens/notifications/components/notification_card.dart';
import 'package:mukto_mart/screens/profile/profile_screen.dart';
import 'package:mukto_mart/screens/sign_in/sign_in_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chats.dart';
import 'package:mukto_mart/variables/size_config.dart';

class MessagesScreenWidget extends StatefulWidget {
  @override
  _MessagesScreenWidgetState createState() => _MessagesScreenWidgetState();
}

class _MessagesScreenWidgetState extends State<MessagesScreenWidget> {
  String token;
  bool _isLoading=false;
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

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context,listen: false);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: kSecondaryColor.withOpacity(0.2),
        appBar: AppBar(
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
        ),
        body: TabBarView(
          children: [
            Chats(),
            _Order(),
            //_Notifications(),
            _Promos()
          ],
        ),
      ),
    );
  }

  Widget _Order(){
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context,listen: false);

    return RefreshIndicator(
      onRefresh: ()async{
        await orderProvider.fetch(token);
      },
      child: Stack(
        children: [
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: ListView.builder(
              itemCount: orderProvider.orders==null?0:orderProvider.orders.orders==null?0:orderProvider.orders.orders.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),//Color(0xFFFFE6E6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: OrderCard(orders: orderProvider.orders.orders[index]),
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

    return Padding(
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
    );
  }

  Widget _Promos(){

    return Container(

    );
  }

}
