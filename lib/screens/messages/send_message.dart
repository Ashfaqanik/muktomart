import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/repo/message_repo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mukto_mart/providers/messages_provider.dart';

class SendMessage extends StatefulWidget {
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  String token;
  MessagesRepo messageRepo =MessagesRepo();
  bool _isLoading=false;
  String email,subject,message;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('api_token');
    });
  }
  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    final MessagesProvider messegesProvider=Provider.of<MessagesProvider>(context);
    return Stack(
      children: [
        WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back), onPressed: () {
                  Navigator.of(context).pop();
                },),
                title: Text("Send Message"),
              ),
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 8.0),
                  child: ListView(
                    children: [
                      _buildTextForm('Email Address'),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      _buildTextForm('Subject'),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      _buildTextForm('Message'),
                      SizedBox(height: getProportionateScreenHeight(40)),
                      SizedBox(
                        width: double.infinity,
                        height: getProportionateScreenHeight(56),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: kPrimaryColor,
                          onPressed: ()async{
                            setState(() {
                              _isLoading=true;
                            });
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      await messageRepo.addMessage(
                                          token, email, profileProvider.userProfile.user.name,
                                          subject, message).then((value)async{
                                       await messegesProvider.fetch(token).then((value){
                                          setState(() {
                                            _isLoading=false;
                                          });
                                          _showToast('Message sent successfully',
                                              kPrimaryColor);
                                          Navigator.of(context).pop();
                                        });
                                      });
                                    }
                          },
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              )
          ),
        ),
        _isLoading?Center(child: CircularProgressIndicator()):Container()
      ],
    );
  }
  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop();
  }
  void _showToast(String message, Color color) {

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  Widget _buildTextForm(String hint) {
    return TextFormField(
      maxLines: hint == 'Email Address' ? 1 : hint == 'Subject' ? 2:hint == 'Message' ? 4: null,
      initialValue: null,
      decoration: FormDecoration.copyWith(
          //alignLabelWithHint: true,
          hintText: hint,
          fillColor: Color(0xffF4F7F5)),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        if (hint == 'Email Address'){
          setState(() {
            email = value;
          });
        }
        if (hint == 'Subject'){
          setState(() {
            subject = value;
          });
        }
        if (hint == 'Message'){
          setState(() {
            message = value;
          });
        }
      },
      validator: (value) {
        if(hint=='Email Address'){
          if (value.isEmpty) {
            return "Please Enter Email Address";
          }
        }else if(hint=='subject'){
          if (value.isEmpty) {
            return "Please Enter subject";
          }
        }else if(hint=='Message'){
          if (value.isEmpty) {
            return "Please Enter your message";
          }
        }
        return null;
      },
    );
  }
}
