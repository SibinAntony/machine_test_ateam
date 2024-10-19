import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constant.dart';

class HomeProvider with ChangeNotifier {
  HomeProvider();

  List<Map<String, dynamic>> _searchResultsStart = [];

  bool _onStartLocationShow = false;

  bool _onEndLocationShow = false;

  bool get onStartLocationShow => _onStartLocationShow;

  bool get onEndLocationShow => _onEndLocationShow;

  List<Map<String, dynamic>> get searchResultsStart => _searchResultsStart;

  double _startLatitude = 0.0;
  double _startLongitude =0.0;

  double get startLatitude => _startLatitude;

  double get startLongitude => _startLongitude;

  double _endLatitude = 0.0;
  double _endLongitude = 0.0;

  double get endLatitude => _endLatitude;

  double get endLongitude => _endLongitude;

  void setStartlatlng(double lng, double lat) {
    _startLatitude = lat;
    _startLongitude = lng;
    notifyListeners();
  }

  void setEndlatlng(double lat, double lng) {
    _endLatitude = lat;
    _endLongitude = lng;
    notifyListeners();
  }

  void setOnStartLocationShow(bool value) {
    _onStartLocationShow = value;
    notifyListeners();
  }

  void setOnEndLocationShow(bool value) {
    _onEndLocationShow = value;
    notifyListeners();
  }

  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();

  TextEditingController get startLocationController => _startLocationController;

  TextEditingController get endLocationController => _endLocationController;

  void setStartLocationController(String text) {
    _startLocationController.text = text;
  }

  void setEndLocationController(String text) {
    _endLocationController.text = text;
  }

  Future<List<Map<String, dynamic>>> getStartSearch(
      String searchPlace, bool isStart, bool isEnd) async {
    _searchResultsStart = [];

    try {
      final url = Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$searchPlace.json?access_token=$ACCESS_TOKEN',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setOnStartLocationShow(isStart);
        setOnEndLocationShow(isEnd);

        _searchResultsStart = (data['features'] as List)
            .map((feature) => feature as Map<String, dynamic>)
            .toList();
        print('result');
        print(searchResultsStart.toString());

        notifyListeners();
        return searchResultsStart;
      } else {
        notifyListeners();
        return [];
      }
    } catch (e) {
      notifyListeners();
      return [];
    }
  }
}
