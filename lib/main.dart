import 'package:door_step_customer/constants/color.dart';
import 'package:door_step_customer/providers/HomeProviders.dart';
import 'package:door_step_customer/providers/VendorProviders.dart';
import 'package:door_step_customer/providers/location_provider.dart';
import 'package:door_step_customer/screens/home/HomePage.dart';
import 'package:door_step_customer/screens/orders/OrderDetailsScreen.dart';
import 'package:door_step_customer/screens/splash/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message customer: ${message.data.toString()}");
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
    options: const FirebaseOptions(
      apiKey: "AIzaSyDB0lZ1F1VjhEgLsCQJKxqfqX73vnLuWBY",
      projectId: "door-step-5b28b",
      messagingSenderId: "540506725664",
      appId: "1:540506725664:android:8a5d7456cc67a09cd84b45",
      storageBucket: "door-step-5b28b.appspot.com",
    ),
  ).whenComplete(() => print("completed")).catchError((error) {
    print('Something failed :$error');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: VendorProviders()),
      ChangeNotifierProvider.value(value: LocationProvider()),
      ChangeNotifierProvider.value(value: HomeProviders()),
    ],
    child: MyApp(),
  ));
}


class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();

    // Handle the app opening from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageNavigation(message,context);
    });

    // Handle the app opening from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleMessageNavigation(message,context);
      }
    });

    _firebaseMessaging.requestPermission();
  }



  void _handleMessageNavigation(RemoteMessage message,BuildContext context) {
    // Extract the data payload from the message
    String orderId = message.data['orderId'];
    if (message.data.containsKey('page')) {
      String page = message.data['page'];

      print('navigation details $orderId  $page');

      // Navigate to a specific page based on the payload
      if (page == 'orderDetails') {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) =>
        //       OrderDetailsScreen(orderId: orderId)), // Navigate to Page1
        // );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      SplashPage(page: 'orderdetails',)
              )
          );
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      SplashPage(page: 'home',)
              )
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
        return MaterialApp(
      title: 'Door Step',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Saira",
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home:  SplashPage(page: 'auth',),
    );
  }
}

// class MyApp extends StatelessWidget {
//    MyApp({super.key});
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//
//     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//       if (message != null) {
//         print('Initial message: ${message.data}');
//       }
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Message received: ${message.notification?.body}');
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // print('Message clicked!: ${message.data}');
//       _handleMessageNavigation(message,context);
//         });
//
//     _firebaseMessaging.requestPermission();
//
//     return MaterialApp(
//       title: 'Door Step',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: "Saira",
//         colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
//         useMaterial3: true,
//       ),
//       home:  SplashPage(page: 'auth',),
//     );
//   }
//
//
// }
