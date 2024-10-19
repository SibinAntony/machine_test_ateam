import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constant.dart';

class TripRepo {
  TripRepo();

  Future<List<Map<String, dynamic>>> searchPlace(String query) async {
    List<Map<String, dynamic>> searchResultsStart = [];
    try {
      final url = Uri.parse(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$ACCESS_TOKEN',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return searchResultsStart = (data['features'] as List)
            .map((feature) => feature as Map<String, dynamic>)
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
