import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mukto_mart/components/sale_product_card_home.dart';
import 'package:mukto_mart/providers/sale_products_provider.dart';
import 'package:mukto_mart/screens/all_products/sale_products_screen.dart';
import 'package:mukto_mart/screens/home/components/section_title.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';

class SaleProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SaleProductsProvider provider = Provider.of<SaleProductsProvider>(context);

    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Sale Products", press: () {
            provider.saleProducts!=null?provider.saleProducts.data.isNotEmpty?Navigator.push(context, MaterialPageRoute(builder: (_) {
              return SaleProductsScreen(name: "Sale Products",);  })):null:null;
          }),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: new ClampingScrollPhysics(),
          itemCount: provider.saleProducts==null?0:provider.saleProducts.data==null?0:provider.saleProducts.data.length<4?provider.saleProducts.data.length:4,
          crossAxisCount: 2,
          itemBuilder: (BuildContext context, int index) {
            // if (demoProducts[index].isPopular)
            return SaleProductCardHome(product: provider.saleProducts.data[index]);
            // return SizedBox
            //     .shrink(); // here by default width and height is 0
          },
          staggeredTileBuilder: (int index) =>
          new StaggeredTile.fit(1),
          mainAxisSpacing: 6.0,

        ),
        // GridView.builder(
        //   shrinkWrap: true,
        //   physics: new ClampingScrollPhysics(),
        //   itemCount: provider.saleProducts==null?0:provider.saleProducts.data==null?0:provider.saleProducts.data.length<4?provider.saleProducts.data.length:4,
        //   gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 6,childAspectRatio: 7.4/9),
        //   itemBuilder: (BuildContext context, int index) {
        //     // if (demoProducts[index].isPopular)
        //     return SaleProductCardHome(product: provider.saleProducts.data[index]);
        //     // return SizedBox
        //     //     .shrink(); // here by default width and height is 0
        //   },
        // ),
        //SizedBox(width: getProportionateScreenWidth(20)),
      ],
    );
  }
}
