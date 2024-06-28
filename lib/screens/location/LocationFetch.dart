import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:door_step_customer/resources/styles_manager.dart';
import 'package:door_step_customer/screens/orders/OrderSuccessScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';
// import 'package:flutter_address_from_latlng/flutter_address_from_latlng.dart';

import '../../constants/color.dart';
import '../../widgets/animated_custom_dialog.dart';
import '../orders/MakeAnOrderDialog.dart';

class LocationFetch extends StatefulWidget {
  LocationFetch({super.key, this.map, required this.placeOrder});

  bool placeOrder;
  Map? map;

  @override
  State<LocationFetch> createState() => _LocationFetchState();
}

class _LocationFetchState extends State<LocationFetch> {
  TextEditingController controllerLocation = TextEditingController();
  TextEditingController controllerSearchLocation = TextEditingController();
  late GoogleMapController mapController;
  late Marker marker;

  bool isLoading = false;

  CameraPosition? _cameraPosition;
  String address = "null";
  String autocompletePlace = "null";
  Prediction? initialValue;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLocation();
    marker = Marker(
      markerId: const MarkerId('SF'),
      position: LatLng(latitudeCurrent, longitudeCurrent),
      infoWindow: const InfoWindow(
        title: 'San Francisco',
        snippet: 'A great city!',
      ),
    );

