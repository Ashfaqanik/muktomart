import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mukto_mart/providers/details_provider.dart';
import 'package:mukto_mart/providers/wish_provider.dart';
import 'package:mukto_mart/screens/details/details_screen.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:mukto_mart/providers/order_details_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  bool isFavourite=false;

  @override
  Widget build(BuildContext context) {
    final OrderDetailsProvider orderDetailsProvider = Provider.of<OrderDetailsProvider>(context, listen: false);
    final DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context,listen: false);
    DateTime time = orderDetailsProvider.orderDetails.orders.createdAt;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Order details",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: size.height * .98,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Order Number: ',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    orderDetailsProvider.orderDetails.orders.orderNumber,
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Order Date: ',
                    style:
                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text('${f.format(time)}', style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'State: ',
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text('${orderDetailsProvider.orderDetails.orders.status}', style: TextStyle(color: kPrimaryColor),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Method: ',
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text('${orderDetailsProvider.orderDetails.orders.method}', style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Shipping: ',
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text('${orderDetailsProvider.orderDetails.orders.shipping}', style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
              SizedBox(height: 10),
              orderDetailsProvider.orderDetails.orders.shipping!='Ship To Address'?Row(
                children: [
                  Text(
                    'PickUp Location: ',
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text('${orderDetailsProvider.orderDetails.orders.pickupLocation}', style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ):Container(),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Total Quantity: ',
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text('${orderDetailsProvider.orderDetails.orders.totalQty}', style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Shipping Address: ',
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  orderDetailsProvider.orderDetails.orders.shippingAddress==null?Text('${orderDetailsProvider.orderDetails.orders.customerAddress}', style: TextStyle(color: Colors.grey[800]),
                  ):Text('${orderDetailsProvider.orderDetails.orders.shippingAddress}', style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Total Amount: ',
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text('৳${orderDetailsProvider.orderDetails.orders.payAmount}', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Products: ',
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: orderDetailsProvider.orderDetails.cart.length,
                    itemBuilder: (BuildContext context,int index){
                  return InkWell(
                    onTap: () {
                      detailsProvider.backed=0;
                      Navigator.push(context,MaterialPageRoute(builder: (_) {
                        return AllDetailsScreen(productDetails:detailsProvider.productDetails,favourite: isFavourite,
                          productId: orderDetailsProvider.orderDetails.cart[index].id,);  }));
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * .25,
                              child: AspectRatio(
                                aspectRatio: 0.88,
                                child: Container(
                                  padding: EdgeInsets.all(
                                      getProportionateScreenWidth(10)),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F6F9),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Image.network(
                                      orderDetailsProvider.orderDetails.cart[index].image),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * .27,
                                  child: Text(
                                    orderDetailsProvider.orderDetails.cart[index].name,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text.rich(
                                  TextSpan(
                                    text: "${orderDetailsProvider.orderDetails.cart[index].price}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: kPrimaryColor),
                                    children: [
                                      TextSpan(
                                          text:
                                          " x${orderDetailsProvider.orderDetails.cart[index].qty}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  );
                }),
              )

            ],
          ),
        ),
      ),
    );
  }
}
