import 'package:flutter/material.dart';
import 'package:mukto_mart/providers/all_products_provider.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'search_page.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AllProductsProvider allProductsProvider = Provider.of<AllProductsProvider>(context,listen: false);
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
          return SearchPage();  }),(Route<dynamic> route) => false);

      },
      child: Container(
        width: SizeConfig.screenWidth * 0.72,
        decoration: BoxDecoration(
          color: kSecondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
        ),
         child: Padding(
           padding: const EdgeInsets.all(5.0),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Icon(Icons.search,color:Colors.grey[600],),
               Text("What would you like to buy",style:TextStyle(color:Colors.grey[600],fontSize: size.width*.037),)
             ],
           ),
         )
        // TextField(
        //   // onChanged: (value) => print(value),
        //   decoration: InputDecoration(
        //       contentPadding: EdgeInsets.symmetric(
        //           horizontal: getProportionateScreenWidth(20),
        //           vertical: getProportionateScreenWidth(6)),
        //       border: InputBorder.none,
        //       focusedBorder: InputBorder.none,
        //       enabledBorder: InputBorder.none,
        //       hintText: "What would you like to buy",
        //       hintStyle: TextStyle(fontSize: size.width*.037),
        //       prefixIcon: Icon(Icons.search)),
        // ),
      ),
    );
  }
}
