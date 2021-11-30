import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/components/feature_setting_card1.dart';
import 'package:mukto_mart/providers/featured_settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeatureLinkProductsScreen extends StatefulWidget {
  String name;
  int id;

  FeatureLinkProductsScreen({this.name,this.id});

  @override
  _FeatureLinkProductsScreenState createState() => _FeatureLinkProductsScreenState();
}

class _FeatureLinkProductsScreenState extends State<FeatureLinkProductsScreen> {
  bool _isLoading=false;
  int count=0;
  Future<void> _fetch(FeaturedSettingsProvider provider)async{
    setState(() {
      count++;
      _isLoading=true;
    });
    provider.featureLinkProductList.isNotEmpty?provider.featureLinkProductList.clear():null;
    await provider.fetchProducts(1,widget.id ).then((value)async{
      await provider.fetch1List().then((value){
        setState(() {
          _isLoading=false;
        });
      });

    });
  }
  @override
  Widget build(BuildContext context) {
    final FeaturedSettingsProvider provider = Provider.of<FeaturedSettingsProvider>(context);
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
          title: Text(widget.name,style: TextStyle(color: Colors.black),),
        ),
        body: _isLoading?Center(child: CupertinoActivityIndicator()):Body(widget.id),
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
  int id;

  Body(this.id);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int page=2;
  @override
  Widget build(BuildContext context) {
    final FeaturedSettingsProvider provider = Provider.of<FeaturedSettingsProvider>(context);

    return provider.featureLinkProducts!=null?provider.featureLinkProductList.isNotEmpty?SmartRefresher(
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
        child: provider.featureLinkProductList==null
            ?Center(child: CupertinoActivityIndicator()):
        StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: new ClampingScrollPhysics(),
          itemCount: provider.featureLinkProductList.length,
          crossAxisCount: 3,
          itemBuilder: (BuildContext context, int index) {
            // if (demoProducts[index].isPopular)
            return FeatureSettingCard1(product: provider.featureLinkProductList[index]);
            // return SizedBox
            //     .shrink(); // here by default width and height is 0
          },
          staggeredTileBuilder: (int index) =>
          new StaggeredTile.fit(1),
          mainAxisSpacing: 6.0,

        ),
    ):Container(child:Center(child:Text('No Products'))):Container(child:Center(child:Text('No Products')));
  }
  Future<void> _onLoading(FeaturedSettingsProvider provider) async{
    await provider.fetch1Page(page,widget.id).then((value){
      _refreshController.refreshCompleted();
      setState(()=> page++);
    });
    if(mounted)
      setState(() {});
    _refreshController.loadComplete();
  }
}
