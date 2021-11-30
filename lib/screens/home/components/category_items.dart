import 'package:flutter/material.dart';
import 'package:mukto_mart/providers/categories_provider.dart';
import 'package:mukto_mart/screens/categories/categories_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mukto_mart/screens/categories/home_categories_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'section_title.dart';

class CategoryItems extends StatefulWidget {
  const CategoryItems({
    Key key,
  }) : super(key: key);

  @override
  _CategoryItemsState createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems> {
  @override
  Widget build(BuildContext context) {
    final CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context);

    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "Categories",
            press: () {
              categoriesProvider.subCategories!=null?Navigator.push(context, MaterialPageRoute(builder: (_) {
                return CategoriesScreen();  })):null;
            },
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        Container(
          color: kSecondaryColor.withOpacity(0.1),
          child: GridView.builder(
            shrinkWrap: true,
            physics: new ClampingScrollPhysics(),//provider.list.isNotEmpty?provider.list.length<6?provider.list.length:6:0,
            itemCount: categoriesProvider.homeCategories!=null?categoriesProvider.homeCategories.length<8?categoriesProvider.homeCategories.length:8:0,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,mainAxisSpacing: 8,childAspectRatio: 8/9),
            itemBuilder: (BuildContext context, int index) {
              return categoriesProvider.homeCategories!=null?SpecialOfferCard(catId: categoriesProvider.homeCategories[index].id,
                  subCatId: categoriesProvider.homeCategories[index].subcat,category: categoriesProvider.homeCategories[index].nameBn,
                  image: categoriesProvider.homeCategories[index].image):Container();
            },
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key key,
    @required this.catId,
    @required this.subCatId,
    @required this.category,
    @required this.image,
  }) : super(key: key);

  final String category, image;
  final int catId,subCatId;

  @override
  Widget build(BuildContext context) {
    final CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context);

    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
      child: SizedBox(
        width: getProportionateScreenWidth(140),
        child: GestureDetector(
          onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeCategoriesScreen(
                name: category, categoryId: catId, subCategoryId: subCatId,)));
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: Container(
                    padding: EdgeInsets.all(getProportionateScreenWidth(6)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Hero(
                      tag: catId,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                        fit: BoxFit.fill,
                      )//Image.network(image,fit: BoxFit.fitHeight,),
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    category,
                    style: TextStyle(color: Colors.black,fontSize: 10.8),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
