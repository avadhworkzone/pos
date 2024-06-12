import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_pos/modules/app/ui/material_app.dart';
import 'package:jakel_pos/modules/app_locator.dart';
import 'package:window_manager/window_manager.dart';

import 'modules/extendedcustomerdisplay/ui/extended_customer_display_screen.dart';

const hiveDbPath = 'pos-data';

Future<void> main(List<String> args) async {
  MyLogUtils.logDebug("main app Started");
  WidgetsFlutterBinding.ensureInitialized();

  if (args.firstOrNull == 'multi_window') {
    //Extended display
    setupLocator(); // GET IT
    setUpAppLocator();

    final windowId = int.parse(args[1]);
    final argument = args[2].isEmpty
        ? const {}
        : jsonDecode(args[2]) as Map<String, dynamic>;

    MyLogUtils.logDebug(
        "args for multi window $windowId && media_files : ${argument['media_files']}");

    // if (Platform.isWindows) {
    //   initMeeduPlayer();
    // }
    runApp(ExtendedCustomerDisplayScreen(
      mediaFiles: argument['media_files'] != null
          ? argument['media_files'].cast<String>()
          : [],
      windowController: WindowController.fromWindowId(windowId),
      args: argument,
    ));
  } else {
    await EasyLocalization.ensureInitialized();
    await Hive.initFlutter(hiveDbPath);
    await windowManager.ensureInitialized();

    // Use it only after calling `hiddenWindowAtLaunch`
    windowManager.waitUntilReadyToShow().then((_) async {
      // Hide window title bar
      await windowManager.setTitleBarStyle(TitleBarStyle.normal);
      await windowManager.setFullScreen(true);
      await windowManager.center();
      await windowManager.show();
      await windowManager.setSkipTaskbar(false);
      await windowManager.setClosable(true);
    });
    setupLocator(); // GET IT
    setUpAppLocator();
    //Main Display
    runApp(
      EasyLocalization(
          supportedLocales: const [
            Locale('en'),
          ],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: const MyApp()),
    );

    MyLogUtils.logDebug("main app ended.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This ui is the root of your application.
  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return getMaterialApp(context, botToastBuilder);
  }
}

// class CustomerDisplayApp extends StatelessWidget {
//   final int windowId;
//   final Map<dynamic, dynamic> argument;
//
//   const CustomerDisplayApp(
//       {Key? key, required this.windowId, required this.argument})
//       : super(key: key);
//
//   // This ui is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         localizationsDelegates: context.localizationDelegates,
//         supportedLocales: context.supportedLocales,
//         locale: context.locale,
//         title: tr('title'),
//         theme: myLightTheme(context),
//         darkTheme: myDarkTheme(context),
//         navigatorKey: locator<NavigationService>().navigatorKey,
//         home: ExtendedCustomerDisplayScreen(
//           windowController: WindowController.fromWindowId(windowId),
//           args: argument,
//         ));
//   }
// }
