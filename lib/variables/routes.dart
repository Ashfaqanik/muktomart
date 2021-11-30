import 'package:flutter/widgets.dart';
import 'package:mukto_mart/screens/account/account_screen.dart';
import 'package:mukto_mart/screens/cart/cart_screen.dart';
import 'package:mukto_mart/screens/forgot_password/forgot_password_screen.dart';
import 'package:mukto_mart/screens/home/home_screen.dart';
import 'package:mukto_mart/screens/profile/profile_screen.dart';
import 'package:mukto_mart/screens/sign_in/sign_in_screen.dart';
import 'package:mukto_mart/screens/sign_up/sign_up_screen.dart';
import 'package:mukto_mart/screens/splash/splash_screen.dart';
import 'package:mukto_mart/screens/success/success_screen.dart';
import 'package:mukto_mart/screens/wish_list/wish_list_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  RegistrationSuccessScreen.routeName: (context) => RegistrationSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  WishListScreen.routeName: (context) => WishListScreen(),
  AccountScreen.routeName: (context) => AccountScreen(),
};
