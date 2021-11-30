import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mukto_mart/screens/cart/cart_screen_widget.dart';
import 'package:mukto_mart/screens/home/home_screen.dart';
import 'package:mukto_mart/screens/messages/messages_screen_widget.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'components/body.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
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
        widget = MessagesScreenWidget();
        break;

      case 2:
        widget = CartScreenWidget();
        break;
      case 3:
        widget =Body();
        break;
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: _selectedIndex==3?AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: () {
            setState(() {
              _selectedIndex=0;
            });
          },),
          title: Text("Profile",style: TextStyle(color: Colors.black)),
        ):null,
        body: widget,
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
    );
  }
  Future<bool> _onBackPressed() async {
    if(_selectedIndex==0){
      _showDialog();
    }else{
      setState(() {
        _selectedIndex=0;
      });
    }

    //Navigator.pushNamedAndRemoveUntil(context, MainPage.routeName,(Route<dynamic> route) => false);
  }
  _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {

          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Colors.white,
              scrollable: true,
              contentPadding: EdgeInsets.all(20),
              title: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .030,
                  ),
                  Text(
                    'Do you really want to exit?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .050,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          exit(0);
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
