import 'dart:async';
import 'dart:convert';

import 'package:door_step_customer/screens/orders/OrderListScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/Images.dart';
import '../../resources/styles_manager.dart';

class OrderSuccessScreen extends StatefulWidget {
  OrderSuccessScreen({super.key, required this.orderID});

  String orderID = '';

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  late String customerId = "";
  late String mobileNumber = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userPref = sharedPreferences.getString('userData');

    Map<String, dynamic> userMap =
        jsonDecode(userPref!) as Map<String, dynamic>;
    String name = userMap['userName'];
     mobileNumber = userMap['mobileNumber'];
    String userEmail = userMap['userEmail'];
    customerId = userMap['key'];
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => OrderListScreen(
                userPref: mobileNumber,
              ))),
    );
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            Images.success_gif,
            height: 125.0,
            width: 125.0,
          ),
          Container(
            // margin: EdgeInsets.only(left: 30, right: 30),
            child: Text(
              'Your Order Placed. \nOur Delivery Partner will Call you shortly',
              style: getHeadingStyle2(color: Colors.black).copyWith(
                  fontWeight: FontWeight.w500, fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0, top: 30, right: 0),
            child: Text(
              'Your Order Id : ${widget.orderID}',
              style: getHeadingStyle2(color: Colors.black).copyWith(
                  fontWeight: FontWeight.w700, fontSize: 18, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
