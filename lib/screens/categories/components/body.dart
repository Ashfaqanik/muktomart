import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mukto_mart/providers/banner_provider.dart';
import 'package:mukto_mart/providers/categories_provider.dart';
import 'package:mukto_mart/screens/categories/components/category_products.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:provider/provider.dart';
import 'main_subcategory_tile.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isLoading=false;

  @override
  Widget build(BuildContext context) {
    final CategoriesProvider categoriesProvider =
        Provider.of<CategoriesProvider>(context);
    final BannerProvider bannerProvider = Provider.of<BannerProvider>(context);
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: size.width,
        color: kSecondaryColor.withOpacity(0.1),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///SideBar
            Container(
              width: size.width * .24,
              color: Colors.deepPurple[400],
              child: ListView.builder(
                itemCount: categoriesProvider.categories==null?0:categoriesProvider.categories.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _isLoading=true;
                        categoriesProvider.selectedIndex = index;
                        categoriesProvider.fetchSubCategories(
                            categoriesProvider.categories[categoriesProvider.selectedIndex].id).then((value){
                              _isLoading=false;
                        });
                      });
                    },
                    child: Container(
                      color: index == categoriesProvider.selectedIndex
                          ? kPrimaryColor
                          : Colors.deepPurple[400],
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '${categoriesProvider.categories[index].nameBn}',
                        style: TextStyle(
                          fontSize: size.width * .03,
                          fontWeight: index == categoriesProvider.selectedIndex
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            ///Main Page Section
            Container(
              width: size.width * .74,
              color: kSecondaryColor.withOpacity(0.1),
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 4, bottom: 4,right: 4),
                    height: size.height * .20,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: bannerProvider.list!=null?
                        CachedNetworkImage(
                          imageUrl: bannerProvider.list[0].photo.toString(),
                          placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.fill,
                        )//Image.network(bannerProvider.list[0].photo.toString(),fit: BoxFit.fill,)
                            :Image.asset('')),
                  ),
                  _isLoading?Center(child: LinearProgressIndicator()):GridView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 7.2/9,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: categoriesProvider.subCategories==null?0:categoriesProvider.subCategories.isNotEmpty?categoriesProvider.subCategories.length:0,
                      itemBuilder: (context, index) => InkWell(
                          onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategoryProducts(
                                        name: categoriesProvider.subCategories[index].nameBn,
                                        categoryId: categoriesProvider.categories!=null?categoriesProvider.categories[categoriesProvider.selectedIndex].id:'',
                                        subCategoryId: categoriesProvider.subCategories[index].id,
                                      )));
                          },
                          child: MainSubcategoryTile(index: index))),
                ],
              ),
            )
          ],
        ));
  }
}
