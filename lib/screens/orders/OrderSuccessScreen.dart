import 'dart:async';
import 'dart:convert';

import 'package:door_step_customer/screens/orders/OrderListScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/Images.dart';
import '../../constants/push_notification_service.dart';
import '../../models/DeliveryMen.dart';
import '../../models/UserModel.dart';
import '../../resources/styles_manager.dart';

class OrderSuccessScreen extends StatefulWidget {
  OrderSuccessScreen({super.key, required this.orderID, this.map});

  String orderID = '';
  Map? map;

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

  final streamUsers = FirebaseDatabase.instance
      .ref('deliverymen')
      .orderByChild('userType')
      .equalTo('3')
      .onValue;

  List<Deliverymen> userList = [];

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => OrderListScreen(
                userPref: mobileNumber,
            isOrderSucess: true,
              ))),
    );
    return Scaffold(
      body:      Container(
          margin: const EdgeInsets.only(top: 20, bottom: 30),
          child: StreamBuilder(
            stream: streamUsers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data?.snapshot.value as Map?;
                if (data == null) {
                  return const Text('No data');
                }
                Map<dynamic, dynamic>? map =
                snapshot.data!.snapshot.value as Map?;
                userList.clear();

                map!.forEach((key, value) {

                  String deviceToken=value['deviceToken']??'';

                  PushNotificationService.sendNotificationToSelectedDriver(
                      deviceToken,
                      context,widget.orderID,
                  'New Order received','New order from ${widget.map!["vendorName"]}');
                });

                return    Column(
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
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text(snapshot.error.toString());
              }

              return const Text('....');
            },
          )),


    );
  }
}
