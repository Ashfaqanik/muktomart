import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String routeName = "/forgot_password";

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: () {
              Navigator.pop(context);
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
            //   return MainPage();  }));
          },),
          title: Text("Change Password",style: TextStyle(color: Colors.black)),
        ),
        body: Body(),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
    //   return MainPage();  }));
  }
}
