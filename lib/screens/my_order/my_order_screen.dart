import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mukto_mart/providers/order_details_provider.dart';
import 'package:mukto_mart/providers/order_provider.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/order_card.dart';
import 'components/order_details.dart';

class MyOrders extends StatefulWidget {
  static String routeName = "/myOrder";

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  String token;
  bool isLoading=false;

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
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context,listen: false);
    final OrderDetailsProvider orderDetailsProvider = Provider.of<OrderDetailsProvider>(context,listen: false);
    final size=MediaQuery.of(context).size;
    final f = new DateFormat('dd-MM-yyyy hh:mm a');
    orderProvider.fetch(token);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
          //   return HomeScreen();  }));
        },),
        title: Text("My Order List",style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
            child: ListView.builder(
              itemCount: orderProvider.orders==null?0:orderProvider.orders.orders==null?0:orderProvider.orders.orders.length,
              itemBuilder: (context, index){
                DateTime time = orderProvider.orders.orders[index].createdAt;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    //padding: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),//Color(0xFFFFE6E6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:Padding(
                        padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              isLoading=true;
                            });
                            orderDetailsProvider.fetch(token, orderProvider.orders.orders[index].id).then((value){
                              setState(() {
                                isLoading=false;
                              });
                              Navigator.push(context,MaterialPageRoute(builder: (_) {
                                return OrderDetails();  }));
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: size.width*.53,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: size.width*.7,
                                        child: Text(
                                          'Order: ${orderProvider.orders.orders[index].orderNumber}',
                                          style: TextStyle(color: kPrimaryColor, fontSize: 16),
                                          maxLines: 2,
                                        ),
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
                                Column(
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(color: Colors.black, fontSize: 14),
                                    ),
                                    Text(
                                      "৳${orderProvider.orders.orders[index].payAmount}",
                                      style: TextStyle(color: Colors.black, fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 13),
                                Expanded(
                                  child: Text(
                                    orderProvider.orders.orders[index].status,
                                    style: TextStyle(color: Colors.blueGrey, fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                    //OrderCard(orders: orderProvider.orders.orders[index]),
                  ),
                );
              },
            ),
          ),
          isLoading?Center(child: CircularProgressIndicator()):Container()
        ],
      )
    );
  }
}
