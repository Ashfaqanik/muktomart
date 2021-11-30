import 'package:flutter/material.dart';
import 'package:mukto_mart/screens/home/home_screen_page.dart';
import 'components/body.dart';

class ProfileScreenWidget extends StatefulWidget {
  static String routeName = "/profile";

  @override
  _ProfileScreenWidgetState createState() => _ProfileScreenWidgetState();
}

class _ProfileScreenWidgetState extends State<ProfileScreenWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
            return HomeScreenPage();  }),(Route<dynamic> route) => false);
        },),
        title: Text("Profile",style: TextStyle(color: Colors.black)),
      ),
      body: Body(),
    );
  }
}
