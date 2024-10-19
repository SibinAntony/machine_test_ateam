import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


class TripMapWidget extends StatefulWidget {
  TripMapWidget({Key? key, this.args}) : super(key: key);

  Map<String, dynamic>? args;

  // double latitude;
  // double longitude;

  @override
  State<TripMapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<TripMapWidget> {
  String startLocation = "";
  String startPlace = "";
  double startLatitude = 0.0;
  double startLongitude = 0.0;

  String endPlace = "";
  double endLatitude = 0.0;
  double endLongitude = 0.0;

  CameraOptions? camera;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition? _kGoogle;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    startLatitude = widget.args!['startLatitude'];
    startLongitude = widget.args!['startLongitude'];
    endLatitude = widget.args!['endLatitude'];
    endLongitude = widget.args!['endLongitude'];
    startPlace = widget.args!['startPlace'];
    endPlace = widget.args!['endPlace'];

    print("startLatitude $startLatitude");

    List<LatLng> latLen = [
      LatLng(startLatitude, startLongitude),
      LatLng(endLatitude,endLongitude),
    ];

    _polyline.add(Polyline(
      polylineId: PolylineId('1'),
      points: latLen,
      color: Colors.green,
    ));

    _kGoogle =
        CameraPosition(
          target: LatLng(startLatitude, startLongitude),
          zoom: 11,
        );

    return  GoogleMap(
      initialCameraPosition: _kGoogle!,
      mapType: MapType.normal,
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      compassEnabled: true,
      polylines: _polyline,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

}
