import 'package:flutter/material.dart';
import 'package:mukto_mart/screens/home/home_screen_page.dart';
import 'components/body.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign_in";

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                HomeScreenPage()), (Route<dynamic> route) => false);
          },),
          title: Text("Sign In",style: TextStyle(color: Colors.black)),
        ),
        body: Body(),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        HomeScreenPage()), (Route<dynamic> route) => false);  }
}
