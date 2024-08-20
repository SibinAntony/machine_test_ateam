import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';

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

  // for get current location
  void getCurrentLocation({GoogleMapController? mapController}) async {
    _loading = true;
    notifyListeners();
    Position myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      myPosition = newLocalData;

      // position.
    } catch (e) {
      myPosition = Position(
        altitudeAccuracy: 1,
        headingAccuracy: 1,
        latitude: double.parse('0'),
        longitude: double.parse('0'),
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1,
      );
    }
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
}
