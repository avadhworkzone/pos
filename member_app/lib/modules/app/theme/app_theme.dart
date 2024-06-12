import 'package:flutter/material.dart';
import 'package:member_app/common/color_constants.dart';

ThemeData appLightTheme(BuildContext context){
  return ThemeData(
    scrollbarTheme: ScrollbarThemeData().copyWith(
      thumbColor: MaterialStateProperty.all(ColorConstants.kPrimaryColor.shade600),
    ),
    fontFamily: 'WorkSans',
    scaffoldBackgroundColor: ColorConstants.cScaffoldBackgroundColor,
    primarySwatch: ColorConstants.kPrimaryColor,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      color: ColorConstants.kPrimaryColor, //<-- SEE HERE
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade200,
      isDense: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade300), //<-- SEE HERE
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade300), //<-- SEE HERE
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade300), //<-- SEE HERE
      ),
    ),
  );
}

ThemeData appDarkTheme(BuildContext context){
  return ThemeData(
    fontFamily: 'WorkSans',
    scrollbarTheme: ScrollbarThemeData().copyWith(
      thumbColor: MaterialStateProperty.all(ColorConstants.kPrimaryColor.shade600),
    ),
    scaffoldBackgroundColor: ColorConstants.cScaffoldBackgroundColor,
    primarySwatch: ColorConstants.kPrimaryColor,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      color: ColorConstants.kPrimaryColor, //<-- SEE HERE
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade200,
      isDense: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade300), //<-- SEE HERE
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade300), //<-- SEE HERE
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade300), //<-- SEE HERE
      ),
    ),
  );
}