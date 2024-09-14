import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/MapUtils.dart';
import '../../constants/color.dart';
import '../../constants/show_custom_snakbar.dart';
import '../../models/VendorsModel.dart';
import '../../resources/styles_manager.dart';
import '../../widgets/animated_custom_dialog.dart';
import '../location/LocationFetch.dart';
import '../location/select_location_screen.dart';
import '../orders/MakeAnOrderDialog.dart';

class VendorDetails extends StatefulWidget {
  VendorDetails({super.key, required this.vendorsModel});

  VendorsModel vendorsModel;

  @override
  State<VendorDetails> createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails> {
  TextEditingController controllerItemsList = TextEditingController();
  late VendorsModel vendorsModel;

  late bool isCallChecked = false;
  bool isLoading = false;
  bool isImgSelected = false;

  File? file;
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vendorsModel = widget.vendorsModel;
  }



  // pick image
  Future selectCamera() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        isImgSelected = true;
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }
 Future selectGallery() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        isImgSelected = true;
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
        latitudeCurrent,
        longitudeCurrent,
        double.parse(vendorsModel.vendorLatitude),
        double.parse(vendorsModel.vendorLongitude));

    _distanceBetweenLastTwoLocations = _distanceBetweenLastTwoLocations / 1000;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${vendorsModel.vendorName}',
            style: getHeadingStyle(color: Colors.black).copyWith(fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(vendorsModel.vendorImage)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: Text(
                vendorsModel.vendorName,
                maxLines: 2,
                textAlign: TextAlign.center,
                // overflow: TextOverflow.ellipsis,
                style: getMediumStyle(color: Colors.black)
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              alignment: Alignment.center,
              child: Text(
                vendorsModel.categoryName,
                // overflow: TextOverflow.ellipsis,
                style: getMediumStyle(color: Colors.black)
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 12),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: Text(
                '${_distanceBetweenLastTwoLocations.toStringAsFixed(2)} KM',
                // overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: getHeadingStyle(color: Colors.green)
                    .copyWith(fontWeight: FontWeight.w800, fontSize: 10),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 30, left: 30, right: 30, bottom: 0),
              child: Text(
                textAlign: TextAlign.center,
                'For Quick Order at ${vendorsModel.vendorName} please add your items by below any method',
                // overflow: TextOverflow.ellipsis,
                style: getMediumStyle(color: Colors.black)
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                  top: 30, left: 30, right: 30, bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                // border: Border()
              ),
              height: 150,
              child: TextFormField(
                controller: controllerItemsList,
                maxLines: 10,
                minLines: 10,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  labelText: "Enter the Items You Want",
                  labelStyle: const TextStyle(color: primaryColor),
                  fillColor: primaryColor,
                  counterText: "",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: primaryColor,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'OR',
              // overflow: TextOverflow.ellipsis,
              style: getMediumStyle(color: Colors.black)
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            InkWell(
              onTap: () {
                selectImage();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    top: 30, left: 30, right: 30, bottom: 30),
                margin: const EdgeInsets.only(
                    top: 20, left: 30, right: 30, bottom: 30),
                decoration: BoxDecoration(
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(15.0),
                    color: primaryColor),
                child: Center(
                  child: isImgSelected
                      ? Image.file(file!,
                          width: 100, height: 100, fit: BoxFit.fill)
                      : Text(
                          'Upload Image by Camera or Gallery',
                          style: getMediumStyle(color: Colors.white).copyWith(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                ),
              ),
            ),
            Text(
              'OR',
              // overflow: TextOverflow.ellipsis,
              style: getMediumStyle(color: Colors.black)
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            InkWell(onTap: (){
              MapUtils.makeCall('+${vendorsModel.mobileNumber}');
            },
              child: Container(
                margin: const EdgeInsets.only(
                    top: 30, left: 30, right: 30, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: const Icon(Icons.call)),
                    Text(
                      'Call us Directly',
                      // overflow: TextOverflow.ellipsis,
                      style: getHeadingStyle(color: Colors.black)
                          .copyWith(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30, top: 8),
              child: Text(
                'After making a order by Call. Please check below checkbox and make an order',
                // overflow: TextOverflow.ellipsis,
                style: getLightStyle(color: Colors.black)
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 0, right: 0, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    value: isCallChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isCallChecked = value!;
                      });
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 0, right: 30, top: 0),
                    child: Text(
                      'Please check if you make your order by call',
                      // overflow: TextOverflow.ellipsis,
                      style: getLightStyle(color: Colors.black)
                          .copyWith(fontWeight: FontWeight.w600, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Visibility(
                  visible: !isLoading,
                  child: Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        top: 0, left: 30, right: 30, bottom: 50),
                    child: TextButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ))),
                        onPressed: () async => {makeAnOrder()},
                        child: const Text("Make an Order",
                            style: TextStyle(fontSize: 14))),
                  ),
                ),
                Visibility(
                  visible: isLoading,
                  child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                          top: 20, left: 30, right: 30, bottom: 30),
                      child: const CircularProgressIndicator(
                        color: primaryColor,
                      )),
                )
              ],
            ),
          ],
        )));
  }

  makeAnOrder() async {
    if (controllerItemsList.text.isNotEmpty || isImgSelected || isCallChecked) {
      // showCustomSnackBar("Make an order", context);

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? userPref = sharedPreferences.getString('userData');
      String? deviceToken = sharedPreferences.getString('deviceToken');

      Map<String, dynamic> userMap =
          jsonDecode(userPref!) as Map<String, dynamic>;
      String name = userMap['userName'];
      String mobileNumber = userMap['mobileNumber'];
      String userEmail = userMap['userEmail'];
      String customerId = userMap['key'];

      Map<dynamic, dynamic> map = {
        'customerId': customerId,
        'customerName': name,
        'customerMobile': mobileNumber,
        'customerEmail': userEmail,
        'categoryId': vendorsModel.categoryKey,
        'categoryName': vendorsModel.categoryName,
        'vendorId': vendorsModel.key,
        'vendorName': vendorsModel.vendorName,
        'vendorLatitude':double.parse(vendorsModel.vendorLatitude) ,
        'vendorLongitude': double.parse(vendorsModel.vendorLongitude),
        'itemsListStr': controllerItemsList.text,
        'itemsListImage': file,
        'isByCall': isCallChecked,
        'isImgSelected': isImgSelected,
        'customerDeviceToken': deviceToken
      };

      print('checkdata $map');


      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>  SelectLocationScreen(isDeliveryAddress: true,map: map,isFromAuthDeliveryAddress: false)));


      // showAnimatedDialog(
      //     context,
      //     MakeAnOrderDialog(
      //       map: map,
      //     ),
      //     dismissible: true,
      //     isFlip: false);

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => LocationFetch(placeOrder: true, map: map)));
    } else {
      showCustomSnackBar(
          "Please choose any method to make your order", context);
    }
  }

  void selectImage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:  Text("Choose below option to upload image",style: getMediumStyle(color: Colors.black)
                .copyWith(fontWeight: FontWeight.w400, fontSize: 16),),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);  //Close your current dialog
                    selectGallery();
                  },
                  child:  Text("Gallery",  style: getMediumStyle(color: Colors.black)
                      .copyWith(fontWeight: FontWeight.w400, fontSize: 13),)),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);  //Close your current dialog
                    selectCamera();
                  },
                  child: Text("Camera",  style: getMediumStyle(color: Colors.black)
              .copyWith(fontWeight: FontWeight.w400, fontSize: 13),)),
            ],
          );
        });
  }
}
