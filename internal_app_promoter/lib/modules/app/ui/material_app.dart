import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_app_promoter/modules/splash/view/splash_screen.dart';
import 'package:internal_app_promoter/routes/generated_routes.dart';
import 'package:internal_app_promoter/routes/route_constants.dart';
import '../theme/app_theme.dart';


Widget getMaterialApp(BuildContext context) {
  return
  //   Platform.isIOS?
  //   CupertinoApp(
  //     theme:MaterialBasedCupertinoThemeData(materialTheme: appLightTheme(context) ),
  //     // darkTheme: appDarkTheme(context),
  //   debugShowCheckedModeBanner: false,
  //   initialRoute: RouteConstants.rSplashScreenWidget,
  //   onGenerateRoute: GeneratedRoutes.generateRoute,
  //   builder: (context, child) {
  //     return protectFromSettingsFontSize(context, child!);
  //   },
  //   home: const SplashScreenWidget(),
  // ):
    MaterialApp(
      theme: appLightTheme(context),
      darkTheme: appDarkTheme(context),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteConstants.rSplashScreenWidget,
      onGenerateRoute: GeneratedRoutes.generateRoute,
      builder: (context, child) {
        return protectFromSettingsFontSize(context, child!);
      },
      home: const SplashScreenWidget(),
    );
}

MediaQuery protectFromSettingsFontSize(BuildContext context, Widget child) {
  final mediaQueryData = MediaQuery.of(context);
  // Font size change(either reduce or increase) from phone setting should not impact app font size
  final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.0);
  return MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
    child: child,
  );
}
