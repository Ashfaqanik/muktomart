import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/providers/categories_provider.dart';
import 'package:provider/provider.dart';
import 'components/category_products.dart';
import 'components/main_subcategory_tile.dart';

class HomeCategoriesScreen extends StatefulWidget {
  String name;
  int categoryId, subCategoryId;

  HomeCategoriesScreen({this.name, this.categoryId, this.subCategoryId});

  @override
  _HomeCategoriesScreenState createState() => _HomeCategoriesScreenState();
}

class _HomeCategoriesScreenState extends State<HomeCategoriesScreen> {
  int count=0;
  bool _isLoading=false;

  Future<void> fetch(CategoriesProvider categoriesProvider)async{
    setState(() {
      _isLoading=true;
      count++;
    });
    await categoriesProvider.fetchSubCategories(widget.categoryId).then((value){
      setState(() {
        _isLoading=false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final CategoriesProvider categoriesProvider = Provider.of<CategoriesProvider>(context);
    if(count==0){
      fetch(categoriesProvider);
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: () {
            Navigator.pop(context);
            //Navigator.pushNamed(context, MainPage.routeName);
          },),
          title: Text(widget.name,style: TextStyle(color: Colors.black)),
        ),
        body: _isLoading?Center(child: CupertinoActivityIndicator()):Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 10.0),
          child: GridView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 7.2/9,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8
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
        ),
      ),
    );
  }
  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    //Navigator.pushNamed(context, MainPage.routeName);
  }
}
