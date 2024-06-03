import 'package:flutter/material.dart';

class GlobalWidthValues {
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.9;
  }

  static double multiplyWidth(double factor, BuildContext context) {
    return getWidth(context) * factor;
  }
}
