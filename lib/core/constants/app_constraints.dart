import 'package:flutter/cupertino.dart';

class AppConstraints {
  static const double radius = 10.0;
  static const borderRadius = BorderRadius.all(Radius.circular(radius));
  static const borderRadiusTLR = BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius));
}
