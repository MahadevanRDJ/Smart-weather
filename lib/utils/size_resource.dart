import 'package:flutter/cupertino.dart';

class SizeResource {
  static double _headlinesHeight = 0.0;
  static double _headlinesWidth = 0.0;
  static double get headlineHeight => _headlinesHeight;
  static double get headlineWidth => _headlinesWidth;
  static Size getSize(context) => _getSize(context);

  static void setResponsive(context) {
    Size size = getSize(context);
    double screenWidth = size.width;

    if (screenWidth >= 1400) {
      _headlinesHeight = size.height * 0.45;
      _headlinesWidth = size.width * 0.5;
    } else if (screenWidth >= 1200) {
      _headlinesHeight = size.height * 0.45;
      _headlinesWidth = size.width * 0.55;
    } else if (screenWidth >= 992) {
      _headlinesHeight = size.height * 0.45;
      _headlinesWidth = size.width * 0.65;
    } else if (screenWidth > 480) {
      _headlinesHeight = size.height * 0.45;
      _headlinesWidth = size.width * 0.70;
    } else {
      _headlinesHeight = size.height * 0.30;
      _headlinesWidth = size.width * 0.80;
    }
  }
}

Size _getSize(context) {
  return MediaQuery.of(context).size;
}
