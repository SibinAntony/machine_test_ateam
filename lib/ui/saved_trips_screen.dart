import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/adapters.dart';

import '../data/trip_db.dart';
import '../utils/constant.dart';

class SavedTripScreen extends StatefulWidget {
  const SavedTripScreen({super.key});

  @override
  State<SavedTripScreen> createState() => _SavedTripScreenState();
}

class _SavedTripScreenState extends State<SavedTripScreen> {

  List tripList = [];

  @override
  void initState() {
    super.initState();
    getTripData();
  }

  getTripData() {
    tripList = TripDB.getAllUsers();
    setState(() {});

    print("tripList.toString()");
    print(tripList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Saved Trip Screen',
        home: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(150.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: const Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Robert Doe',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            'robertdoe@gmail.com',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
          body: Container(
            color: Colors.white,
            child: tripList.isEmpty // To show when no data is stored
                ? const Center(
                    child: Text(
                    "No Trip Found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ))
                : SingleChildScrollView(
                  child: Column(
                      children: List.generate(tripList.length, (index) {
                      final userData = tripList[index];
                      Completer<GoogleMapController> _controller = Completer();
                      List<LatLng> latLen = [
                        LatLng(userData!['startLatitude'], userData!['startLongitude']),
                        LatLng(userData!['endLatitude'],userData!['endLongitude']),
                      ];

                      final Set<Polyline> _polyline = {};

                      _polyline.add(Polyline(
                        polylineId: PolylineId('1'),
                        points: latLen,
                        color: Colors.green,
                      ));

                      CameraPosition? _kGoogle =
                          CameraPosition(
                            target: LatLng(userData!['startLatitude'], userData!['startLongitude']),
                            zoom: 11,
                          );

                      return   InkWell(
                        onTap: (){
                          Map<String, dynamic> args = {
                            "startLongitude": userData!['startLongitude'],
                            "startLatitude": userData!['startLatitude'],
                            "endLongitude": userData!['endLatitude'],
                            "endLatitude": userData!['endLongitude'],
                            "startPlace": userData!['startPlace'],
                            "endPlace": userData!['endPlace'],
                          };

                          Navigator.pushNamed(context, '/trip_screen', arguments: args);
                        },
                        child: Card(
                          elevation: 1,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            // padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 4.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: primaryColor,
                                width: 1, // Border width
                              ),
                            ),
                            child: Container(
                              height: 250,
                              child: GoogleMap(
                                initialCameraPosition: _kGoogle,
                                mapType: MapType.normal,
                                // markers: _markers,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                compassEnabled: true,
                                polylines: _polyline,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList()),
                ),
          ),
          bottomNavigationBar: Container(
            height: 80,
            color: primaryColor,
            child: Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Go Back',
                    style: TextStyle(color: primaryColor),
                  )),
            ),
          ),
        ));
  }
}
