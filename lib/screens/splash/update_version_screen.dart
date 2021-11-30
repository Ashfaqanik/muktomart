import 'dart:io';
import 'package:store_redirect/store_redirect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/variables/constants.dart';

class UpdateScreenScreen extends StatefulWidget {
  String running_version;


  UpdateScreenScreen({this.running_version});

  @override
  State<UpdateScreenScreen> createState() => _UpdateScreenScreenState();
}

class _UpdateScreenScreenState extends State<UpdateScreenScreen> {

  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your current app version is ${widget.running_version}'),
              SizedBox(height: 3),
              Text('Please update your app.'),
              SizedBox(height: 5),
              TextButton(
              child: Text("Update"),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: kPrimaryColor
                ), onPressed: () {
                StoreRedirect.redirect(
                  androidAppId:
                  "com.muktomart.mukto_mart",
                );
              },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
      _showDialog();
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
