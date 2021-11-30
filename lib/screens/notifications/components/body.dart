import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';

import 'notification_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),//Color(0xFFFFE6E6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: NotificationCard(),
          ),
        ),
      ),
    );
  }
}
