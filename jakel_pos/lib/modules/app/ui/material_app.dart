import 'package:flutter/material.dart';
import 'package:jakel_base/NavigationService.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_pos/modules/app/theme/my_theme.dart';

import '../../../LayoutTemplate.dart';
import '../../../main.dart';
import '../../../routing/route_names.dart';
import '../../../routing/router.dart';

import 'package:easy_localization/easy_localization.dart';

Widget getMaterialApp(BuildContext context, TransitionBuilder botToastBuilder) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: context.localizationDelegates,
    supportedLocales: context.supportedLocales,
    locale: context.locale,
    title: tr('title'),
    theme: myLightTheme(context),
    darkTheme: myDarkTheme(context),
    navigatorKey: locator<NavigationService>().navigatorKey,
    initialRoute: SplashRoute,
    onGenerateRoute: generateRoute,
    builder: (context, child) {
      child = LayoutTemplate(
        child: child!,
      );
      child = botToastBuilder(context, child);
      return child;
    },
  );
}
