import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapElementWidget extends StatefulWidget {
  const MapElementWidget({super.key});

  @override
  State<MapElementWidget> createState() => _MapElementWidgetState();
}

class _MapElementWidgetState extends State<MapElementWidget> {
  MapboxMap? _startMapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  PointAnnotation? pointAnnotation;
  @override
  Widget build(BuildContext context) {
    return  Container();
  }
}
