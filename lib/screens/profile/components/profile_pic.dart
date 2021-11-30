import 'dart:convert';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/repo/update_profile_repo.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePic extends StatefulWidget {
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  UpdateProfileRepo updateProfileRepo = UpdateProfileRepo();
  String token;
  String userId;
  File uploadImage;
  bool _isLoading = false;

  Future<void> chooseImage(ProfileProvider profileProvider) async {
    var choosedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      uploadImage = File(choosedImage.path);
    });
    uploadImage != null
        ? upload(profileProvider):null;
  }
  Future<void> upload(ProfileProvider profileProvider)async{
    var fileName = (uploadImage.toString().split('.').last);
    if(fileName=='png\''||fileName=='jpg\''){
      setState(() {
        _isLoading = true;
      });
      List<int> imageBytes = uploadImage.readAsBytesSync();
      String baseImage = base64Encode(imageBytes);
      updateProfileRepo
          .updatePic(baseImage, token)
          .then((value) {
        profileProvider.fetch(userId).then((value) {
          setState(() {
            _isLoading = false;
          });
          _showToast('Photo Updated', kPrimaryColor);
        });
      });
    }else{
      _showToast('Image file need to be png or jpg format', Colors.redAccent);
    }
  }

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('api_token');
      userId = preferences.getString('userId');
    });
  }

  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    uploadImage == null
                        ? profileProvider.userProfile.user.photo == null
                            ? Icon(Icons.account_circle,
                                size: 120, color: Colors.grey[700])
                            : Container(
                                height: 130,
                                width: 130,
                                // decoration: BoxDecoration(
                                //     border: Border.all(
                                //       color: kPrimaryColor,
                                //       width: 1,
                                //     ),
                                //     borderRadius: BorderRadius.circular(55),
                                //     // image: DecorationImage(
                                //     //   fit: BoxFit.cover,
                                //     //   image: NetworkImage(profileProvider
                                //     //       .userProfile.userImage),
                                //     // )
                                // ),
                      child: CachedNetworkImage(
                        imageUrl: profileProvider.userProfile.userImage,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.account_circle,
                              size: 120, color: Colors.grey[700]),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                              )
                        : Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: kPrimaryColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(55),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(uploadImage),
                                )),
                          ),
                    Positioned(
                      right: -16,
                      bottom: 0,
                      child: SizedBox(
                        height: 46,
                        width: 46,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.white),
                          ),
                          color: Color(0xFFF5F6F9),
                          onPressed: () {
                            chooseImage(profileProvider);
                          },
                          child:
                              SvgPicture.asset("assets/icons/Camera Icon.svg"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
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
