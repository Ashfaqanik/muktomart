import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mukto_mart/screens/categories/categories_screen.dart';
import 'package:mukto_mart/screens/notifications/notification_screen.dart';
import 'package:mukto_mart/variables/size_config.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/icons/NewsFeed.svg", "text": "News Feed"},
      {"icon": "assets/icons/Gift Icon.svg", "text": "Gift Cards"},
      {"icon": "assets/icons/categories.svg", "text": "Categories"},
      {"icon": "assets/icons/Orders.svg", "text": "Orders"},
      {"icon": "assets/icons/more.svg", "text": "More"},
    ];
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: () {
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
              //   return NotificationScreen(title: 'Title',details: 'Description',);  }));
            },
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(60),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              height: getProportionateScreenWidth(50),
              width: getProportionateScreenWidth(50),
              decoration: BoxDecoration(
                color: Color(0xFFF7D5EA),
                borderRadius: BorderRadius.circular(30),
              ),
              child: SvgPicture.asset(icon),
            ),
            SizedBox(height: 5),
            Text(text, textAlign: TextAlign.center,style: TextStyle(fontSize: 11),)
          ],
        ),
      ),
    );
  }
}
