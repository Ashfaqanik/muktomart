import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/components/popular_product_card.dart';
import 'package:mukto_mart/providers/popular_products_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PopularProductsScreen extends StatefulWidget {
  String name;

  PopularProductsScreen({this.name});

  @override
  _PopularProductsScreenState createState() => _PopularProductsScreenState();
}

class _PopularProductsScreenState extends State<PopularProductsScreen> {
  int count=0;
  Future<void> _fetch(PopularProductsProvider provider){
    provider.popularList.clear();
    provider.fetchList().then((value){
      setState(() {
        count++;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final PopularProductsProvider provider = Provider.of<PopularProductsProvider>(context);
    if(count==0)_fetch(provider);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), onPressed: () {
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
            //   return MainPage();  }));
            Navigator.pop(context);
          },),
          title: Text(widget.name,style: TextStyle(color: Colors.black)),
        ),
        body: Body(),
      ),
    );
  }
  Future<bool> _onBackPressed() async {
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
    //   return MainPage();  }));
    Navigator.pop(context);
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int page=2;
  @override
  Widget build(BuildContext context) {
    final PopularProductsProvider provider = Provider.of<PopularProductsProvider>(context);

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      physics: ClampingScrollPhysics(),
      footer: CustomFooter(
        builder: (context, mode){
          Widget bdy;
          if(mode== LoadStatus.idle){
            bdy = Text("No Products");
          }
          else if(mode==LoadStatus.loading){
            bdy =  Padding(
              padding: EdgeInsets.all(10),
              child: CupertinoActivityIndicator(),
            );
          }
          else if(mode == LoadStatus.failed){
            bdy = Text("Load Failed!");
          }
          else if(mode == LoadStatus.canLoading){
            bdy = Text("release to load more");
          }
          else{
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
      onLoading: ()=> _onLoading(provider),
      child: provider.popularProducts==null
          ?Center(child: CupertinoActivityIndicator())
          :
      // GridView.builder(
      //   shrinkWrap: true,
      //   physics: new ClampingScrollPhysics(),
      //   itemCount: provider.popularList.length,
      //   gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 6,childAspectRatio: 6.5/9),
      //   itemBuilder: (BuildContext context, int index) {
      //     // if (demoProducts[index].isPopular)
      //     return PopularProductCard(product: provider.popularList[index]);
      //     // return SizedBox
      //     //     .shrink(); // here by default width and height is 0
      //   },
      // )
      StaggeredGridView.countBuilder(
        shrinkWrap: true,
        physics: new ClampingScrollPhysics(),
        itemCount: provider.popularList.length,
        crossAxisCount: 3,
        itemBuilder: (BuildContext context, int index) {
          // if (demoProducts[index].isPopular)
          return PopularProductCard(product: provider.popularList[index]);
          // return SizedBox
          //     .shrink(); // here by default width and height is 0
        },
        staggeredTileBuilder: (int index) =>
        new StaggeredTile.fit(1),
        mainAxisSpacing: 6.0,

      ),
    );
  }
  Future<void> _onLoading(PopularProductsProvider provider) async{
    await provider.fetchPage(page).then((value){
      _refreshController.refreshCompleted();
      setState(() {
        page++;
      });
    });
    if(mounted)
      setState(() {});
    _refreshController.loadComplete();
  }
}
