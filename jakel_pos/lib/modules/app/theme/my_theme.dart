import 'package:flutter/material.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';

ThemeData myLightTheme(BuildContext context){
  return ThemeData(
      brightness: Brightness.light,
      indicatorColor: Colors.black45,
      primarySwatch: kPrimaryColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Colors.redAccent.withOpacity(0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            primary: Colors.white,
            elevation: 2.0,
            backgroundColor: Colors.orangeAccent.withOpacity(0.5),
            shadowColor: getPrimaryColor(context)),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.deepOrangeAccent,
          primary: kPrimaryColor,
          onPrimaryContainer: Colors.grey.shade100,
          tertiaryContainer: getTertiaryColor(context).withOpacity(0.2),
          tertiary: getTertiaryColor(context).withOpacity(0.6)));
}

ThemeData myDarkTheme(BuildContext context){
  return ThemeData(
      brightness: Brightness.light,
      indicatorColor: Colors.black45,
      primarySwatch: kPrimaryColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Colors.redAccent.withOpacity(0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            primary: Colors.white,
            elevation: 2.0,
            backgroundColor: Colors.orangeAccent.withOpacity(0.5),
            shadowColor: getPrimaryColor(context)),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.deepOrangeAccent,
          primary: kPrimaryColor,
          onPrimaryContainer: Colors.grey.shade100,
          tertiaryContainer: getTertiaryColor(context).withOpacity(0.2),
          tertiary: getTertiaryColor(context).withOpacity(0.6)));
}