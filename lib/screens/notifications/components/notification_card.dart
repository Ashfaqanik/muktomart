import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/variables/constants.dart';

class NotificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: size.width*.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification Title',
                  style: TextStyle(color: kPrimaryColor, fontSize: 16),
                  maxLines: 2,
                ),
                SizedBox(height: 5),
                Container(
                  width: size.width*.35,
                  child: Text('Details',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: Colors.grey[800]),),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
