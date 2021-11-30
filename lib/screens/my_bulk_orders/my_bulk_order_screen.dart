import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mukto_mart/screens/profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mukto_mart/providers/bulk_order_provider.dart';
import 'package:mukto_mart/repo/bulk_order_repo.dart';
import 'package:mukto_mart/screens/my_bulk_orders/upload_order_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBulkOrders extends StatefulWidget {
  @override
  State<MyBulkOrders> createState() => _MyBulkOrdersState();
}

class _MyBulkOrdersState extends State<MyBulkOrders> {
  bool _isLoading=false;
  String token;
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();

  }

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('api_token');
    });
  }

  @override
  Widget build(BuildContext context) {
    final BulkOrderProvider bulkOrderProvider = Provider.of<BulkOrderProvider>(context,listen: false);
    BulkOrderRepo bulkOrderRepo=BulkOrderRepo();
    final size=MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ProfileScreen();}));
            },),
            title: Text("My Bulk Order List",style: TextStyle(color: Colors.black)),
          ),
          body: Stack(
            children: [
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                child: bulkOrderProvider.bulkOrders!=null?bulkOrderProvider.bulkOrders.orders!=null?bulkOrderProvider.bulkOrders.orders.length!=0?ListView.builder(
                  itemCount: bulkOrderProvider.bulkOrders==null?0:bulkOrderProvider.bulkOrders.orders==null?0:bulkOrderProvider.bulkOrders.orders.length,
                  itemBuilder: (context, index){
                    DateTime time = bulkOrderProvider.bulkOrders.orders[index].createdAt.date;
                    var fileName = (bulkOrderProvider.bulkOrders.orders[index].orderFile.toString().split('/').last);
                    return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      //padding: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.1),//Color(0xFFFFE6E6),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            //width: size.width*.73,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width*.7,
                                  child: Text(
                                    'Order: ${bulkOrderProvider.bulkOrders.orders[index].id}',
                                    style: TextStyle(color: kPrimaryColor, fontSize: 16),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  width: size.width,
                                  child: Row(
                                    children: [
                                      new Text('Order File:'),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: InkWell(
                                            onTap: () => launch(bulkOrderProvider.bulkOrders.orders[index].orderFile),
                                            child: Container(
                                              color:Colors.green[100],child: Text(fileName,style: TextStyle(decoration: TextDecoration.underline),),)),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  width: size.width*.45,
                                  child: Text('Status: ${bulkOrderProvider.bulkOrders.orders[index].status}',
                                      style: TextStyle(
                                          fontSize: size.width * .030)),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  width: size.width*.45,
                                  child: Text('Order Date: ${f.format(time)}',
                                      style: TextStyle(
                                          fontSize: size.width * .030)),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                          SizedBox(width: 13),
                          InkWell(
                              onTap: (){
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {

                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        scrollable: true,
                                        contentPadding: EdgeInsets.all(20),
                                        title: Column(
                                          children: [
                                            Text(
                                              'Do you really want to delete this order?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal, color: kPrimaryColor),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.width * .050,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () => Navigator.of(context).pop(),
                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: kPrimaryColor,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    Navigator.of(context).pop();
                                                    setState(() {
                                                      _isLoading=true;
                                                    });
                                                    bulkOrderRepo.deleteBulkOrder(token, bulkOrderProvider.bulkOrders.orders[index].id).then((value)async{
                                                      await bulkOrderProvider.fetch(token);
                                                      _showToast('Order deleted', kPrimaryColor);
                                                    });
                                                  },
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: kPrimaryColor,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Icon(Icons.delete_forever,color: kPrimaryColor,))
                        ],
                      ),
                    ),
                  );
  }
                ):Center(child: Text('No orders')):Center(child: Text('No orders')):Center(child: Text('No orders'))
              ),
              _isLoading?Center(child: CircularProgressIndicator()):Container()
            ],
          ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: Icon(Icons.file_upload),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UploadOrder()));
          },

        ),
      ),
    );
  }
  Future<bool> _onBackPressed() async {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ProfileScreen();}));
  }

  void _showToast(String message, Color color) {
    setState(() {
      _isLoading = false;
    });
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
