import 'package:flutter/material.dart';
import 'package:member_app/modules/splash/view/splash_screen.dart';
import 'package:member_app/routes/generated_routes.dart';
import 'package:member_app/routes/route_constants.dart';
import '../theme/app_theme.dart';


Widget getMaterialApp(BuildContext context) {
  return MaterialApp(
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

  //   MaterialApp(
  //   debugShowCheckedModeBanner: false,
  //   localizationsDelegates: context.localizationDelegates,
  //   supportedLocales: context.supportedLocales,
  //   locale: context.locale,
  //   title: tr('title'),
  //   theme: myLightTheme(context),
  //   darkTheme: myDarkTheme(context),
  //   navigatorKey: locator<NavigationService>().navigatorKey,
  //   initialRoute: SplashRoute,
  //   onGenerateRoute: generateRoute,
  //   builder: (context, child) {
  //     child = LayoutTemplate(
  //       child: child!,
  //     );
  //     child = botToastBuilder(context, child);
  //     return child;
  //   },
  // );
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
