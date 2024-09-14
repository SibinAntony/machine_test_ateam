import 'dart:async';
import 'dart:convert';

import 'package:door_step_customer/screens/home/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/Images.dart';
import '../../constants/color.dart';
import '../auth/SignInScreen.dart';
import '../location/select_location_screen.dart';

class SplashPage extends StatefulWidget {
   SplashPage({super.key, required this.page});

  String page;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    print('navigation page rec ${widget.page}');
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
  late String userLocation = "";

  Future<void> fetchUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    bool isLoggedin = sharedPreferences.getBool('isLoggedIn') ?? false;
    String? userLocationPref = sharedPreferences.getString('userLocation');




    print('userLocation -> $userLocation i');
    print('isLoggedin -> $isLoggedin i');

    if (isLoggedin) {
      Timer(const Duration(seconds: 3), () {

        if(userLocationPref==null){
          // Map<String, dynamic> userLocationMap =
          // jsonDecode(userLocationPref) as Map<String, dynamic>;
          // userLocation = userLocationMap['currentArea'] ?? '';
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>  SelectLocationScreen(isDeliveryAddress: false,isFromAuthDeliveryAddress: true,)));

        }else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const MyHomePage()));

        }


        // if (userLocation.isNotEmpty) {
        //   Navigator.of(context).pushReplacement(MaterialPageRoute(
        //       builder: (BuildContext context) => const MyHomePage()));
        // } else {
        //   Navigator.of(context).pushReplacement(MaterialPageRoute(
        //       builder: (BuildContext context) =>  SelectLocationScreen(isFromAuth: true,)));
        // }

      });
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const SignInScreen())));
    }
  }
}
