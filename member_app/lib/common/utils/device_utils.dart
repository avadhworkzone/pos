import 'dart:io';

import 'package:flutter/services.dart';
import 'package:member_app/common/app_constants.dart';

class DeviceUtils {
  // Singleton approach
  static final DeviceUtils _instance = DeviceUtils._internal();

  factory DeviceUtils() => _instance;

  DeviceUtils._internal();

  // static Future<String> getDeviceID() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     // import 'dart:io'
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   } else {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     return androidDeviceInfo.androidId; // unique ID on Android
  //   }
  // }

  static String getPlatform() {
    try {
      if (Platform.isAndroid) {
        return AppConstants.platformAndroid;
      } else if (Platform.isIOS) {
        return AppConstants.platformIOS;
      }
    } on PlatformException {
    }
    return "";
  }
}
