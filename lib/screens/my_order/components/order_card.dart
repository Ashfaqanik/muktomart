import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mukto_mart/models/order_model.dart';
import 'package:mukto_mart/providers/order_details_provider.dart';
import 'package:mukto_mart/providers/order_provider.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:provider/provider.dart';
import 'package:mukto_mart/screens/my_order/components/order_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCard extends StatefulWidget {
  OrderCard({
    Key key,
    @required this.orders,
  }) : super(key: key);

  final Order orders;

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String token;
  bool _isLoading=false;
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
    final OrderDetailsProvider orderDetailsProvider = Provider.of<OrderDetailsProvider>(context,listen: false);
    final size=MediaQuery.of(context).size;
    DateTime time = widget.orders.createdAt;
    return Padding(
      padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
      child: InkWell(
        onTap: (){
          setState(() {
            _isLoading=true;
          });
          orderDetailsProvider.fetch(token, widget.orders.id).then((value){
            setState(() {
              _isLoading=false;
            });
            Navigator.push(context,MaterialPageRoute(builder: (_) {
              return OrderDetails();  }));
          });
        },
        child: Stack(
          children: [
            _isLoading?Center(child: CircularProgressIndicator()):Container(),
            Padding(
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
                              'Order: ${widget.orders.orderNumber}',
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
                          "৳${widget.orders.payAmount}",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(width: 13),
                    Expanded(
                      child: Text(
                        widget.orders.status,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 11),
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      )
      );
  }
}
