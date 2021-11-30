import 'package:flutter/material.dart';
import 'package:mukto_mart/models/details_model.dart';
import 'package:mukto_mart/providers/details_provider.dart';
import 'package:mukto_mart/providers/wish_provider.dart';
import 'package:mukto_mart/screens/home/home_screen_page.dart';
import 'package:provider/provider.dart';
import 'all_product_components/all_product_body.dart';

class AllDetailsScreen extends StatefulWidget {
  final ProductDetails productDetails;
  final bool favourite;
  final int productId;

  AllDetailsScreen({@required this.productDetails,this.favourite,this.productId});
  static String routeName = "/details";

  @override
  _AllDetailsScreenState createState() => _AllDetailsScreenState();
}

class _AllDetailsScreenState extends State<AllDetailsScreen> {
  bool isFavourite=false;
  @override
  void dispose() {
    super.dispose();
    _onBackPressed();
  }
  @override
  Widget build(BuildContext context) {
    final DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context,listen: false);
    final WishProvider wishProvider = Provider.of<WishProvider>(context,listen: false);
    if(wishProvider.Idlist!=null){
      if(wishProvider.Idlist.contains(widget.productId)){
        setState(() {
          isFavourite=true;
        });
      }
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: () {
            //Navigator.pushNamedAndRemoveUntil(context, MainPage.routeName,(Route<dynamic> route) => false);
            if(detailsProvider.backed==3) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  HomeScreenPage()), (Route<dynamic> route) => false);
              detailsProvider.backed=0;
            }else {
              Navigator.pop(context);
              detailsProvider.backed++;
            }
          },),
        ),
        backgroundColor: Color(0xFFF5F6F9),
        // appBar: CustomAppBar(rating: product.rating),
        body: AllProductBody(productDetails: widget.productDetails,favourite: isFavourite,productId: widget.productId,),
      ),
    );
   }

  Future<bool> _onBackPressed() async {
    final DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context,listen: false);
    //Navigator.pushNamedAndRemoveUntil(context, MainPage.routeName,(Route<dynamic> route) => false);
    if(detailsProvider.backed==3) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          HomeScreenPage()), (Route<dynamic> route) => false);
      detailsProvider.backed=0;
    }else {
      Navigator.pop(context);
      detailsProvider.backed++;
    }

  }
}
