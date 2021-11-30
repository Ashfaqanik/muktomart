import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/helper/keyboard.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/repo/login_repo.dart';
import 'package:mukto_mart/screens/forgot_password/forgot_password_screen.dart';
import 'package:mukto_mart/screens/home/home_screen_page.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import '../../../components/default_button.dart';

class SignForm extends StatefulWidget {

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  String phone;
  String password;
  bool _isLoading=false;
  bool remember = false;
  final List<String> errors = [];
  LoginRepo loginRepo=new LoginRepo();

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Column(
            children: [
              buildPhoneFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildPasswordFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Checkbox(
                  //   value: remember,
                  //   activeColor: kPrimaryColor,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       remember = value;
                  //     });
                  //   },
                  // ),
                  // Text("Remember me"),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, ForgotPasswordScreen.routeName),
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(decoration: TextDecoration.underline,color: kPrimaryColor),
                    ),
                  )
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              DefaultButton(
                text: "Continue",
                press: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
                      _isLoading=true;
                    });
                    final Future<Map<String,dynamic>> response =  loginRepo.login(phone,password,profileProvider);
                    response.then((response) {
                      print(response);
                      if (response['status']==true) {
                        KeyboardUtil.hideKeyboard(context);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                            HomeScreenPage()));
                        _showToast('You\'re logged in',kPrimaryColor);

                      } else {
                        _showToast('Failed Login',Colors.redAccent);
                      }
                    });


                  }else{
                    _showToast('Please complete the form properly',Colors.redAccent);
                  }
                  },
              ),

            ],
          ),
          _isLoading?Center(child: CircularProgressIndicator()):Container()
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    final size=MediaQuery.of(context).size;
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
          return "Please Enter your password";
         }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        hintStyle: TextStyle(fontSize: size.width*.036),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.lock_outline),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    final size=MediaQuery.of(context).size;
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => phone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && value.length == 11) {
          setState(() {
            phone = value;
          });
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter phone number/Email Address";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number/Email Address",
        hintText: "Enter phone number/Email Address",
        hintStyle: TextStyle(fontSize: size.width*.036),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.phone),
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
