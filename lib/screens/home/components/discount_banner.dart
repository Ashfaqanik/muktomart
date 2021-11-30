import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mukto_mart/providers/slider_provider.dart';
import 'package:provider/provider.dart';

class DiscountBanner extends StatefulWidget {
  @override
  _DiscountBannerState createState() => _DiscountBannerState();
}

class _DiscountBannerState extends State<DiscountBanner> {
  static List<dynamic> imageSliders;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: size.height*.2,
        width: size.width*.96,
        child: Carousel(
          boxFit: BoxFit.none,
          autoplay: true,
          autoplayDuration: const Duration(seconds: 4),
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 1000),
          dotSize: 6.0,
          dotIncreasedColor: Colors.white,
          dotBgColor: Colors.transparent,
          dotPosition: DotPosition.bottomCenter,
          dotVerticalPadding: 10.0,
          showIndicator: true,
          indicatorBgPadding: 7.0,
          images: bannerSlider(context)
        ),
      ),
    );
  }
  bannerSlider(BuildContext context) {
    final SliderProvider sliderProvider = Provider.of<SliderProvider>(context,listen: false);
    return imageSliders = sliderProvider.slidersList
        .map<dynamic>((item) => Container(
      child: Container(
        height: MediaQuery.of(context).size.height * .055,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: InkWell(
            onTap: () async {
            },
            child: item==null?Container():Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6)),
                child: CachedNetworkImage(
                  imageUrl: item.photo,
                  placeholder: (context, url) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error),
                  fit: BoxFit.fill,
                ))//Image.network(item.photo,fit: BoxFit.fill,)),
          ),
        ),
      ),
    ))
        .toList();
  }

}

