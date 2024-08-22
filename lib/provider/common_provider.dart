import 'package:flutter/material.dart';

class CommonProvider with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  String _headlineCategory = '';

  String get headlineCategory => (_headlineCategory == '' || _headlineCategory == 'All') ? 'All' : _headlineCategory;
  String get headLineCategoryParam => (_headlineCategory == '' || _headlineCategory == 'All') ? '' : '&category=$_headlineCategory';

  void updateHeadlineCategory(String category) {
    _headlineCategory = category;
    notifyListeners();
  }

  String _unit = 'ºC';

  String get unitSymbol => _unit;
  String get units => _unit.contains('C') ? 'metric' : 'imperial';

  void updateUnits(String units) {
    _unit = units;
    notifyListeners();
  }
}
