// import 'dart:io';

import 'dart:convert';
import 'dart:io';

import 'package:door_step_customer/constants/show_custom_snakbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/color.dart';
import '../../providers/location_provider.dart';
import '../../resources/styles_manager.dart';
import 'OrderSuccessScreen.dart';

class MakeAnOrderDialog extends StatefulWidget {
  MakeAnOrderDialog({super.key, this.map});

  Map? map;

  @override
  State<MakeAnOrderDialog> createState() => _MakeAnOrderDialogState();
}

class _MakeAnOrderDialogState extends State<MakeAnOrderDialog> {
  final DatabaseReference submitData =
      FirebaseDatabase.instance.reference().child('orders');

  late Map map;
late     double finalPrice;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {

    });

  }

  @override
  Widget build(BuildContext context) {
    map = widget.map!;
    double startLat = widget.map!["vendorLatitude"]; // Example starting point (San Francisco)
    double startLng = widget.map!["vendorLongitude"];
    double endLat = widget.map!["customerDeliveryLatitude"];   // Example destination (Los Angeles)
    double endLng = widget.map!["customerDeliveryLongitude"];



    Provider.of<LocationProvider>(context).calculateFinalPrice(startLat, startLng, endLat, endLng);

    return  Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          finalPrice=locationProvider.finalPrice;
       return   Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: false,
            child: Container(
              margin:
                  const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
              child: Text(
                'Upto 2 km - Rs. 30, above 2km - Rs. 10/km',
                textAlign: TextAlign.center,
                style: getMediumStyle(color: Colors.black)
                    .copyWith(fontSize: 12, height: 1.5),
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 0),
            child: Text(
              'Based on your Delivery Address',
              textAlign: TextAlign.center,
              style: getHeadingStyle(color: Colors.black)
                  .copyWith(fontSize: 17, height: 1.5),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
            child: Text(
              'Your Delivery charge is \nRs. ${locationProvider.finalPrice}',
              textAlign: TextAlign.center,
              style: getHeadingStyle(color: Colors.black)
                  .copyWith(fontSize: 20, height: 1.5),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 0),
            child: Text(
              'Your Order Bill will Generate after pick your order',
              textAlign: TextAlign.center,
              style: getHeadingStyle(color: Colors.black)
                  .copyWith(fontSize: 15, height: 1.5),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 0),
            child: Text(
              'After the confirmation you can not cancel the order ',
              textAlign: TextAlign.center,
              style: getHeadingStyle(color: Colors.black)
                  .copyWith(fontSize: 13, height: 1.5),
            ),
          ),
          Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            margin:
                const EdgeInsets.only(top: 30, left: 0, right: 0, bottom: 20),
            child: TextButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ))),
                onPressed: () async => {confirmOrder(context)},
                child: const Text("CONFIRM MY ORDER",
                    style: TextStyle(fontSize: 14))),
          )
        ],
      ),
    );}
    );
  }



  late String orderID = '';

  confirmOrder(BuildContext context) {

    if(finalPrice<1){
      showCustomSnackBar('Please wait for the delivery charge', context,isToaster: true);
      return;
    }

    String? newKey = submitData.push().key;

    DateTime date = DateTime.now();
    String formattedDate = DateFormat('dd-MMM-yy hh:mm a').format(date);
    String formattedDate1 = DateFormat('ddMMyyhhmm').format(date);

    String orderTime = DateTime.now().toString().split(":").last;

    orderID = 'OR' + formattedDate1 + orderTime;
    bool isImgSelected = map['isImgSelected'];

    Map mapDeliveryAddress = {

      'orderType': orderTypeRes,
      'orderID': orderID,
      'orderCreatedDate': formattedDate,
      'orderStatus': '1',
      'deliveryCharge':finalPrice.toString()

    };


    map.addAll(mapDeliveryAddress);

    if (isImgSelected) {
      File itemsListImage = map['itemsListImage'];
      map.remove('itemsListImage');
      createDownloadURL(itemsListImage, newKey!);
    } else {
      map.remove('itemsListImage');

      print(map.toString());
      createOrder(newKey!);
    }
  }

  Future<void> createDownloadURL(File itemsListImage, String newKey) async {
    String? downloadLink;

    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('orders')
          .child('order_${DateTime.now().toString()}');
      UploadTask uploadTask = ref.putFile(
        itemsListImage,
        SettableMetadata(contentType: 'image/png'),
      );
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => {});

      // Get the URL of the uploaded image
      downloadLink = await storageTaskSnapshot.ref.getDownloadURL();

      map["itemsListImageURL"] = downloadLink;

      createOrder(newKey);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to upload image: $e'),
        duration: const Duration(seconds: 2),
      ));
      print('Failed to upload image: $e');
      Navigator.of(context).pop();
    }
  }

  void createOrder(String newKey) {
    print(map.toString());

    submitData.child(newKey).set(map).then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => OrderSuccessScreen(
                    orderID: orderID,
                map: map,
                  )));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something failed :$error'),
        duration: const Duration(seconds: 2),
      ));
      Navigator.of(context).pop();
    });
  }



}
