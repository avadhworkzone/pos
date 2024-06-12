import 'package:flutter/material.dart';

class SizeConstants {
  static double width = 0.0;
  static double height = 0.0;
  static double s_05 = 0.0;
  static double s1 = 0.0;
  static double s2 = 0.0;
  static double s3 = 0.0;
  static double s4 = 0.0;
  static double s5 = 0.0;
  static double s_6 = 0.0;
  static double s_8 = 0.0;
  static double s_10 = 0.0;
  static double s_11 = 0.0;
  static double s_12 = 0.0;
  static double s_14 = 0.0;
  static double s_15 = 0.0;
  static double s_16 = 0.0;
  static double s_18 = 0.0;
  static double s_20 = 0.0;
  static double s_22 = 0.0;
  static double s_26 = 0.0;
  static double s_27 = 0.0;
  static double s_30 = 0.0;
  static double s_32 = 0.0;
  static double s_46 = 0.0;
  static double s_50 = 0.0;
  static double s_64 = 0.0;
  static double s_72 = 0.0;
  static double s_86 = 0.0;
  static double s_100 = 0.0;

  SizeConstants(BuildContext mBuildContext) {
    width = MediaQuery.of(mBuildContext).size.width;
    height = MediaQuery.of(mBuildContext).size.height;

    s_05 = width * 0.0013;
    s1 = s_05 * 2;
    s2 = s1 * 2;
    s3 = s1 * 3;
    s4 = s1 * 4;
    s5 = s1 * 5;
    s_6 = s1 * 6;
    s_8 = s1 * 8;
    s_10 = s1 * 10;
    s_11 = s1 * 11;
    s_12 = s1 * 12;
    s_14 = s1 * 14;
    s_15 = s1 * 15;
    s_16 = s1 * 16;
    s_18 = s1 * 18;
    s_20 = s1 * 20;
    s_22 = s1 * 22;
    s_26 = s1 * 26;
    s_27 = s1 * 27;
    s_30 = s1 * 30;
    s_32 = s1 * 32;
    s_46 = s1 * 46;
    s_50 = s1 * 50;
    s_64 = s1 * 64;
    s_72 = s1 * 72;
    s_86 = s1 * 86;
    s_100 = s1 * 100;
  }
}
