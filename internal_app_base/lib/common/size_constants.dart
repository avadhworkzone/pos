import 'package:flutter/material.dart';

class SizeConstants {
  static double width = 0.0;
  static double height = 0.0;
  static double s_05 = 0.0;
  static double s1 = 0.0;

  SizeConstants(BuildContext mBuildContext) {
    width = MediaQuery.of(mBuildContext).size.width;
    height = MediaQuery.of(mBuildContext).size.height;

    s_05 = width * 0.0013;
    s1 = s_05 * 2;
  }
}
