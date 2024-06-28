import 'package:door_step_customer/models/OrdersModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/Constants.dart';
import '../../constants/MapUtils.dart';
import '../../constants/color.dart';
import '../../resources/styles_manager.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderDetailsScreen({super.key, required this.ordersModel});

  OrdersModel ordersModel;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late OrdersModel ordersModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ordersModel = widget.ordersModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          'My Orders',
          style: getHeadingStyle(color: Colors.black).copyWith(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Id : ${ordersModel.orderID}.',
                    style: getMediumStyle(color: Colors.black)
                        .copyWith(fontSize: 12),
                  ),
                  Text(
                    '${ordersModel.orderCreatedDate}',
                    style: getMediumStyle(color: Colors.black)
                        .copyWith(fontSize: 10),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  'Order is from ${ordersModel.vendorName}',
                  style:
                      getLightStyle(color: Colors.black).copyWith(fontSize: 15),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(top: 10),
              //   child: Text(
              //     ordersModel.isByCall
              //         ? 'Order Placed by Phone Call'
              //         : 'Order Placed by Photo or Notes',
              //     style:
              //         getLightStyle(color: Colors.black).copyWith(fontSize: 15),
              //   ),
              // ),

              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  orderStatus(ordersModel.orderStatus),
                  style: getLightStyle(
                          color: orderStatusColor(ordersModel.orderStatus))
                      .copyWith(fontSize: 18),
                ),
              ),

              const Divider(),

              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Text(
                  'Order Details by Customer:',
                  style: getHeadingStyle(color: Colors.black)
                      .copyWith(fontSize: 15),
                ),
              ),
              // const SizedBox(height: 20,),
              ordersModel.isByCall
                  ? Container(
                      margin:
                          const EdgeInsets.only(top: 20, right: 20, bottom: 0),
                      child: Text(
                        'Order Placed by Phone Call',
                        style: getLightStyle(color: Colors.deepOrange)
                            .copyWith(fontSize: 12),
                      ),
                    )
                  : Container(),
              ordersModel.isImgSelected
                  ? Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      child: Center(
                          child: Image.network(ordersModel.itemsListImageURL)),
                    )
                  : Container(),
              ordersModel.itemsListStr.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.only(
                          top: 20, left: 0, right: 20, bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Items : ${ordersModel.itemsListStr}',
                        style: getHeadingStyle(color: Colors.black)
                            .copyWith(fontSize: 15, height: 1.5),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              Visibility(
                visible: ordersModel.orderStatus != '1',
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 15),
                      child: Text(
                        'Order Notes by Delivery Person :',
                        style: getHeadingStyle(color: Colors.black)
                            .copyWith(fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${ordersModel.deliveryManNotes}',
                        style: getLightStyle(color: Colors.black)
                            .copyWith(fontSize: 15, height: 1.5),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ),
              Visibility(
                visible: ordersModel.orderStatus != '3',
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 15),
                      child: Text(
                        'Delivery Person Details :',
                        style: getHeadingStyle(color: Colors.black)
                            .copyWith(fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 15, left: 20, right: 20, bottom: 0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${ordersModel.deliveryManName}',
                        style: getLightStyle(color: Colors.black)
                            .copyWith(fontSize: 15, height: 1.5),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        MapUtils.makeCall(ordersModel.deliveryManMobileNumber);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 9,
                            child: Container(
                              padding:
                              const EdgeInsets.only(top: 0,left: 20, bottom: 0, right: 20),
                              child: Text(
                                '${ordersModel.deliveryManMobileNumber}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: getLightStyle(color: Colors.black)
                                    .copyWith(fontSize: 15),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 15, bottom: 15, right: 0),
                                  child: const Icon(CupertinoIcons.phone_fill)))
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ),

              ordersModel.orderStatus == '1' ||
                      ordersModel.orderStatus == '2' ||
                      ordersModel.orderStatus == '3'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 30),
                          height: 150,
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Your Bill will generate after pick up your order',
                              textAlign: TextAlign.center,
                              style: getLightStyle(color: primaryColor)
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
          // '${ordersModel.orderID}',
        ),
      ),
    );
  }
}
