import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/Constants.dart';
import 'package:http/http.dart' as http;

class LocationProvider with ChangeNotifier {
  // final SharedPreferences? sharedPreferences;

  LocationProvider();

  Position _position = Position(
      altitudeAccuracy: 1,
      headingAccuracy: 1,
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  Position _pickPosition = Position(
      altitudeAccuracy: 1,
      headingAccuracy: 1,
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  bool _loading = false;

  bool get loading => _loading;

  final TextEditingController _locationController = TextEditingController();

  Position get position => _position;

  Position get pickPosition => _pickPosition;
  Placemark _address = const Placemark();
  Placemark? _pickAddress = const Placemark();

  Placemark get address => _address;

  Placemark? get pickAddress => _pickAddress;

  bool _updateAddAddressData = true;

  double _lat = 0.0;
  double _lng = 0.0;

  double get lat => _lat;

  double get lng => _lng;



  Future<void> checkLocationPermission(GoogleMapController controller,BuildContext context) async {
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied) {
      // Permission is denied, request permission
      PermissionStatus result = await Permission.location.request();
      if (result.isGranted) {
        // Permission is granted, do something
        print('Location permission granted');
        // _getCurrentPosition();
        _handleLocationPermission(controller,context);
        // return true;
      } else if (result.isDenied) {
        // Permission is denied again
        print('Location permission denied');
        // return false;
      } else if (result.isPermanentlyDenied) {
        // Permission is permanently denied, open app settings
        openAppSettings();
        // return false;
      }
    } else if (status.isGranted) {
      // Permission is already granted
      print('Location permission already granted');
      _handleLocationPermission(controller,context);
      // return false;
    }
  }

  Future<void> _handleLocationPermission(GoogleMapController controller,BuildContext context) async {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _getCurrentPosition(controller);
      // showAlertDialog(context);
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        openAppSettings();
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      openAppSettings();
      return;
    }

    _getCurrentPosition(controller);
  }


