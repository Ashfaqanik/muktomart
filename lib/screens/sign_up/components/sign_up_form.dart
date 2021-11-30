import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/components/custom_surfix_icon.dart';
import 'package:mukto_mart/components/default_button.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/repo/check_phone_repo.dart';
import 'package:mukto_mart/repo/register_repo.dart';
import 'package:mukto_mart/screens/success/success_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String name;
  String phone='';
  String email='';
  String address;
  String password;
  String confirmPassword;
  String _deviceId;
  bool _isLoading=false;
  bool emailSignIn = false;
  bool color=false;
  RegisterRepo registerRepo=new RegisterRepo();
  CheckPhoneRepo checkPhoneRepo=new CheckPhoneRepo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDeviceId();
  }
  Future<void> initDeviceId() async {
    String deviceid;

    deviceid = await PlatformDeviceId.getDeviceId;

    if (!mounted) return;

    setState(() {
      _deviceId = '$deviceid';
    });
  }
  Future<bool> loginUser(String phone, BuildContext context) async{
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: '+88'+phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: (AuthCredential credential) async{
          // Navigator.of(context).pop();
          setState(() {
            _isLoading=false;
          });

          UserCredential result = await _auth.signInWithCredential(credential);

          User user = result.user;

          if(user != null){
            registerRepo.registerPhone(name,phone,address, password,confirmPassword,_deviceId).then((response) {
              if(response['status']==true){

                Navigator.pushNamed(context, RegistrationSuccessScreen.routeName);
                _showToast('Registration Succeed',kPrimaryColor);
              }else{
                Navigator.of(context).pop();
                _showToast('Registration failed',Colors.redAccent);
              }
            });
          }else{
            print("Error");
          }

          //This callback would gets called when verification is done automatically
        },
        verificationFailed: (FirebaseAuthException exception){
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]){
          setState(() {
            _isLoading=false;
          });
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  contentPadding: EdgeInsets.all(20),
                  title: Text("Phone Verification", textAlign: TextAlign.center),
                  content: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Container(
                          child: Text(
                            "We've sent OTP verification code on your given number.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        SizedBox(height: 25),
                        TextField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Enter OTP here",
                              fillColor: Colors.grey[100],
                              prefixIcon: Icon(Icons.security)),
                        ),
                        SizedBox(height: 10),
                        FlatButton(
                          child: Text("Confirm"),
                          textColor: Colors.white,
                          color: color==false?Colors.blue:Colors.grey,
                          onPressed: () async{
                            setState(() {
                              color=true;
                            });
                            //Navigator.of(context).pop();
                            final code = _codeController.text.trim();
                            AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);

                            UserCredential result = await _auth.signInWithCredential(credential);

                            User user = result.user;

                            if(user != null){
                              registerRepo.registerPhone(name,phone,address, password,confirmPassword,_deviceId).then((response) {
                                if(response['status']==true){

                                  Navigator.pushNamed(context, RegistrationSuccessScreen.routeName);
                                  _showToast('Registration Succeed',kPrimaryColor);
                                }else{

                                  Navigator.of(context).pop();
                                  _showToast('Registration failed',Colors.redAccent);
                                }
                              });
                            }else{
                              print("Error");
                            }
                          },
                        ),
                        SizedBox(height: 15),
                        Text('OTP will expired after 2 minutes ',style: TextStyle(fontSize: 14,color: Colors.grey[600]))
                      ],
                    ),
                  ),
                );
              }
          );
        },
        codeAutoRetrievalTimeout: null
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    checkPhoneRepo.getPhone(phone);
    return _isLoading?Center(child: CircularProgressIndicator()):Form(
        key: _formKey,
        child: Column(
          children: [
            buildNameFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            emailSignIn==false?buildPhoneFormField():Container(),
            emailSignIn==false?SizedBox(height: getProportionateScreenHeight(30)):Container(),
            emailSignIn==true?buildEmailFormField():Container(),
            emailSignIn==true?SizedBox(height: getProportionateScreenHeight(30)):Container(),
            buildAddressFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildConfirmPassFormField(),
            SizedBox(height: getProportionateScreenHeight(40)),
            DefaultButton(
              text: "Continue",
              press: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  if(emailSignIn==true){
                    if (password.endsWith(confirmPassword)) {
                      setState(() {
                        _isLoading = true;
                      });
                      registerRepo.registerEmail(name,email,address, password,confirmPassword,_deviceId).then((response) {
                        if(response['status']==true){
                          profileProvider.fetchProfileData(email).then((value){
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pushNamed(context, RegistrationSuccessScreen.routeName);
                            _showToast('Registration Succeed',kPrimaryColor);
                          });
                        }else{
                          setState(() {
                            _isLoading = false;
                          });
                          print(response['data']);
                          //Navigator.of(context).pop();
                          _showToast('Registration failed',Colors.redAccent);
                        }
                      });
                    } else {
                      _showToast('Please enter valid confirm password',
                          Colors.redAccent);
                    }
                  }else{
                    if(checkPhoneRepo.exist==0) {
                      if (password.endsWith(confirmPassword)) {
                        setState(() {
                          _isLoading = true;
                        });
                        loginUser(phone, context);
                      } else {
                        _showToast('Please enter valid confirm password',
                            Colors.redAccent);
                      }
                    }else {
                      _showToast('Phone Number already exist',
                          Colors.redAccent);
                    }
                  }
                  }
                }
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            InkWell(
              onTap: (){
                setState(() {
                  emailSignIn==false?emailSignIn=true:emailSignIn=false;
                  //emailSignIn==false?email='':phone='';
                });
              },
                child: emailSignIn==false?Text('Sign Up with Email?',style: TextStyle(color: kPrimaryColor),):
                 Text('Sign Up with Phone?',style: TextStyle(color: kPrimaryColor),))
          ],
        ),
      );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            name = value;
          });
        } else {
          return null;
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter your name";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.perm_identity),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) {
        phone = newValue.trim();

      },
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
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      maxLines: 2,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            address = value;
          });
        } else {
          return null;
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter your address";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter your address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.location_on_outlined),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && emailValidatorRegExp.hasMatch(value)) {
          setState(() {
            email = value;
          });
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter your email";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return "Please Enter Valid Email";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.email_outlined),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && value.length >= 8) {
          setState(() {
            password = value;
          });
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter your password";
        } else if (value.length < 8) {
          return "Password is too short";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildConfirmPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            confirmPassword = value;
          });
        } else if (value.isNotEmpty && password == confirmPassword) {
          setState(() {
            confirmPassword = value;
          });
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter confirm your password";
        } else if ((password != value)) {
          return "Passwords doesn't matched";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
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
