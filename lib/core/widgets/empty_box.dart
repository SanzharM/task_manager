import 'package:flutter/material.dart';

class EmptyBox extends StatelessWidget {
  final double height;
  final double width;
  const EmptyBox({this.height = 0, this.width = 0});
  @override
  Widget build(BuildContext context) {
    if (height <= 0 && width <= 0) return Padding(padding: EdgeInsets.zero);
    return Padding(padding: EdgeInsets.only(right: width, top: height));
  }
}
