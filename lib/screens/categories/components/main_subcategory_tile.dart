import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/providers/categories_provider.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:provider/provider.dart';

class MainSubcategoryTile extends StatefulWidget {
  int index;
  MainSubcategoryTile({this.index});

  @override
  _MainSubcategoryTileState createState() => _MainSubcategoryTileState();
}

class _MainSubcategoryTileState extends State<MainSubcategoryTile> {
  @override
  Widget build(BuildContext context) {
    final CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context,listen: false);
    final Size size = MediaQuery.of(context).size;
    return Container(
        // height: size.width*.15,
        // width: size.width*.15,
      //margin: EdgeInsets.only(right: 10,left: 10),
      decoration: BoxDecoration(
          color: kSecondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Image.network(categoriesProvider.subCategories[widget.index].photo,fit: BoxFit.fitWidth,)
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Center(
                child: Text(categoriesProvider.subCategories[widget.index].nameBn,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kSecondaryColor,fontSize: size.width*.028,fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}