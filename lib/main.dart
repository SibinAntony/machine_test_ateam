import 'package:door_step_customer/constants/color.dart';
import 'package:door_step_customer/providers/HomeProviders.dart';
import 'package:door_step_customer/providers/VendorProviders.dart';
import 'package:door_step_customer/providers/location_provider.dart';
import 'package:door_step_customer/screens/splash/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
      home: const SplashPage(),
    );
  }
}
