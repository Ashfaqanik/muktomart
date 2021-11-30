import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/screens/account/components/body.dart';
import 'package:mukto_mart/screens/profile/profile_screen.dart';

class AccountScreen extends StatefulWidget {
  static String routeName = "/account";

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              return ProfileScreen();  }));
          },),
          title: Text("My Account",style: TextStyle(color: Colors.black)),
        ),
        body: Body(),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    //Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
      return ProfileScreen();  }));
  }
}
