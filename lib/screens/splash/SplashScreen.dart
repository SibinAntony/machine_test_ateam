import 'dart:async';

import 'package:door_step_customer/screens/home/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/Images.dart';
import '../../constants/color.dart';
import '../auth/SignInScreen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    // Timer(
    //     const Duration(seconds: 3),
    //     () => Navigator.of(context).pushReplacement(MaterialPageRoute(
    //         builder: (BuildContext context) => const SignInScreen())));

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 10),
            child: Image.asset(
              Images.logo_splash,
            ),
          ),
          const CircularProgressIndicator(
            color: primaryColor,
          )
        ],
      ),
    );
  }

  late SharedPreferences sharedPreferences;

  Future<void> fetchUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    bool isLoggedin = sharedPreferences.getBool('isLoggedIn') ?? false;

    if (isLoggedin) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const MyHomePage())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const SignInScreen())));
    }
  }
}