    // final coordinates = new Coordinates(position.latitude, position.longitude);
    // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = addresses.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Address',
          style: getHeadingStyle(color: Colors.black).copyWith(fontSize: 18),
        ),
      ),
      // body: Stack(
      //   children: [
      //     Container(
      //       color: Colors.grey,
      //       child: GoogleMap(
      //         initialCameraPosition: CameraPosition(
      //           target: LatLng(latitudeCurrent, longitudeCurrent),
      //           // San Francisco coordinates
      //           zoom: 15.0,
      //         ),
      //         mapType: MapType.normal,
      //         zoomControlsEnabled: false,
      //         myLocationButtonEnabled: true,
      //         onMapCreated: (GoogleMapController controller) {
      //           mapController = controller;
      //         },
      //         markers: Set<Marker>.of(<Marker>{
      //           marker,
      //         }),
      //       ),
      //     ),
      //     Container(
      //       color: Colors.white,
      //       margin:
      //           const EdgeInsets.only(top: 20, left: 30, right: 20, bottom: 0),
      //       child: TextFormField(
      //         controller: controllerSearchLocation,
      //         decoration: InputDecoration(
      //           // icon: Icons.search,
      //           labelText: "Search Location",
      //           labelStyle: const TextStyle(color: primaryColor),
      //           fillColor: primaryColor,
      //           counterText: "",
      //           focusedBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(15.0),
      //             borderSide: const BorderSide(
      //               color: primaryColor,
      //               width: 2.0,
      //             ),
      //           ),
      //           enabledBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(15.0),
      //             borderSide: const BorderSide(
      //               color: primaryColor,
      //             ),
      //           ),
      //         ),
      //         maxLines: 1,
      //       ),
      //     ),
      //   ],
      // ),
      // bottomSheet: Container(
      //   height: MediaQuery.of(context).size.width / 2,
      //   margin: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 0),
      //   child: SingleChildScrollView(
      //     child: Column(
      //       children: [
      //         Container(
      //           padding: const EdgeInsets.only(
      //               top: 0, left: 0, right: 0, bottom: 20),
      //           child: TextFormField(
      //             controller: controllerLocation,
      //             decoration: InputDecoration(
      //               labelText: "Delivery Location",
      //               labelStyle: const TextStyle(color: primaryColor),
      //               fillColor: primaryColor,
      //               counterText: "",
      //               focusedBorder: OutlineInputBorder(
      //                 borderRadius: BorderRadius.circular(15.0),
      //                 borderSide: const BorderSide(
      //                   color: primaryColor,
      //                   width: 2.0,
      //                 ),
      //               ),
      //               enabledBorder: OutlineInputBorder(
      //                 borderRadius: BorderRadius.circular(15.0),
      //                 borderSide: const BorderSide(
      //                   color: primaryColor,
      //                 ),
      //               ),
      //             ),
      //             maxLines: 1,
      //           ),
      //         ),
      //         Stack(
      //           children: [
      //             Visibility(
      //               visible: !isLoading,
      //               child: Container(
      //                 height: 55,
      //                 width: MediaQuery.of(context).size.width,
      //                 margin: const EdgeInsets.only(
      //                     top: 20, left: 0, right: 0, bottom: 20),
      //                 child: TextButton(
      //                     style: ButtonStyle(
      //                         foregroundColor: MaterialStateProperty.all<Color>(
      //                             Colors.white),
      //                         backgroundColor: MaterialStateProperty.all<Color>(
      //                             primaryColor),
      //                         shape: MaterialStateProperty.all<
      //                                 RoundedRectangleBorder>(
      //                             const RoundedRectangleBorder(
      //                           borderRadius:
      //                               BorderRadius.all(Radius.circular(15)),
      //                         ))),
      //                     onPressed: () async => {
      //                           widget.placeOrder
      //                               ? makeAnOrder()
      //                               : confirmLocation()
      //                         },
      //                     child: const Text("Confirm Delivery Location",
      //                         style: TextStyle(fontSize: 14))),
      //               ),
      //             ),
      //             Visibility(
      //               visible: isLoading,
      //               child: Container(
      //                   alignment: Alignment.center,
      //                   margin: const EdgeInsets.only(
      //                       top: 20, left: 30, right: 30, bottom: 30),
      //                   child: const CircularProgressIndicator(
      //                     color: primaryColor,
      //                   )),
      //             )
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

     body: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         PlacesAutocomplete(
           // searchController: _controller,
           apiKey: googleApiKey,
           // mounted: mounted,
           // hideBackButton: true,
           onSuggestionSelected: ( result) {
             if (result != null) {
               setState(() {
                 autocompletePlace = result.structuredFormatting!.mainText.toString() ?? "";
               });
             }
           },
         ),
         OutlinedButton(
           child: Text('show dialog'.toUpperCase()),
           onPressed: () {
             showDialog(
               context: context,
               builder: (context) {
                 return AlertDialog(
                   title: const Text('Example'),
                   content: PlacesAutocomplete(
                     apiKey: googleApiKey,
                     searchHintText: "Search for a place",
                     // mounted: mounted,
                     // hideBackButton: true,
                     // initialValue: initialValue,
                     onSuggestionSelected: (value) {
                       setState(() {
                         autocompletePlace = value!.structuredFormatting?.mainText ?? "";
                         initialValue = value;
                       });
                     },

                     // onGetDetailsByPlaceId: (value) {
                     //   setState(() {
                     //     address = value?.result.formattedAddress ?? "";
                     //   });
                     // },
                   ),
                   actions: <Widget>[
                     TextButton(
                       child: const Text('Done'),
                       onPressed: () => Navigator.of(context).pop(),
                     ),
                   ],
                 );
               },
             );
           },
         ),
         const Spacer(),
         const Padding(
           padding: EdgeInsets.all(8.0),
           child: Text(
             "Google Map Location Picker\nMade By Arvind 😃 with Flutter 🚀",
             textAlign: TextAlign.center,
             textScaleFactor: 1.2,
             style: TextStyle(
               color: Colors.grey,
             ),
           ),
         ),
         TextButton(
           onPressed: () => Clipboard.setData(
             const ClipboardData(text: "https://www.mohesu.com"),
           ).then(
                 (value) => ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(
                 content: Text("Copied to Clipboard"),
               ),
             ),
           ),
           child: const Text("https://www.mohesu.com"),
         ),
         const Spacer(),
         Center(
           child: ElevatedButton(
             child: const Text('Pick location'),
             onPressed: () async {
               Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) {
                     return GoogleMapLocationPicker(
                       apiKey: googleApiKey,
                       // popOnNextButtonTaped: true,
                       currentLatLng: const LatLng(29.146727, 76.464895),
                       onNext: (GeocodingResult? result) {
                         if (result != null) {
                           setState(() {
                             address = result.formattedAddress ?? "";
                           });
                         }
                       },
                       onSuggestionSelected: (result){

                       },
                       // onSuggestionSelected: (PlacesDetailsResponse? result) {
                       //   if (result != null) {
                       //     setState(() {
                       //       autocompletePlace =
                       //           result.result.formattedAddress ?? "";
                       //     });
                       //   }
                       // },
                     );
                   },
                 ),
               );
             },
           ),
         ),
         const Spacer(),
         ListTile(
           title: Text("Geocoded Address: $address"),
         ),
         ListTile(
           title: Text("Autocomplete Address: $autocompletePlace"),
         ),
         const Spacer(
           flex: 3,
         ),
       ],
     ),
    );
  }

  Future<void> getUserLocation() async {


    print('haii formattedAddress');

    // try {
    //   String formattedAddress =
    //       await FlutterAddressFromLatLng().getFormattedAddress(
    //     latitude: latitudeCurrent,
    //     longitude: longitudeCurrent,
    //     googleApiKey: googleApiKey,
    //   );
    //   print('haii $formattedAddress');
    //
    //   controllerLocation.text = formattedAddress;
    // } on Exception catch (e) {
    //   print('haii ${e.toString()}');
    // }
  }

  confirmLocation() {}

  makeAnOrder() {
    showAnimatedDialog(
        context,
        MakeAnOrderDialog(
          map: widget.map,
        ),
        dismissible: true,
        isFlip: false);
  }
}