  Future<void> _getCurrentPosition(GoogleMapController mapController) async {
    if(kDebugMode) {
      print('update location start');
    }
   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      // setState(() {
      // _currentPosition = position;
      // });

     double lat=position.latitude;
     double lng=position.longitude;

      setLocation(mapController, lat, lng);
      if(kDebugMode) {
        print('update location setState');
      }
      // if(kDebugMode) {
      //   print('update location ${_currentPosition!.latitude}');
      //   print('update location ${_currentPosition!.toString()}');
      // }

    }).catchError((e) {
      debugPrint('Error found ${e.toString()}');
    });
  }





  // for get current location
  void getCurrentLocation(GoogleMapController? mapController,BuildContext _context) async {
    _loading = true;
    notifyListeners();
    Position myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      myPosition = newLocalData;


      _position = myPosition;
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(myPosition.latitude, myPosition.longitude),
              zoom: 17),
        ));
      }
      Placemark myPlaceMark;
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            myPosition.latitude, myPosition.longitude);
        Placemark place = placemarks[0];
        String address =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} - ${place.postalCode}';
        myPlaceMark =
            Placemark(name: address, locality: place.locality, administrativeArea: place.administrativeArea, postalCode: '', country: '');

        _lat=myPosition.latitude;
        _lng=myPosition.longitude;
        _address = myPlaceMark;
      } catch (e) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            myPosition.latitude, myPosition.longitude);
        Placemark place = placemarks[0];
        String address =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} - ${place.postalCode}';
        myPlaceMark =
            Placemark(name: address, locality: place.locality, administrativeArea: place.administrativeArea, postalCode: '', country: '');
        _lat=myPosition.latitude;
        _lng=myPosition.longitude;
        _address = myPlaceMark;
      }

      _locationController.text = placeMarkToAddress(_address);
      _loading = false;
      notifyListeners();

      // position.
    } catch (e) {
      // myPosition = Position(
      //   altitudeAccuracy: 1,
      //   headingAccuracy: 1,
      //   latitude: double.parse('0'),
      //   longitude: double.parse('0'),
      //   timestamp: DateTime.now(),
      //   accuracy: 1,
      //   altitude: 1,
      //   heading: 1,
      //   speed: 1,
      //   speedAccuracy: 1,
      // );
      _loading = false;
      notifyListeners();
      showAlertDialog(_context);
    }

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

  void updatePosition(String? address, BuildContext context,
      {CameraPosition? position,
      bool search = false,
      double? lat,
      double? lng}) async {
    if (_updateAddAddressData) {
      _loading = true;
      notifyListeners();
      try {
        // _position = position!;

        // if (fromAddress) {
        _position = Position(
          altitudeAccuracy: 1,
          headingAccuracy: 1,
          latitude: search ? lat! : position!.target.latitude,
          // latitude: 11.9415915,
          longitude: search ? lng! : position!.target.longitude,
          // longitude: 79.8083133,
          timestamp: DateTime.now(),
          heading: 1,
          accuracy: 1,
          altitude: 1,
          speedAccuracy: 1,
          speed: 1,
        );
        // }
        // else {
        //   _pickPosition = Position(
        //     altitudeAccuracy: 1,
        //     headingAccuracy: 1,
        //     latitude: position!.target.latitude,
        //     longitude: position.target.longitude,
        //     timestamp: DateTime.now(),
        //     heading: 1,
        //     accuracy: 1,
        //     altitude: 1,
        //     speedAccuracy: 1,
        //     speed: 1,
        //   );
        // }
        // if (_changeAddress) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            search ? lat! : position!.target.latitude,
            search ? lng! : position!.target.longitude);
        Placemark place = placemarks[0];
        String? addresss =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} - ${place.postalCode}';

        print("placeDetails->  ${place.toString()}");
        // print("placeDetails->  ${position!.target.longitude}");

        // fromAddress
        //     ?
        _address = Placemark(name: addresss,locality: place.locality, administrativeArea: place.administrativeArea);
        //     :
        // _pickAddress = Placemark(name: addresss);

        _lat= search ? lat! : position!.target.latitude;
        _lng= search ? lng! : position!.target.longitude;


        if (address != null) {
          _locationController.text = address;
        } else {
          // if (fromAddress) {
          _locationController.text = placeMarkToAddress(_address);
        }

        // }
        // } else {
        //   _changeAddress = true;
        // }
      } catch (e) {
        print("Error -->");
        if (kDebugMode) {
          print(e.toString());
          print(e);
        }
      }
      _loading = false;
      notifyListeners();
    } else {
      _updateAddAddressData = true;
    }
  }

  void setLocation(
      GoogleMapController? mapController, double lat, double lng) async {
    _loading = true;
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 17),
      ));
    }
    Placemark myPlaceMark;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      String address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} - ${place.postalCode}';
      myPlaceMark =
          Placemark(name: address, locality: place.locality, postalCode: '', administrativeArea: place.administrativeArea, country: '');
      _lat=lat;
      _lng=lng;
      _address = myPlaceMark;
    } catch (e) {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      String address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} - ${place.postalCode}';
      myPlaceMark =
          Placemark(name: address, locality: place.locality, administrativeArea: place.administrativeArea, postalCode: '', country: '');
      _lat=lat;
      _lng=lng;
      _address = myPlaceMark;
    }
    // _address = myPlaceMark;
    _locationController.text = placeMarkToAddress(_address);
    _loading = false;
    notifyListeners();
  }

  String placeMarkToAddress(Placemark placeMark) {
    return '${placeMark.name ?? ''}'
        ' ${placeMark.subAdministrativeArea ?? ''}'
        ' ${placeMark.isoCountryCode ?? ''}';
  }


  double _finalPrice=0.0;
  double get finalPrice=>_finalPrice;

  Future<void> calculateFinalPrice(double startLat, double startLng, double endLat, double endLng) async {

    try {
      double distance = await getRoadDistance(startLat, startLng, endLat, endLng);

      double amount=20.0;
      if(distance<=2){
        amount=20.0;
        print('Rs $amount');
      }else{
        distance=distance-2;
        amount=amount*distance;
        print('Rs $amount');
      }
      print('Distance: $distance km');
      _finalPrice=amount;
      notifyListeners();
      // return distance;
    } catch (e) {
      print(e);
     // return 0.0;

    }
  }


  Future<double> getRoadDistance(double startLat, double startLng, double endLat, double endLng) async {
    // final apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

    // Directions API endpoint
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=$googleApiKey');

    // Send the request
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the response
      final data = json.decode(response.body);

      if (data['routes'].isNotEmpty) {
        // Distance is in meters
        final distanceMeters = data['routes'][0]['legs'][0]['distance']['value'];
        final distanceKilometers = distanceMeters / 1000;
        return distanceKilometers;
      } else {
        throw Exception('No route found');
      }
    } else {
      throw Exception('Failed to load directions');
    }
  }
}
