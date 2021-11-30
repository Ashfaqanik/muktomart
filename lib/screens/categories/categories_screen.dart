import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/providers/categories_provider.dart';
import 'package:provider/provider.dart';
import 'components/body.dart';

class CategoriesScreen extends StatefulWidget {
  static String routeName = "/categories";

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int count=0;

  @override
  Widget build(BuildContext context) {
    final CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context,listen: false);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: () {
            Navigator.pop(context);
            //Navigator.pushNamed(context, MainPage.routeName);
          },),
          title: Text("Categories",style: TextStyle(color: Colors.black)),
        ),
        body: Body(),
      ),
    );
  }
  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    //Navigator.pushNamed(context, MainPage.routeName);
  }
}
