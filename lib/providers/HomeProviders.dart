
import 'package:flutter/cupertino.dart';

class HomeProviders extends ChangeNotifier {

  bool _notProvidingService = true;

  bool get notProvidingService => _notProvidingService;

  void setNotProvidingService(bool notProvidingService) {
    _notProvidingService = notProvidingService;
    notifyListeners();
  }
}
