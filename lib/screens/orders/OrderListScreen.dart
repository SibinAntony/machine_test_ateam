import 'dart:convert';

import 'package:door_step_customer/constants/color.dart';
import 'package:door_step_customer/models/OrdersModel.dart';
import 'package:door_step_customer/screens/home/HomePage.dart';
import 'package:door_step_customer/screens/orders/OrderDetailsScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/Constants.dart';
import '../../resources/styles_manager.dart';

class OrderListScreen extends StatefulWidget {
  OrderListScreen({super.key, required this.userPref});

  String userPref;

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();

    print('haii sfihsi ${widget.userPref}');
  }

  late final streamOrder = FirebaseDatabase.instance
      .ref('orders')
      .orderByChild('customerMobile')
      .equalTo(widget.userPref)
      .onValue;

  List<OrdersModel> ordersModelList = [];

  Future<void> fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userPref = sharedPreferences.getString('userData');

    Map<String, dynamic> userMap =
        jsonDecode(userPref!) as Map<String, dynamic>;
    String name = userMap['userName'];
    String mobileNumber = userMap['mobileNumber'];
    String userEmail = userMap['userEmail'];
    String customerId = userMap['key'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (BuildContext context) => const MyHomePage())),
        ),
        title: Text(
          'My Orders',
          style: getHeadingStyle(color: Colors.black).copyWith(fontSize: 18),
        ),
      ),
      body: Container(
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.only(top: 10, bottom: 30),
          child: StreamBuilder(
            stream: streamOrder,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!.snapshot.value as Map?;
                if (data == null) {
                  return const Text('No data');
                }

                print(snapshot.data!.snapshot.value.toString());

                Map<dynamic, dynamic>? map =
                    snapshot.data!.snapshot.value as Map?;

                print(map.toString());
                ordersModelList.clear();
                map!.forEach((key, value) {
                  // if (value['customerMobile'] == widget.userPref) {
                  ordersModelList.add(OrdersModel(
                    key,
                    value['customerId'] ?? '',
                    value['customerName'] ?? '',
                    value['customerMobile'] ?? '',
                    value['customerEmail'] ?? '',
                    value['categoryId'] ?? '',
                    value['categoryName'] ?? '',
                    value['vendorId'] ?? '',
                    value['vendorName'] ?? '',
                    value['vendorLatitude'] ?? 0.0,
                    value['vendorLongitude'] ?? 0.0,
                    value['itemsListStr'] ?? '',
                    value['itemsListImageURL'] ?? '' ?? "",
                    value['isByCall'] ?? false,
                    value['isImgSelected'] ?? false,
                    value['customerDeliveryLatitude'] ?? 0.0,
                    value['customerDeliveryLongitude'] ?? 0.0,
                    value['customerDeliveryFullAddress'] ?? '',
                    value['customerDeliveryPinCode'] ?? '',
                    value['orderType'] ?? '',
                    value['orderID'] ?? '',
                    value['orderCreatedDate'] ?? '' ?? "",
                    value['orderStatus'] ?? '' ?? "",
                    value['deliveryManId'] ?? '' ?? "",
                    value['deliveryManName'] ?? '' ?? "",
                    value['deliveryManMobileNumber'] ?? '' ?? "",
                    value['deliveryManNotes'] ?? '' ?? "",
                  ));
                  // }
                });

                // ordersModelList.sort((a, b) => b.orderCreatedDate.compareTo(a.orderCreatedDate));

                return ordersModelList.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ordersModelList.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    OrderDetailsScreen(
                                        ordersModel: ordersModelList[index])));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: primaryColor, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order Id : ${ordersModelList[index].orderID}.',
                                      style: getMediumStyle(color: Colors.black)
                                          .copyWith(fontSize: 12),
                                    ),
                                    Text(
                                      '${ordersModelList[index].orderCreatedDate}',
                                      style: getMediumStyle(color: Colors.black)
                                          .copyWith(fontSize: 10),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Order is from ${ordersModelList[index].vendorName}',
                                    style: getLightStyle(color: Colors.black)
                                        .copyWith(fontSize: 15),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    orderStatus(
                                        ordersModelList[index].orderStatus),
                                    style: getLightStyle(
                                            color: orderStatusColor(
                                                ordersModelList[index]
                                                    .orderStatus))
                                        .copyWith(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            // '${ordersModel.orderID}',
                          ),
                        ),
                      )
                    : const SizedBox();
              }
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text(snapshot.error.toString());
              }

              return const Text('....');
            },
          )),
    );
    // body: Container(
    //   child: Container(
    //     margin: const EdgeInsets.only(top: 10, bottom: 30),
    //     child: RealtimeDBPagination(
    //       query: FirebaseDatabase.instance
    //           .ref()
    //           .child('orders')
    //           .orderByChild('descending'),
    //       orderBy: 'score',
    //       descending: true,
    //       viewType: ViewType.list,
    //       itemBuilder: (context, dataSnapshot, index) {
    //         final data = dataSnapshot.value as Map<dynamic, dynamic>;
    //
    //         OrdersModel ordersModel = OrdersModel(
    //           dataSnapshot.key!,
    //           data['customerId'],
    //           data['customerName'],
    //           data['customerMobile'],
    //           data['customerEmail'],
    //           data['categoryId'],
    //           data['categoryName'],
    //           data['vendorId'],
    //           data['vendorName'],
    //           data['vendorLatitude'],
    //           data['vendorLongitude'],
    //           data['itemsListStr'],
    //           data['itemsListImageURL'] ?? "",
    //           data['isByCall'],
    //           data['isImgSelected'],
    //           data['customerDeliveryLatitude'],
    //           data['customerDeliveryLongitude'],
    //           data['customerDeliveryFullAddress'],
    //           data['customerDeliveryPinCode'],
    //           data['orderType'],
    //           data['orderID'],
    //           data['orderCreatedDate'] ?? "",
    //           data['orderStatus'] ?? "",
    //         );
    //
    //         return InkWell(
    //           onTap: () {
    //             Navigator.of(context).push(MaterialPageRoute(
    //                 builder: (BuildContext context) =>
    //                     OrderDetailsScreen(ordersModel: ordersModel)));
    //           },
    //           child: Container(
    //             padding: const EdgeInsets.all(10),
    //             margin: const EdgeInsets.all(10),
    //             decoration: BoxDecoration(
    //                 border: Border.all(color: primaryColor, width: 1),
    //                 borderRadius:
    //                     const BorderRadius.all(Radius.circular(10))),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       'Order Id : ${ordersModel.orderID}.',
    //                       style: getMediumStyle(color: Colors.black)
    //                           .copyWith(fontSize: 12),
    //                     ),
    //                     Text(
    //                       '${ordersModel.orderCreatedDate}',
    //                       style: getMediumStyle(color: Colors.black)
    //                           .copyWith(fontSize: 10),
    //                     ),
    //                   ],
    //                 ),
    //                 Container(
    //                   margin: const EdgeInsets.only(top: 10),
    //                   child: Text(
    //                     'Order is from ${ordersModel.vendorName}',
    //                     style: getLightStyle(color: Colors.black)
    //                         .copyWith(fontSize: 15),
    //                   ),
    //                 ),
    //                 Container(
    //                   margin: const EdgeInsets.only(top: 10),
    //                   child: Text(
    //                     orderStatus(ordersModel.orderStatus),
    //                     style: getLightStyle(
    //                             color: orderStatusColor(
    //                                 ordersModel.orderStatus))
    //                         .copyWith(fontSize: 15),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             // '${ordersModel.orderID}',
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // ));
  }
}
