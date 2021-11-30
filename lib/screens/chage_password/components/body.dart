import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/components/default_button.dart';
import 'package:mukto_mart/helper/keyboard.dart';
import 'package:mukto_mart/repo/forgot_password_repo.dart';
import 'package:mukto_mart/screens/home/home_screen_page.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  ForgotPasswordRepo forgotPasswordRepo = new ForgotPasswordRepo();
  String password;
  String newPass, renewPass;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String token;

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('api_token');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.04),
                      Text(
                        "Reset Password",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(28),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Please enter your current password & new password to reset your password",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.1),
                      buildPasswordFormField1(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      buildPasswordFormField2(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      buildPasswordFormField3(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      DefaultButton(
                          text: "Continue",
                          press: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if (newPass.endsWith(renewPass)) {
                                setState(() {
                                  _isLoading = true;
                                });
                                final Future<Map<String, dynamic>> response =
                                    forgotPasswordRepo.changePass(
                                        token, password, newPass, renewPass);
                                response.then((response) {
                                  print(response);
                                  if (response['status'] == true) {
                                    KeyboardUtil.hideKeyboard(context);
                                    _showToast(
                                        'Your Password changed successfully',
                                        kPrimaryColor);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreenPage()));
                                  } else {
                                    _showToast('Failed', Colors.redAccent);
                                  }
                                });
                              } else {
                                _showToast('Passwords doesn\'t matched',
                                    Colors.redAccent);
                              }
                            } else {
                              _showToast('Please fill up the fields',
                                  Colors.redAccent);
                            }
                          }),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void _showToast(String message, Color color) {
    setState(() {
      _isLoading = false;
    });
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  TextFormField buildPasswordFormField1() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            password = value;
          });
        }

        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter your current password";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter current password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.lock_outline),
      ),
    );
  }

  TextFormField buildPasswordFormField2() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => newPass = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            newPass = value;
          });
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter your new password";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter your new password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.lock_outline)),
    );
  }

  TextFormField buildPasswordFormField3() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => renewPass = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            renewPass = value;
          });
        }

        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Confirm Enter your new password";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Confirm your new password",
        //floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.lock_outline),
      ),
    );
  }
}
