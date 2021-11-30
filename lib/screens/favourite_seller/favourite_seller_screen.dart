import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/providers/favourite_seller_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mukto_mart/repo/favourite_seller_repo.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteSellerScreen extends StatefulWidget {

  @override
  _FavouriteSellerScreenState createState() => _FavouriteSellerScreenState();
}

class _FavouriteSellerScreenState extends State<FavouriteSellerScreen> {
  String token;
  bool _isLoading = false;
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('api_token');
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }
  @override
  Widget build(BuildContext context) {
    FavouriteSellerRepo favouriteSellerRepo=FavouriteSellerRepo();
    final FavouriteSellerProvider favouriteSellerProvider = Provider.of<FavouriteSellerProvider>(context,listen: false);
    final size=MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Stack(
        children: [
          Scaffold(
            appBar: buildAppBar(context,favouriteSellerProvider),
            body: Column(
              children: [
                Expanded(
                    child:Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                      child: ListView.builder(
                        itemCount: favouriteSellerProvider.list==null?0:favouriteSellerProvider.list.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Dismissible(
                              key: Key(favouriteSellerProvider.list[index].id.toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                setState(() {
                                  favouriteSellerProvider.list.removeAt(index);
                                });
                              },
                              background: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFE6E6),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    SvgPicture.asset("assets/icons/Trash.svg"),
                                  ],
                                ),
                              ),
                              child: InkWell(
                                onTap: (){

                                },
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: size.width*.4,
                                          child: Text(
                                            "Shop Name:"+'${favouriteSellerProvider.list[index].shopName??''}',
                                            style: TextStyle(color: Colors.black, fontSize: 16),
                                            maxLines: 2,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: size.width*.4,
                                          child: Text(
                                            "Owner Name:"+ '${favouriteSellerProvider.list[index].ownerName ?? ''}',
                                            style: TextStyle(color: Colors.black, fontSize: 16),
                                            maxLines: 2,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: size.width*.4,
                                          child: Text(
                                            "Shop Address:"+'${favouriteSellerProvider.list[index].shopAddress??' '}',
                                            style: TextStyle(color: Colors.black, fontSize: 16),
                                            maxLines: 2,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                    SizedBox(width: 20),
                                    InkWell(
                                        onTap: (){
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          favouriteSellerRepo.removeSeller(token, favouriteSellerProvider.list[index].id).then((value){
                                            favouriteSellerProvider.fetch(token).then((value){
                                              favouriteSellerProvider.fetchSellerId(token).then((value){
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                _showToast('Seller removed', kPrimaryColor);
                                              });
                                            });
                                          });
                                        },
                                        child: Icon(Icons.highlight_remove_sharp,color: Colors.grey[700]))
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),
                    )
                ),
              ],
            ),
            // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.favourite),
          ),
          _isLoading ? Center(child: CircularProgressIndicator()) : Container()
        ],
      ),
    );
  }

  void _showToast(String message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
    //   return MainPage();  }));
  }

  AppBar buildAppBar(BuildContext context,FavouriteSellerProvider favouriteSellerProvider) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        //   return MainPage();  }));
      },),
      title: Column(
        children: [
          Text(
            "Your Favourite sellers",
            style: TextStyle(color: Colors.black),
          ),
          favouriteSellerProvider.list==null?Text('0 sellers', style: Theme.of(context).textTheme.caption,):Text(
            "${favouriteSellerProvider.list.length} sellers",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
