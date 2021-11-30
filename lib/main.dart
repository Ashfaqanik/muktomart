import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mukto_mart/providers/all_products_provider.dart';
import 'package:mukto_mart/providers/all_search_products_provider.dart';
import 'package:mukto_mart/providers/banner_provider.dart';
import 'package:mukto_mart/providers/bulk_order_provider.dart';
import 'package:mukto_mart/providers/cart_provider.dart';
import 'package:mukto_mart/providers/categories_provider.dart';
import 'package:mukto_mart/providers/category_products_provider.dart';
import 'package:mukto_mart/providers/comment_provider.dart';
import 'package:mukto_mart/providers/details_provider.dart';
import 'package:mukto_mart/providers/discount_products_provider.dart';
import 'package:mukto_mart/providers/big_products_provider.dart';
import 'package:mukto_mart/providers/favourite_seller_provider.dart';
import 'package:mukto_mart/providers/featured_settings_provider.dart';
import 'package:mukto_mart/providers/local_search_provider.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/providers/sale_products_provider.dart';
import 'package:mukto_mart/providers/hot_products_provider.dart';
import 'package:mukto_mart/providers/featured_products_provider.dart';
import 'package:mukto_mart/providers/latest_products_provider.dart';
import 'package:mukto_mart/providers/popular_products_provider.dart';
import 'package:mukto_mart/providers/shipping_charge_provider.dart';
import 'package:mukto_mart/providers/slider_provider.dart';
import 'package:mukto_mart/providers/top_products_provider.dart';
import 'package:mukto_mart/providers/wish_provider.dart';
import 'package:mukto_mart/providers/order_provider.dart';
import 'package:mukto_mart/providers/messages_provider.dart';
import 'package:mukto_mart/providers/check_out_provider.dart';
import 'package:mukto_mart/screens/notifications/notification_screen.dart';
import 'package:mukto_mart/screens/splash/splash_screen.dart';
import 'package:mukto_mart/providers/coupon_provider.dart';
import 'package:mukto_mart/providers/order_details_provider.dart';
import 'package:mukto_mart/variables/routes.dart';
import 'package:mukto_mart/variables/theme.dart';
import 'package:provider/provider.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(debugLabel:"navigator");


  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        navigatorKey.currentState.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => NotificationScreen(title: message.notification.title,
              details: message.notification.body,)), (Route<dynamic> route) => false);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
        // showGeneralDialog(
        //   barrierLabel: notification.title,
        //   barrierDismissible: false,
        //   barrierColor: Colors.black.withOpacity(0.5),
        //   transitionDuration: Duration(milliseconds: 500),
        //   context: context,
        //   transitionBuilder: (_,anim,__,child) {
        //     return SlideTransition(
        //       position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim),
        //       child: child,
        //     );
        //   },
        //   pageBuilder: (context,_,__){
        //     return  Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [Text(notification.body)],
        //     );
        //   },
        //
        // );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        print('yes');
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (context) => NotificationScreen(title: notification.title,details: notification.body,)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoriesProvider(),),
        ChangeNotifierProvider(create: (context) => PopularProductsProvider(),),
        ChangeNotifierProvider(create: (context) => TopProductsProvider(),),
        ChangeNotifierProvider(create: (context) => LatestProductsProvider(),),
        ChangeNotifierProvider(create: (context) => DiscountProductsProvider(),),
        ChangeNotifierProvider(create: (context) => FeaturedProductsProvider(),),
        ChangeNotifierProvider(create: (context) => HotProductsProvider(),),
        ChangeNotifierProvider(create: (context) => BigProductsProvider(),),
        ChangeNotifierProvider(create: (context) => SaleProductsProvider(),),
        ChangeNotifierProvider(create: (context) => AllProductsProvider(),),
        ChangeNotifierProvider(create: (context) => CategoryProductsProvider(),),
        ChangeNotifierProvider(create: (context) => ProfileProvider(),),
        ChangeNotifierProvider(create: (context) => WishProvider(),),
        ChangeNotifierProvider(create: (context) => DetailsProvider(),),
        ChangeNotifierProvider(create: (context) => CartProvider(),),
        ChangeNotifierProvider(create: (context) => BannerProvider(),),
        ChangeNotifierProvider(create: (context) => CommentProvider(),),
        ChangeNotifierProvider(create: (context) => FavouriteSellerProvider(),),
        ChangeNotifierProvider(create: (context) => CheckOutProvider(),),
        ChangeNotifierProvider(create: (context) => OrderProvider(),),
        ChangeNotifierProvider(create: (context) => CouponProvider(),),
        ChangeNotifierProvider(create: (context) => OrderDetailsProvider(),),
        ChangeNotifierProvider(create: (context) => MessagesProvider(),),
        ChangeNotifierProvider(create: (context) => AllSearchProductsProvider(),),
        ChangeNotifierProvider(create: (context) => SliderProvider(),),
        ChangeNotifierProvider(create: (context) => DatabaseHelper(),),
        ChangeNotifierProvider(create: (context) => FeaturedSettingsProvider(),),
        ChangeNotifierProvider(create: (context) => BulkOrderProvider(),),
        ChangeNotifierProvider(create: (context) => ShippingChargeProvider(),),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme(),
        // home: SplashScreen(),
        initialRoute: SplashScreen.routeName,
        routes: routes,
      ),
    );
  }

}
