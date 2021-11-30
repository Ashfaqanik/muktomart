import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mukto_mart/components/top_product_card_home.dart';
import 'package:mukto_mart/providers/top_products_provider.dart';
import 'package:mukto_mart/screens/all_products/top_products_screen.dart';
import 'package:mukto_mart/screens/home/components/section_title.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';

class TopProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TopProductsProvider provider = Provider.of<TopProductsProvider>(context);
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Top Products", press: () {
            provider.topProducts!=null?provider.topProducts.data.isNotEmpty?Navigator.push(context, MaterialPageRoute(builder: (_) {
              return TopProductsScreen(name: "Top Products");  })):null:null;
          }),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: new ClampingScrollPhysics(),
          itemCount: provider.topProducts==null?0:provider.topProducts.data==null?0:provider.topProducts.data.length<4?provider.topProducts.data.length:4,
          crossAxisCount: 2,
          itemBuilder: (BuildContext context, int index) {
            // if (demoProducts[index].isPopular)
            return TopProductCardHome(product: provider.topProducts.data[index]);
            // return SizedBox
            //     .shrink(); // here by default width and height is 0
          },
          staggeredTileBuilder: (int index) =>
          new StaggeredTile.fit(1),
          mainAxisSpacing: 6.0,
          
        ),
        //SizedBox(width: getProportionateScreenWidth(20)),
      ],
    );
  }
  // GridView.builder(
  // shrinkWrap: true,
  // physics: new ClampingScrollPhysics(),
  // itemCount: provider.topProducts==null?0:provider.topProducts.data==null?0:provider.topProducts.data.length<4?provider.topProducts.data.length:4,
  // gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 6,childAspectRatio: 7.4/9),
  // itemBuilder: (BuildContext context, int index) {
  // // if (demoProducts[index].isPopular)
  // return TopProductCardHome(product: provider.topProducts.data[index]);
  // // return SizedBox
  // //     .shrink(); // here by default width and height is 0
  // },
  // ),
}
