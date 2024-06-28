import 'package:flutter/material.dart';

class MenuControllers extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldfKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldfKey;

  void controlMenu() {
    if (!_scaffoldfKey.currentState!.isDrawerOpen) {
      _scaffoldfKey.currentState!.openDrawer();
    }
  }

  void closeMenu() {
    if (!_scaffoldfKey.currentState!.isDrawerOpen) {
      _scaffoldfKey.currentState!.closeDrawer();
    }
  }
}
