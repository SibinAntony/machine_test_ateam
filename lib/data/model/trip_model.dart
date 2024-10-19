import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class TripModel {
  @HiveField(0)
  String startLocation;
  @HiveField(1)
  String startPlace;
  @HiveField(2)
  double startLatitude;
  @HiveField(3)
  double startLongitude;
  @HiveField(4)
  String endPlace;
  @HiveField(5)
  double endLatitude;
  @HiveField(6)
  double endLongitude;

  TripModel(
      {required this.startLocation,
      required this.startPlace,
      required this.startLatitude,
      required this.startLongitude,
      required this.endPlace,
      required this.endLatitude,
      required this.endLongitude});
}
