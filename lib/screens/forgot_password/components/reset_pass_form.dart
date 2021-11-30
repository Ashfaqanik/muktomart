import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/components/default_button.dart';
import 'package:mukto_mart/helper/keyboard.dart';
import 'package:mukto_mart/repo/forgot_password_repo.dart';
import 'package:mukto_mart/screens/home/home_screen_page.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';

class ResetPassForm extends StatefulWidget {
  String resetKey;

  ResetPassForm({this.resetKey});

  @override
  _ResetPassFormState createState() => _ResetPassFormState();
}

class _ResetPassFormState extends State<ResetPassForm> {
  ForgotPasswordRepo forgotPasswordRepo = new ForgotPasswordRepo();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String newPass, renewPass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  TextFormField(
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
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  TextFormField(
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
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.1),
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
                                forgotPasswordRepo.resetPass(
                                    widget.resetKey, newPass, renewPass);
                            response.then((response) {
                              print(response);
                              if (response['status'] == true) {
                                KeyboardUtil.hideKeyboard(context);
                                _showToast('Your Password changed successfully',
                                    kPrimaryColor);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomeScreenPage()));
                              } else {
                                _showToast('Failed', Colors.redAccent);
                              }
                            });
                          } else {
                            _showToast(
                                'Passwords doesn\'t matched', Colors.redAccent);
                          }
                        } else {
                          _showToast(
                              'Please Enter new password', Colors.redAccent);
                        }
                      }),
                  SizedBox(height: SizeConfig.screenHeight * 0.1),
                ],
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
}
