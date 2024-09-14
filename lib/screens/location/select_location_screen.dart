import 'dart:convert';

import 'package:door_step_customer/constants/color.dart';
import 'package:door_step_customer/constants/show_custom_snakbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/animated_custom_dialog.dart';
import '../home/HomePage.dart';
import '../../providers/location_provider.dart';
import '../orders/MakeAnOrderDialog.dart';
import 'location_search_dialog.dart';

class SelectLocationScreen extends StatefulWidget {
  bool isDeliveryAddress = false;
  bool isFromAuthDeliveryAddress = false;
  Map? map;

  SelectLocationScreen({Key? key, required this.isDeliveryAddress, this.map,required this.isFromAuthDeliveryAddress})
      : super(key: key);

  @override
  SelectLocationScreenState createState() => SelectLocationScreenState();
}

class SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController? _controller;

  // final TextEditingController _locationController = TextEditingController();
  CameraPosition? _cameraPosition;
  TextEditingController searchController = TextEditingController();

  final DatabaseReference submitData =
      FirebaseDatabase.instance.reference().child('users');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // Provider.of<LocationProvider>(context).getCurrentLocation( false);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Position? _currentPosition;





  @override
  Widget build(BuildContext context) {
    searchController.text = Provider.of<LocationProvider>(context)
                .address
                .name ==
            null
        ? ''
        : '${Provider.of<LocationProvider>(context).address.name ?? ''}, '
            '${Provider.of<LocationProvider>(context).address.subAdministrativeArea ?? ''}, '
            '${Provider.of<LocationProvider>(context).address.isoCountryCode ?? ''}';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // CustomAppBar(title: getTranslated('select_delivery_address', context)),
              Expanded(
                child: Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(locationProvider.position.latitude,
                              locationProvider.position.longitude),
                          zoom: 15,
                        ),
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        indoorViewEnabled: true,
                        mapToolbarEnabled: true,
                        onCameraIdle: () {
                          locationProvider.updatePosition(
                              position: _cameraPosition, null, context);
                        },
                        onCameraMove: ((position) =>
                            _cameraPosition = position),
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                          if (widget.isDeliveryAddress) {
                            setDeliveryLocation(locationProvider);
                          }else{
                            if(widget.isFromAuthDeliveryAddress) {
                              locationProvider.checkLocationPermission(
                                  _controller!, context);
                            }else{
                              // locationProvider.se
                            bindExistingLocation(locationProvider);
                            }
                          }
                        },
                      ),
                      locationProvider.pickAddress != null
                          ? InkWell(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 23.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: GooglePlaceAutoCompleteTextField(
                                  textEditingController: searchController,
                                  googleAPIKey: googleApiKey,
                                  inputDecoration: const InputDecoration(
                                    hintText: "Search your location",
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                  ),
                                  countries: ["in"],

                                  getPlaceDetailWithLatLng: (prediction) {
                                    double lat = double.parse(prediction.lat!);
                                    double lng = double.parse(prediction.lng!);

                                    locationProvider.setLocation(
                                        _controller, lat, lng);
                                  },
                                  itemClick: (prediction) {
                                    searchController.text =
                                        prediction.description ?? "";
                                    searchController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: prediction
                                                    .description?.length ??
                                                0));
                                  },
                                  seperatedBuilder: const Divider(),
                                  containerHorizontalPadding: 10,
                                  itemBuilder: (context, index, prediction) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.location_on),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Expanded(
                                              child: Text(
                                                  "${prediction.description ?? ""}"))
                                        ],
                                      ),
                                    );
                                  },
                                  isCrossBtnShown: true,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {

                                locationProvider.getCurrentLocation(
                                     _controller,context);

                                // locationProvider.setLocation(_controller,11.9415915,79.8083133);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent,
                                ),
                                child: Icon(
                                  Icons.my_location,
                                  color: Theme.of(context).primaryColor,
                                  size: 35,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Visibility(
                                    visible: locationProvider.lng != 0.0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            // spreadRadius: 1,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          top: 10,
                                          bottom: 10,
                                          right: 15),
                                      alignment: Alignment.center,
                                      child: Text(
                                          '${locationProvider.address.name}'),
                                    )),
                                Container(
                                  height: 55,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(
                                      top: 20, left: 30, right: 30, bottom: 30),
                                  child: TextButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  primaryColor),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ))),
                                      onPressed: () async => {
                                            if (Provider.of<LocationProvider>(
                                                        context,
                                                        listen: false)
                                                    .lat !=
                                                0.0)
                                              {if(widget.isDeliveryAddress){
                                                confirmDelivery()
                                              }else{ saveLocation()}}
                                            else
                                              {
                                                showCustomSnackBar(
                                                    'Please choose your delivery location',
                                                    context)
                                              }
                                          },
                                      child: const Text("Use this Location",
                                          style: TextStyle(fontSize: 14))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Center(
                          child: Icon(
                        Icons.location_on,
                        color: Theme.of(context).primaryColor,
                        size: 50,
                      )),
                      locationProvider.loading
                          ? Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)))
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  late SharedPreferences sharedPref;

  saveLocation() async {
    sharedPref = await SharedPreferences.getInstance();
    String? userPref = sharedPref.getString('userData');
    Map<String, dynamic> userMap =
        jsonDecode(userPref!) as Map<String, dynamic>;

    Map<String, dynamic> newData = {
      'currentFullAddress': searchController.text,
      'currentLatitude': Provider.of<LocationProvider>(context, listen: false).lat,
      'currentLongitude': Provider.of<LocationProvider>(context, listen: false).lng,
      'currentArea': Provider.of<LocationProvider>(context, listen: false)
          .address
          .locality
          .toString(),
    };
    submitData.child(userMap['key']!).update(newData).then((value) {
      success(newData);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something failed :$error'),
        duration: const Duration(seconds: 2),
      ));
    });
  }

  Future<void> success(Map<String, dynamic> user) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString("userLocation", jsonEncode(user));

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => const MyHomePage()));

    showCustomSnackBar('Address Updated', context, isError: false);
  }

  late SharedPreferences sharedPreferences;

  Future<void> setDeliveryLocation(LocationProvider locationProvider) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? userLocationPref = sharedPreferences.getString('userLocation');
    Map<String, dynamic> userLocationMap =
        jsonDecode(userLocationPref!) as Map<String, dynamic>;
    double lat = userLocationMap['currentLatitude'];
    double lng = userLocationMap['currentLongitude'];

    locationProvider.setLocation(_controller, lat, lng);
  }

  confirmDelivery() {

    double lat= Provider.of<LocationProvider>(context, listen: false).lat;
    double lng= Provider.of<LocationProvider>(context, listen: false).lng;

    // Map<dynamic, dynamic> map = {"deliveryAddress":searchController.text,"deliveryLat":lat,"deliveryLng":lng};

    widget.map?.addAll({"customerDeliveryFullAddress":searchController.text,"customerDeliveryLatitude":lat,"customerDeliveryLongitude":lng});

    if(kDebugMode) {
      print("Order Details/n");
      print(widget.map.toString());
    }
    showAnimatedDialog(
        context,
        MakeAnOrderDialog(
          map: widget.map,
        ),
        dismissible: true,
        isFlip: false);


  }


  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("My title"),
      title: const Text("Please enable your location",style: TextStyle(fontSize: 18),),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> bindExistingLocation(LocationProvider locationProvider) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? userLocationPref = sharedPreferences.getString('userLocation');
    Map<String, dynamic> userLocationMap = jsonDecode(userLocationPref!) as Map<String, dynamic>;
    latitudeCurrent =userLocationMap['currentLatitude'] ;
    longitudeCurrent = userLocationMap['currentLongitude'];

    double itemLatitude = latitudeCurrent;
    double itemLongitude = longitudeCurrent;

    locationProvider.setLocation(_controller, itemLatitude, itemLongitude);
  }


}
