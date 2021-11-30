import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/components/category_product_card.dart';
import 'package:mukto_mart/providers/categories_provider.dart';
import 'package:mukto_mart/providers/category_products_provider.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CategoryProducts extends StatefulWidget {
  String name;
  int categoryId, subCategoryId;

  CategoryProducts({this.name, this.categoryId, this.subCategoryId});

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int page = 2;
  bool _isLoading = true;
  int _selectedIndex = 0;
  int _count = 0;
  bool _isLoading1=false;

  Future<void> fetch(CategoriesProvider categoriesProvider,CategoryProductsProvider categoryProductsProvider)async{
    setState(() {
      _isLoading1=true;
    });
    await categoriesProvider.fetchSubSubCatId(widget.subCategoryId).then((value)async{
      setState(() {
        _count++;
      });
      setState(() {
        _isLoading1=false;
      });
      categoryProductsProvider.categoryProductList.clear();
      categoriesProvider.subSubCategoriesId!=null?categoriesProvider.subSubCategoriesId.isNotEmpty
          ? categoryProductsProvider.fetch(widget.categoryId, widget.subCategoryId, categoriesProvider.subSubCategoriesId[_selectedIndex].id, 1)
          .then((value) {
        categoryProductsProvider.fetchList().then((value){
          setState(() {
            _isLoading = false;
          });
        });
      }):
      setState(() {
        _isLoading = false;
      }):
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final CategoriesProvider categoriesProvider =
        Provider.of<CategoriesProvider>(context);
    final CategoryProductsProvider categoryProductsProvider =
        Provider.of<CategoryProductsProvider>(context);
    final size = MediaQuery.of(context).size;
    if (_count == 0) {
      fetch(categoriesProvider,categoryProductsProvider);
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                categoryProductsProvider.categoryProductList.clear();
                Navigator.pop(context);
              }),
          title: Text(widget.name,style: TextStyle(color: Colors.black)),
        ),
        body: _isLoading1?Center(child: CupertinoActivityIndicator()):Container(
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
                    itemCount: categoriesProvider.subSubCategoriesId==null?0:categoriesProvider.subSubCategoriesId.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _isLoading = true;
                            _selectedIndex = index;
                            categoryProductsProvider.fetch(
                                    widget.categoryId,
                                    widget.subCategoryId,
                                    categoriesProvider.subSubCategoriesId[_selectedIndex].id,
                                    1)
                                .then((value) {
                              categoryProductsProvider.categoryProductList.clear();
                              categoryProductsProvider.fetchList().then((value) {
                                setState(() {
                                  _isLoading = false;
                                });
                              });

                            });
                          });
                        },
                        child: Container(
                          color: index == _selectedIndex
                              ? kPrimaryColor
                              : Colors.deepPurple[400],
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '${categoriesProvider.subSubCategoriesId[index].nameBn}',
                            style: TextStyle(
                              fontSize: size.width * .03,
                              fontWeight: index == _selectedIndex
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
                  width: size.width * .75,
                  color: kSecondaryColor.withOpacity(0.1),
                  child: _isLoading
                      ? Center(child: CupertinoActivityIndicator())
                      : SmartRefresher(
                          //enablePullDown: true,
                          enablePullUp: true,
                          physics: ClampingScrollPhysics(),
                          footer: CustomFooter(
                            builder: (context, mode) {
                              Widget bdy;
                              if (mode == LoadStatus.idle) {
                                bdy = Text("No Products");
                              } else if (mode == LoadStatus.loading) {
                                bdy = Padding(
                                  padding: EdgeInsets.all(10),
                                  child: CupertinoActivityIndicator(),
                                );
                              } else if (mode == LoadStatus.failed) {
                                bdy = Text("Load Failed!");
                              } else if (mode == LoadStatus.canLoading) {
                                bdy = Text("release to load more");
                              } else {
                                bdy = Text("No more Data");
                              }
                              return Container(
                                child: Center(
                                  child: bdy,
                                ),
                              );
                            },
                          ),
                          controller: _refreshController,
                          //onRefresh:()=>_onRefresh(apiProvider),
                          onLoading: () => _onLoading(
                              categoryProductsProvider, categoriesProvider),
                          child: categoryProductsProvider
                                      .categoryProductList ==
                                  null
                              ? Center(child: CupertinoActivityIndicator())
                              :
                          // GridView.builder(
                          //         shrinkWrap: true,
                          //         physics: ClampingScrollPhysics(),
                          //         gridDelegate:
                          //             SliverGridDelegateWithFixedCrossAxisCount(
                          //           crossAxisCount: 2,
                          //           childAspectRatio: 6.75/9,
                          //           mainAxisSpacing: 6,
                          //           crossAxisSpacing: 6,
                          //         ),
                          //         itemCount: categoryProductsProvider
                          //                     .categoryProductsModel ==
                          //                 null
                          //             ? 0
                          //             : categoryProductsProvider
                          //                     .categoryProductList.isEmpty
                          //                 ? 0
                          //                 : categoryProductsProvider
                          //                     .categoryProductList.length,
                          //         itemBuilder: (context, index) => InkWell(
                          //             // onTap: () => Navigator.push(
                          //             //     context,
                          //             //     MaterialPageRoute(
                          //             //         builder: (context) => CategoryProducts(
                          //             //           name: categoriesProvider
                          //             //               .subCategories[index].nameBn,
                          //             //         ))),
                          //             child: CategoryProductCard(
                          //                 product: categoryProductsProvider
                          //                         .categoryProductList[
                          //                     index]))),
                          categoryProductsProvider.categoryProductsModel == null?Container(child: Center(child: Text("No products found")),):
                          categoryProductsProvider.categoryProductList.isEmpty?Container(child: Center(child: Text("No products found")),):
                          StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            physics: new ClampingScrollPhysics(),
                            itemCount: categoryProductsProvider.categoryProductsModel == null
                                        ? 0
                                        : categoryProductsProvider.categoryProductList.isEmpty
                                            ? 0
                                            : categoryProductsProvider.categoryProductList.length,
                            crossAxisCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              // if (demoProducts[index].isPopular)
                              return InkWell(
                                // onTap: () => Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => CategoryProducts(
                                //           name: categoriesProvider
                                //               .subCategories[index].nameBn,
                                //         ))),
                                  child: CategoryProductCard(
                                      product: categoryProductsProvider
                                          .categoryProductList[
                                      index]));
                              // return SizedBox
                              //     .shrink(); // here by default width and height is 0
                            },
                            staggeredTileBuilder: (int index) =>
                            new StaggeredTile.fit(1),
                            mainAxisSpacing: 6.0,

                          ),
                        ),
                )
              ],
            )),
      ),
    );
  }

  Future<void> _onLoading(CategoryProductsProvider provider,
      CategoriesProvider categoriesProvider) async {
    await provider
        .fetchPage(widget.categoryId, widget.subCategoryId,
            categoriesProvider.subSubCategoriesId[_selectedIndex].id, page)
        .then((value) {
      _refreshController.refreshCompleted();
      setState(() {
        page++;
      });
    });
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
  }
}
