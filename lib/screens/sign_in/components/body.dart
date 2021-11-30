import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mukto_mart/components/no_account_text.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/repo/check_phone_repo.dart';
import 'package:mukto_mart/repo/profile_repo.dart';
import 'package:mukto_mart/repo/register_repo.dart';
import 'package:mukto_mart/screens/home/home_screen_page.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_form.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  CheckPhoneRepo checkPhoneRepo = new CheckPhoneRepo();
  RegisterRepo registerRepo = new RegisterRepo();
  ProfileRepo profileRepo = new ProfileRepo();
  bool _isLoading = false;
  String _deviceId;

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

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Text(
                      "Welcome",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(28),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Sign in with your phone and password",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.08),
                    SignForm(),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    NoAccountText(),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    Text('or sign in with'),
                    SizedBox(height: getProportionateScreenHeight(10)),

                    ///Social Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            // setState(() {
                            //   _isLoading=true;
                            // });
                            signInWithFacebook(
                                checkPhoneRepo, registerRepo, profileProvider);
                          },
                          child: Container(
                            height: 38,
                            width: 38,
                            child: Image.asset("assets/images/facebook.png"),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(width: getProportionateScreenHeight(15)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isLoading = true;
                            });
                            signInWithGoogle(checkPhoneRepo, registerRepo,
                                profileProvider, profileRepo);
                          },
                          child: Container(
                            height: 33,
                            width: 33,
                            child: Image.asset("assets/images/google.png"),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          _isLoading ? Center(child: CircularProgressIndicator()) : Container()
        ],
      ),
    );
  }

  Future<User> signInWithGoogle(
      CheckPhoneRepo checkPhoneRepo,
      RegisterRepo registerRepo,
      ProfileProvider profileProvider,
      ProfileRepo profileRepo) async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    //showLoadingDialog('please wait');
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    UserCredential cred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (cred.user.phoneNumber == null) {
      profileRepo.getProfileResponseByEmail(cred.user.email).then((response) {
        if (profileRepo.responses.statusCode == 200) {
          profileProvider
              .fetchProfileDataByEmail(cred.user.email)
              .then((value) {
            _Pref(profileProvider.userProfile.user.id,
                profileProvider.userProfile.user.apiToken);
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomeScreenPage()));
            _showToast('You\'re logged in', kPrimaryColor);
          });
        } else {
          registerRepo
              .registerEmail(
                  cred.user.displayName, cred.user.email, '', '', '', _deviceId)
              .then((response) {
            if (response['status'] == true) {
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreenPage()));
              _showToast('You\'re logged in', kPrimaryColor);
            } else {
              Navigator.of(context).pop();
              setState(() {
                _isLoading = false;
              });
              _showToast('Sign in failed', Colors.redAccent);
            }
          });
        }
      });
    } else {
      checkPhoneRepo.getPhone(cred.user.phoneNumber).then((value) {
        if (checkPhoneRepo.exist == 0) {
          registerRepo
              .registerPhone(cred.user.displayName, cred.user.phoneNumber, '',
                  '', '', _deviceId)
              .then((response) {
            if (response['status'] == true) {
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreenPage()));
              _showToast('You\'re logged in', kPrimaryColor);
            } else {
              Navigator.of(context).pop();
              setState(() {
                _isLoading = false;
              });
              _showToast('Sign in failed', Colors.redAccent);
            }
          });
        } else {
          profileProvider.fetchProfileData(cred.user.phoneNumber).then((value) {
            _Pref(profileProvider.userProfile.user.id,
                    profileProvider.userProfile.user.apiToken)
                .then((value) {
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreenPage()));
              _showToast('You\'re logged in', kPrimaryColor);
            });
          });
        }
      });
    }
    //closeLoadingDialog();
    print('Success with: ${cred.user.email}');
    return cred.user;
  }

  Future<User> signInWithFacebook(CheckPhoneRepo checkPhoneRepo,
      RegisterRepo registerRepo, ProfileProvider profileProvider) async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    //Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken.token);

    // Once signed in, return the UserCredential
    UserCredential cred = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    if (cred.user.phoneNumber == null) {
      profileRepo.getProfileResponseByEmail(cred.user.email).then((response) {
        if (profileRepo.responses.statusCode == 200) {
          profileProvider
              .fetchProfileDataByEmail(cred.user.email)
              .then((value) {
            _Pref(profileProvider.userProfile.user.id,
                    profileProvider.userProfile.user.apiToken)
                .then((value) {
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreenPage()));
              _showToast('You\'re logged in', kPrimaryColor);
            });
          });
        } else {
          registerRepo
              .registerEmail(
                  cred.user.displayName, cred.user.email, '', '', '', _deviceId)
              .then((response) {
            if (response['status'] == true) {
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreenPage()));
              _showToast('You\'re logged in', kPrimaryColor);
            } else {
              Navigator.of(context).pop();
              setState(() {
                _isLoading = false;
              });
              _showToast('Sign in failed', Colors.redAccent);
            }
          });
        }
      });
    } else {
      checkPhoneRepo.getPhone(cred.user.phoneNumber).then((value) {
        if (checkPhoneRepo.exist == 0) {
          registerRepo
              .registerPhone(cred.user.displayName, cred.user.phoneNumber, '',
                  '', '', _deviceId)
              .then((response) {
            if (response['status'] == true) {
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreenPage()));
              _showToast('You\'re logged in', kPrimaryColor);
            } else {
              Navigator.of(context).pop();
              setState(() {
                _isLoading = false;
              });
              _showToast('Sign in failed', Colors.redAccent);
            }
          });
        } else {
          profileProvider.fetchProfileData(cred.user.phoneNumber).then((value) {
            _Pref(profileProvider.userProfile.user.id,
                    profileProvider.userProfile.user.apiToken)
                .then((value) {
              setState(() {
                _isLoading = false;
              });
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeScreenPage()));
              _showToast('You\'re logged in', kPrimaryColor);
            });
          });
        }
      });
    }
    print("Success with: ${cred.user.email}, ${cred.user.displayName}");

    return cred.user;
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

  Future<void> _Pref(int id, String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('userId', '$id');
    pref.setString('api_token', token);
  }
}
