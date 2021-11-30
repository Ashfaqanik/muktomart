import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/components/default_button.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/repo/check_phone_repo.dart';
import 'package:mukto_mart/repo/update_profile_repo.dart';
import 'package:mukto_mart/screens/account/account_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  int count=0;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  CheckPhoneRepo checkPhoneRepo=new CheckPhoneRepo();
  UpdateProfileRepo updateProfileRepo=new UpdateProfileRepo();
  String name;
  String phone;
  String email;
  String address;
  bool _isLoading=false;
  String token;
  String userId;
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('api_token');
      userId = preferences.getString('userId');
    });
  }
  void _initialize(ProfileProvider profileProvider){
    _nameController.text=profileProvider.userProfile.user.name;
    _emailController.text=profileProvider.userProfile.user.email;
    _phoneController.text=profileProvider.userProfile.user.phone;
    _addressController.text=profileProvider.userProfile.user.address;
    setState(() => count++);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }
  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    if (count == 0) _initialize(profileProvider);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Update Profile',style: TextStyle(color: Colors.black),),
            leading: IconButton(
                icon: Icon(Icons.arrow_back), onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                return AccountScreen();  }));
    }),
        ),
        body: _isLoading?Center(child: CircularProgressIndicator()):Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: ListView(
              children: [

                buildNameFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildPhoneFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildEmailFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildAddressFormField(),
                SizedBox(height: getProportionateScreenHeight(40)),
                DefaultButton(
                  text: "Update",
                  press: () {
                    checkPhoneRepo.getPhone(phone);
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        _isLoading=true;
                      });
                      if(phone!=profileProvider.userProfile.user.phone){
                        if(checkPhoneRepo.exist == 0 ){
                          setState(() {
                            _isLoading=false;
                          });
                          _showToast('Phone Number already exist', Colors.redAccent);
                        }else{
                          updateProfileRepo.update(name, email, phone, address, token).then((value){
                            setState(() {
                              _isLoading=false;
                            });
                            _showToast('Details Updated successfully', kPrimaryColor);
                            profileProvider.fetch(userId).then((value){
                              Navigator.push(context, MaterialPageRoute(builder: (_) {
                                return AccountScreen();  }));
                            });

                          });
                        }
                      }else{
                        updateProfileRepo.update(name, email, profileProvider.userProfile.user.phone, address, token).then((value){
                          setState(() {
                            _isLoading=false;
                          });
                          _showToast('Details Updated successfully', kPrimaryColor);
                          profileProvider.fetch(userId).then((value){
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return AccountScreen();  }));
                          });
                        });
                      }
                    }
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<bool> _onBackPressed() async {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return AccountScreen();  }));
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
          setState(() {
            name=_nameController.text;
          });

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
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) {
        phone = newValue.trim();

      },
      onChanged: (value) {
        setState(() {
          phone=_phoneController.text;
        });
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
      controller: _addressController,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        setState(() {
          address=_addressController.text;
        });
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
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
          setState(() {
            email=_emailController.text;
          });
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
