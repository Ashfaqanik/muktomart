import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/components/default_button.dart';
import 'package:mukto_mart/helper/keyboard.dart';
import 'package:mukto_mart/repo/forgot_password_repo.dart';
import 'package:mukto_mart/screens/forgot_password/components/reset_pass_form.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your phone number/email address and we will send \nyou a key to reset your password",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _keyController = TextEditingController();

  ForgotPasswordRepo forgotPasswordRepo = new ForgotPasswordRepo();
  bool _isLoading = false;
  bool emailReset = false;
  final _formKey = GlobalKey<FormState>();
  String phone;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Form(
            key: _formKey,
            child: Column(
              children: [
                emailReset==false?TextFormField(
                  keyboardType: TextInputType.phone,
                  onSaved: (newValue) => phone = newValue.trim(),
                  onChanged: (value) {
                    if (value.isNotEmpty && value.length == 11) {
                      setState(() {
                        phone = value.trim();
                      });
                    }
                    return null;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please Enter your phone number";
                    } else if (value.length != 11) {
                      return "Phone Number must be of 11 digits";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "Enter your phone number",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(Icons.phone),
                  ),
                ):Container(),
                emailReset==true?TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (newValue) => phone = newValue.trim(),
                  onChanged: (value) {
                    if (value.isNotEmpty && emailValidatorRegExp.hasMatch(value)) {
                      setState(() {
                        phone = value.trim();
                      });
                    }
                    return null;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please Enter your email Address";
                    } else if (!emailValidatorRegExp.hasMatch(value)) {
                      return "Please Enter Valid Email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    hintText: "Enter your email address",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(Icons.phone),
                  ),
                ):Container(),
                SizedBox(height: getProportionateScreenHeight(30)),
                SizedBox(height: SizeConfig.screenHeight * 0.09),
                DefaultButton(
                    text: "Continue",
                    press: () {

                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        setState(() {
                          _isLoading = true;
                        });
                        final Future<Map<String, dynamic>> response =
                            forgotPasswordRepo.sendToken(phone);
                        response.then((response) {
                          print(response);
                          if (response['status'] == true) {
                            KeyboardUtil.hideKeyboard(context);
                            emailReset==false?_showToast(
                                'Your Password reset key has sent to your mobile',
                                kPrimaryColor):_showToast(
                                'Your Password reset key has sent to your email',
                                kPrimaryColor);
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    scrollable: true,
                                    contentPadding: EdgeInsets.all(20),
                                    title: Text("Password reset key",
                                        textAlign: TextAlign.center),
                                    content: Container(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 25),
                                          TextField(
                                            controller: _keyController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Enter reset key here",
                                                fillColor: Colors.grey[100],
                                                prefixIcon:
                                                    Icon(Icons.security)),
                                          ),
                                          SizedBox(height: 10),
                                          FlatButton(
                                            child: Text("Confirm"),
                                            textColor: Colors.white,
                                            color: Colors.blue,
                                            onPressed: () async {
                                              //Navigator.of(context).pop();
                                              if(_keyController.text.isNotEmpty){
                                                final key =
                                                _keyController.text.trim();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ResetPassForm(
                                                            resetKey: key,
                                                          )),
                                                );
                                              }else{
                                                _showToast('Enter reset key', Colors.redAccent);
                                              }
                                            },
                                          ),
                                          SizedBox(height: 15),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            _showToast('Failed', Colors.redAccent);
                          }
                        });
                      } else {
                        _showToast(
                            'Please Enter Phone Number', Colors.redAccent);
                      }
                    }),
                SizedBox(height: 15),
                InkWell(
                    onTap: (){
                      setState(() {
                        emailReset==false?emailReset=true:emailReset=false;
                        //emailSignIn==false?email='':phone='';
                      });
                    },
                    child: emailReset==false?Text('Reset Password with Email?',style: TextStyle(color: kPrimaryColor),):
                    Text('Reset Password with Phone?',style: TextStyle(color: kPrimaryColor,decoration: TextDecoration.underline),))
              ],
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
