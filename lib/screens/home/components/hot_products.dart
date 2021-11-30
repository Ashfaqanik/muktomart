import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mukto_mart/components/hot_products_card_home.dart';
import 'package:mukto_mart/providers/hot_products_provider.dart';
import 'package:mukto_mart/screens/all_products/hot_products_screen.dart';
import 'package:mukto_mart/screens/home/components/section_title.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';

class HotProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HotProductsProvider provider = Provider.of<HotProductsProvider>(context);

    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Hot Products", press: () {
            provider.hotProducts!=null?provider.hotProducts.data.isNotEmpty?Navigator.push(context, MaterialPageRoute(builder: (_) {
              return HotProductsScreen(name: "Hot Products",);  })):null:null;
          }),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: new ClampingScrollPhysics(),
          itemCount: provider.hotProducts==null?0:provider.hotProducts.data==null?0:provider.hotProducts.data.length<4?provider.hotProducts.data.length:4,
          crossAxisCount: 2,
          itemBuilder: (BuildContext context, int index) {
            // if (demoProducts[index].isPopular)
            return HotProductCardHome(product: provider.hotProducts.data[index]);
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
        //   itemCount: provider.hotProducts==null?0:provider.hotProducts.data==null?0:provider.hotProducts.data.length<4?provider.hotProducts.data.length:4,
        //   gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 6,childAspectRatio: 7.4/9),
        //   itemBuilder: (BuildContext context, int index) {
        //     // if (demoProducts[index].isPopular)
        //     return HotProductCardHome(product: provider.hotProducts.data[index]);
        //     // return SizedBox
        //     //     .shrink(); // here by default width and height is 0
        //   },
        // ),
        //SizedBox(width: getProportionateScreenWidth(20)),
      ],
    );
  }
}
