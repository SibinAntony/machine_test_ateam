import 'package:hive_flutter/adapters.dart';

import '../utils/constant.dart';

class TripDB {
  static final tripBox = Hive.box(tripHiveBox);

  static createUser(Map data) {
    tripBox.add(data);
  }

  static List getAllUsers() {
    final data = tripBox.keys.map((key) {
      final value = tripBox.get(key);
      return {
        "key": key,
        "startLocation": value["startLocation"],
        "startPlace": value['startPlace'],
        "endPlace": value['endPlace'],
        "startLatitude": value['startLatitude'],
        "startLongitude": value['startLongitude'],
        "endLatitude": value['endLatitude'],
        "endLongitude": value['endLongitude'],
      };
    }).toList();

    return data.reversed.toList();
  }

  static Map getUser(int key) {
    return tripBox.get(key);
  }
}
