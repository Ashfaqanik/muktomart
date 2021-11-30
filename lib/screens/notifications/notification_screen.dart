import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/screens/home/home_screen_page.dart';
import 'package:mukto_mart/variables/constants.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName = "/notifications";
  String title, details;

  NotificationScreen({this.title, this.details});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreenPage()));
            },
          ),
          title: Text("Notifications",style: TextStyle(color: Colors.black)),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Container(
            width: size.width * .99,
            height: size.height * .95,
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1), //Color(0xFFFFE6E6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 6),
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        fontSize: size.width * .058),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.details,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[800],
                        fontSize: size.width * .053),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        HomeScreenPage()));
  }
}
