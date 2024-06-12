import 'package:flutter/material.dart';

class ColorConstants {
  static const Color cBlack = Colors.black;
  static const Color cWhite = Colors.white;
  static const Color primaryColor = cBlack;
  static const Color primaryColorDark = cBlack;
  static const Color accentColor = Colors.blue;
  static const Color cOrangeButton =Colors.red;
  static const Color cError =Color(0xffEF3F3F);
  static const Color cSuccess =Color(0xff3AB549);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color scaffoldBackgroundColor = Colors.white;
  static const Color cDividerColor = Colors.black12;
  static const Color cDividerMoreLightColor = Color(0xffF1F1F1);
  static const Color cDividerLightColor = Color(0xffBBBBBB);
  static const Color cEditTextBorderLightColor = Color(0xffDDDDDD);
  static const Color cHintText = Color(0xFF78909C);
  static const Color cScaffoldBackgroundColor = Color(0xffF1F1FA);
  static const Color cBottomNavigationBarColor = Color(0xffe5e5e5);
  static const Color cRedColor = Color(0xffFF0E0E);
  static const Color cLightRedColor = Color(0xffFFECEC);
  static const Color cGreenColor = Color(0xff23D760);
  static const Color cLightGreenColor = Color(0xffE7FFEE);

  /// app Theme Color
  static const MaterialColor kPrimaryColor = MaterialColor(
    _cActionBar,
    <int, Color>{
      50: Color(0xFFFFE8F3),
      100: Color(0xFFF3B3CC),
      200: Color(0xFFE393B6),
      300: Color(0xFFC97299),
      400: Color(0xFFD9558F),
      500: Color(_cActionBar),
      600: Color(0xFFA93367),
      700: Color(0xFFA62560),
      800: Color(0xFFA21A5A),
      900: Color(0xFF690E36),
    },
  );
  static const int _cActionBar = 0xFFAA336A;

}
