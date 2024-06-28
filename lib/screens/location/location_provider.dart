import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';

class LocationProvider with ChangeNotifier {
  // final SharedPreferences? sharedPreferences;

  LocationProvider();

  Position _position = Position( altitudeAccuracy:1, headingAccuracy:1,longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1 );
  Position _pickPosition = Position(altitudeAccuracy:1, headingAccuracy:1,longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1 );
  bool _loading = false;
  bool get loading => _loading;
  bool _isBilling = true;
  bool get isBilling =>_isBilling;
  final TextEditingController _locationController = TextEditingController();

  Position get position => _position;
  Position get pickPosition => _pickPosition;
  Placemark _address = Placemark();
  Placemark? _pickAddress = Placemark();

  Placemark get address => _address;
  Placemark? get pickAddress => _pickAddress;
  final List<Marker> _markers = <Marker>[];
  TextEditingController get locationController => _locationController;

  List<Marker> get markers => _markers;

  bool _buttonDisabled = true;
  bool _changeAddress = true;
  GoogleMapController? _mapController;

  bool _updateAddAddressData = true;

  bool get buttonDisabled => _buttonDisabled;
  GoogleMapController? get mapController => _mapController;


  List<String> _restrictedCountryList = [];
  List<String> get restrictedCountryList =>_restrictedCountryList;


  final List<String> _zipNameList = [];
  List<String> get zipNameList => _zipNameList;

  final TextEditingController _searchZipController = TextEditingController();
  TextEditingController get searchZipController => _searchZipController;

  final TextEditingController _searchCountryController = TextEditingController();
  TextEditingController get searchCountryController => _searchCountryController;

  void setLocationController(String text) {
    _locationController.text = text;
  }


  // for get current location
  void getCurrentLocation(BuildContext context, bool fromAddress, {GoogleMapController? mapController}) async {
    _loading = true;
    notifyListeners();
    Position myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      myPosition = newLocalData;
    }catch(e) {
      myPosition = Position( altitudeAccuracy:1, headingAccuracy:1,
        latitude: double.parse('0'),
        longitude: double.parse('0'),
        timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
      );
    }
    if(fromAddress) {
      _position = myPosition;
    }else {
      _pickPosition = myPosition;
    }
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(myPosition.latitude, myPosition.longitude), zoom: 17),
      ));
    }
    Placemark myPlaceMark;
    try {
      if(context.mounted){

      }
        // String address = await getAddressFromGeocode(LatLng(myPosition.latitude, myPosition.longitude), context);
        // myPlaceMark = Placemark(name: address, locality: '', postalCode: '', country: '');

      List<Placemark> placemarks = await placemarkFromCoordinates(
          myPosition.latitude, myPosition.longitude);
      Placemark place = placemarks[0];


      print('current location1');
      print(place.toString());
      String address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} - ${place.postalCode}';
      myPlaceMark = Placemark(name: address, locality: '', postalCode: '', country: '');



    }catch (e) {
      if(context.mounted){

      }
      // String address = await getAddressFromGeocode(LatLng(myPosition.latitude, myPosition.longitude), context);
      // myPlaceMark = Placemark(name: address, locality: '', postalCode: '', country: '');

      List<Placemark> placemarks = await placemarkFromCoordinates(
          myPosition.latitude, myPosition.longitude);
      Placemark place = placemarks[0];


      print('current location2');
      print(place.toString());
      String address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} - ${place.postalCode}';
      myPlaceMark = Placemark(name: address, locality: '', postalCode: '', country: '');

    }
    print('current location3');
    fromAddress ? _address = myPlaceMark : _pickAddress = myPlaceMark;
    if(fromAddress) {
      _locationController.text = placeMarkToAddress(_address);
    }
    _loading = false;
    notifyListeners();
  }

  void updatePosition(CameraPosition? position, bool fromAddress, String? address, BuildContext context) async {
    if(_updateAddAddressData) {
      _loading = true;
      notifyListeners();
      try {
        if (fromAddress) {
          _position = Position(  altitudeAccuracy:1, headingAccuracy:1,
            latitude: position!.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
          );
        } else {
          _pickPosition = Position( altitudeAccuracy:1, headingAccuracy:1,
            latitude: position!.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
          );
        }
        if (_changeAddress) {

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.target.latitude, position.target.longitude);
          Placemark place = placemarks[0];


          print(place.toString());
          String? addresss = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} - ${place.postalCode}';
          fromAddress ? _address = Placemark(name: addresss) : _pickAddress = Placemark(name: addresss);

          if(address != null) {
            _locationController.text = address;
          }else if(fromAddress) {
            _locationController.text = placeMarkToAddress(_address);
          }
        } else {
          _changeAddress = true;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      _loading = false;
      notifyListeners();
    }else {
      _updateAddAddressData = true;
    }
  }


  void dragableAddress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(_position.latitude, _position.longitude);
    _address = placemarks.first;
    _locationController.text = placeMarkToAddress(_address);
    //saveUserAddress(address: currentAddresses.first);
    notifyListeners();
  }







  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage = '';
  String? get errorMessage => _errorMessage;
  String? _addressStatusMessage = '';
  String? get addressStatusMessage => _addressStatusMessage;
  updateAddressStatusMessae({String? message}){
    _addressStatusMessage = message;
  }
  updateErrorMessage({String? message}){
    _errorMessage = message;
  }

  void setZip(String zip){
    _searchZipController.text = zip;
    notifyListeners();
  }
  void setCountry(String country){
    _searchCountryController.text = country;
    notifyListeners();
  }




  List<String> _getAllAddressType = [];

  List<String> get getAllAddressType => _getAllAddressType;
  int _selectAddressIndex = 0;

  int get selectAddressIndex => _selectAddressIndex;

  updateAddressIndex(int index, bool notify) {
    _selectAddressIndex = index;
    if(notify) {
      notifyListeners();
    }
  }


  // void setLocation(String? placeID, String? address, GoogleMapController? mapController) async {
  //   _loading = true;
  //   notifyListeners();
  //   PlacesDetailsResponse detail;
  //   ApiResponse response = await locationRepo!.getPlaceDetails(placeID);
  //   detail = PlacesDetailsResponse.fromJson(response.response!.data);
  //
  //   _pickPosition = Position(  altitudeAccuracy:1, headingAccuracy:1,
  //     longitude: detail.result.geometry!.location.lat, latitude: detail.result.geometry!.location.lng,
  //     timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
  //   );
  //
  //   _pickAddress = Placemark(name: address);
  //   _changeAddress = false;
  //
  //   if(mapController != null) {
  //     mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
  //       detail.result.geometry!.location.lat, detail.result.geometry!.location.lng,
  //     ), zoom: 17)));
  //   }
  //   _loading = false;
  //   notifyListeners();
  // }

  void disableButton() {
    _buttonDisabled = true;
    notifyListeners();
  }

  void setAddAddressData() {
    _position = _pickPosition;
    _address = _pickAddress!;
    _locationController.text = placeMarkToAddress(_address);
    _updateAddAddressData = false;
    notifyListeners();
  }

  void setPickData() {
    _pickPosition = _position;
    _pickAddress = _address;
    _locationController.text = placeMarkToAddress(_address);
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }



  String placeMarkToAddress(Placemark placeMark) {
    return '${placeMark.name ?? ''}'
        ' ${placeMark.subAdministrativeArea ?? ''}'
        ' ${placeMark.isoCountryCode ?? ''}';
  }

  void isBillingChanged(bool change) {
    _isBilling = change;
    if (change) {
      change = !_isBilling;
    }
    notifyListeners();
  }


}
