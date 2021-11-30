import 'package:flutter/material.dart';
import 'package:mukto_mart/components/product_card.dart';
import 'package:mukto_mart/providers/popular_products_provider.dart';
import 'package:mukto_mart/screens/all_products/popular_products_screen.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PopularProductsProvider provider = Provider.of<PopularProductsProvider>(context);

    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Popular Products", press: () {
            provider.popularProducts!=null?provider.popularProducts.data.isNotEmpty?Navigator.push(context, MaterialPageRoute(builder: (_) {
              return PopularProductsScreen(name: 'Popular Products',);  })):null:null;
          }),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                provider.popularProducts!=null?provider.popularProducts.data!=null?provider.popularProducts.data.isNotEmpty?7:0:0:0,
                (index) {
                    return ProductCard(product: provider.popularProducts.data[index]);

                  return SizedBox
                      .shrink(); // here by default width and height is 0
                },
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        )
      ],
    );
  }
}
