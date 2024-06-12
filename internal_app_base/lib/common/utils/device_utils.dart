import 'dart:io';

import 'package:flutter/services.dart';
import 'package:internal_base/common/app_constants.dart';

class DeviceUtils {
  // Singleton approach
  static final DeviceUtils _instance = DeviceUtils._internal();

  factory DeviceUtils() => _instance;

  DeviceUtils._internal();

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
