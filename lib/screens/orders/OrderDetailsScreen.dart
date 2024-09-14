import 'package:door_step_customer/models/OrdersModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/Constants.dart';
import '../../constants/MapUtils.dart';
import '../../constants/color.dart';
import '../../resources/styles_manager.dart';
import '../../widgets/animated_custom_dialog.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderDetailsScreen({super.key,  this.ordersModel,this.orderId});

  OrdersModel? ordersModel;
  String? orderId;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late OrdersModel ordersModel;

  late String totalAmount;
  late double deliveryCharge;
  late double orderAmount;

  late var streamOrder = FirebaseDatabase.instance
      .ref('orders')
      .orderByChild('orderID')
      .equalTo(widget.orderId)
      .onValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ordersModel = widget.ordersModel!;

    deliveryCharge=double.parse(ordersModel.deliveryCharge);
    orderAmount=double.parse(ordersModel.totalAmount.isEmpty?'0.0':ordersModel.totalAmount);

    double totalAmt=deliveryCharge+orderAmount;
    totalAmount=totalAmt.toString();

    print('Order Status ${ordersModel.orderStatus}');
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
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            child: StreamBuilder(
              stream: streamOrder,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data?.snapshot.value as Map?;
                  if (data == null) {
                    return const Text('No data');
                  }

                  Map<dynamic, dynamic>? map =
                  snapshot.data!.snapshot.value as Map?;

                  map!.forEach((key, value) {
                    ordersModel=OrdersModel(
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
                      value['deliveryManNotes'] ?? '' ,
                      value['deliveryCharge']??'',
                      value['totalAmount']??'',
                      value['billURL']??'',
                      value['paymentType']??'',
                    );
                  });


                  print('key-> ${data.keys.toString()}');
                  print('value-> ${data.values..toString()}');


                  return Container(
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
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            'Delivery Address :\n${ordersModel.customerDeliveryFullAddress}',
                            style: getMediumStyle(color: Colors.black)
                                .copyWith(fontSize: 15,height: 1.6),
                          ),
                        ),
                        Container(
                          // visible: ordersModel.orderStatus == '3'?true:false,
                          child: Column(
                            children: [
                              const Divider(),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(top: 10,bottom: 15),
                                child: Text(
                                  'Order Bill Details:',
                                  style: getHeadingStyle(color: Colors.black)
                                      .copyWith(fontSize: 15),
                                ),
                              ),
                              Container(  margin: const EdgeInsets.only(bottom: 10),child:
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Delivery Charge:',
                                    style:
                                    getMediumStyle(color: Colors.black).copyWith(fontSize: 13),
                                  ),
                                  Text(
                                    'Rs. ${deliveryCharge.toString()}',
                                    style:
                                    getMediumStyle(color: Colors.black).copyWith(fontSize: 13),
                                  ),
                                ],),),
                              Visibility(
                                visible: ordersModel.totalAmount.isEmpty?false:true,
                                child: Container(  margin: const EdgeInsets.only(bottom: 10),child:
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Order Amount:',
                                      style:
                                      getMediumStyle(color: Colors.black).copyWith(fontSize: 13),
                                    ),
                                    Text(
                                      'Rs. ${orderAmount.toString()}',
                                      style:
                                      getMediumStyle(color: Colors.black).copyWith(fontSize: 13),
                                    ),
                                  ],),),
                              ),
                              Visibility(
                                visible: ordersModel.totalAmount.isEmpty?false:true,
                                child: Container(  margin: const EdgeInsets.only(bottom: 10),child:
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Total Amount:',
                                      style:
                                      getMediumStyle(color: Colors.black).copyWith(fontSize: 13),
                                    ),
                                    Text(
                                      'Rs. $totalAmount',
                                      style:
                                      getMediumStyle(color: Colors.black).copyWith(fontSize: 13),
                                    ),
                                  ],),),
                              ),
                              Visibility(
                                visible: ordersModel.billURL.isEmpty?false:true,
                                child: Container(  margin: const EdgeInsets.only(bottom: 10),child:
                                InkWell(onTap: (){
                                  showAnimatedDialog(
                                      context,
                                      Image.network(
                                        ordersModel.billURL,
                                        fit: BoxFit.fill,
                                        loadingBuilder: (BuildContext context, Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                      dismissible: true,
                                      isFlip: false);
                                },
                                  child: Align(
                                    alignment:Alignment.centerRight,
                                    child: Text(
                                      'View Bill here',
                                      style: getMediumStyle(color: Colors.black).copyWith(
                                          fontWeight: FontWeight.w600, fontSize: 12,decoration: TextDecoration.underline, decorationThickness: 2,fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),),
                              ),
                              const SizedBox(height: 20,),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: ordersModel.paymentType.isEmpty?false:true,
                          child: Container(  margin: const EdgeInsets.only(bottom: 10),child:
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Payment Method:',
                                style:
                                getMediumStyle(color: Colors.black).copyWith(fontSize: 13),
                              ),
                              Text(
                                '${ordersModel.paymentType}',
                                style:
                                getMediumStyle(color: Colors.black).copyWith(fontSize: 13),
                              ),
                            ],),),
                        ),
                        const Divider(),
                        Visibility(
                          visible: ordersModel.deliveryManNotes.isNotEmpty?true:false,
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
                                    top: 20, left: 0, right: 20, bottom: 10),
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
                          visible: ordersModel.orderStatus != '1' ,
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
                                    top: 15, left: 0, right: 20, bottom: 0),
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
                                        const EdgeInsets.only(top: 0,left: 0, bottom: 0, right: 20),
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
                                        left: 20, right: 20, bottom: 30),
                                    height: 150,
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Your final Bill will generate after pick up your order',
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
                  );

                  print('final data ${data.toString()}');

                }
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Text(snapshot.error.toString());
                }

                return const Text('....');
              },
            )),

      ),
    );
  }
}
