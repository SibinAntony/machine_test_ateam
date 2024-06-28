
import 'package:flutter/cupertino.dart';

class VendorProviders extends ChangeNotifier {

  int? _categorySelectedIndex = 0;

  int? get categorySelectedIndex => _categorySelectedIndex;

  void changeCategorySelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }
}
