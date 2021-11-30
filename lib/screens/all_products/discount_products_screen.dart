import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/components/discount_product_card.dart';
import 'package:mukto_mart/providers/discount_products_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DiscountProductsScreen extends StatefulWidget {
  String name;

  DiscountProductsScreen({this.name});

  @override
  _DiscountProductsScreenState createState() => _DiscountProductsScreenState();
}

class _DiscountProductsScreenState extends State<DiscountProductsScreen> {
  int count=0;
  Future<void> _fetch(DiscountProductsProvider provider){
    provider.discountList.clear();
    provider.fetchList().then((value){
      setState(() {
        count++;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final DiscountProductsProvider provider = Provider.of<DiscountProductsProvider>(context);
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
    final DiscountProductsProvider provider = Provider.of<DiscountProductsProvider>(context);

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
      child: provider.discountProducts==null
          ?Center(child: CupertinoActivityIndicator())
          : StaggeredGridView.countBuilder(
        shrinkWrap: true,
        physics: new ClampingScrollPhysics(),
        itemCount: provider.discountList.length,
        crossAxisCount: 3,
        itemBuilder: (BuildContext context, int index) {
          // if (demoProducts[index].isPopular)
          return DiscountProductCard(product: provider.discountList[index]);
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
      //   itemCount: provider.discountList.length,
      //   gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 6,childAspectRatio: 6.5/9),
      //   itemBuilder: (BuildContext context, int index) {
      //     // if (demoProducts[index].isPopular)
      //     return DiscountProductCard(product: provider.discountList[index]);
      //     // return SizedBox
      //     //     .shrink(); // here by default width and height is 0
      //   },
      // )
    );
  }
  Future<void> _onLoading(DiscountProductsProvider provider) async{
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
