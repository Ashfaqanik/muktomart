import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mukto_mart/components/featured_product_card_home.dart';
import 'package:mukto_mart/providers/featured_products_provider.dart';
import 'package:mukto_mart/screens/all_products/featured_products_screen.dart';
import 'package:mukto_mart/screens/home/components/section_title.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';

class FeaturedProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FeaturedProductsProvider provider = Provider.of<FeaturedProductsProvider>(context);

    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Featured Products", press: () {
            provider.featuredProducts!=null?provider.featuredProducts.data.isNotEmpty?Navigator.push(context, MaterialPageRoute(builder: (_) {
              return FeaturedProductsScreen(name: "Featured Products",);  })):null:null;
          }),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: new ClampingScrollPhysics(),
          itemCount: provider.featuredProducts==null?0:provider.featuredProducts.data==null?0:provider.featuredProducts.data.length<4?provider.featuredProducts.data.length:4,
          crossAxisCount: 2,
          itemBuilder: (BuildContext context, int index) {
            // if (demoProducts[index].isPopular)
            return FeaturedProductCardHome(product: provider.featuredProducts.data[index]);
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
        //   itemCount: provider.featuredProducts==null?0:provider.featuredProducts.data==null?0:provider.featuredProducts.data.length<4?provider.featuredProducts.data.length:4,
        //   gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 6,childAspectRatio: 7.4/9),
        //   itemBuilder: (BuildContext context, int index) {
        //     // if (demoProducts[index].isPopular)
        //     return FeaturedProductCardHome(product: provider.featuredProducts.data[index]);
        //     // return SizedBox
        //     //     .shrink(); // here by default width and height is 0
        //   },
        // ),
        //SizedBox(width: getProportionateScreenWidth(20)),
      ],
    );
  }
}
