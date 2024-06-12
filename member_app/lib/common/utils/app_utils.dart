import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:member_app/common/utils/app_util_constants.dart';
// import 'package:package_info_plus/package_info_plus.dart';

class AppUtils {
  // Singleton approach
  static final AppUtils _instance = AppUtils._internal();

  factory AppUtils() => _instance;

  AppUtils._internal();

  static bool isValidUrl(String value) {
    RegExp regex = RegExp(AppUtilConstants.patternWebUrl);
    return (!regex.hasMatch(value)) ? false : true;
  }

  static bool isValidString(String value) {
    RegExp regex = RegExp(AppUtilConstants.patternOnlyString);
    return (!regex.hasMatch(value)) ? false : true;
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static bool isValidNumber(String value) {
    RegExp regex = RegExp(AppUtilConstants.patternOnlyNumber);
    return (!regex.hasMatch(value)) ? false : true;
  }

  static bool isValidEmail(String value) {
    RegExp regex = RegExp(AppUtilConstants.patternEmail);
    return (!regex.hasMatch(value)) ? false : true;
  }

  static bool isValidPhone(String value) {
    return (value.length == 10 || value.length == 11) ? true : false;
  }

  static bool isValidPassword(String value) {
    RegExp regex = RegExp(AppUtilConstants.patternPassword);
    return (!regex.hasMatch(value)) ? false : true;
  }

  static bool isValidICNumber(String value) {
    return (value.length == 12) ? true : false;
  }

  static showKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String fileSizeText(int fileSize) {
    // byteSize = 1024;
    // kbSize = byteSize * 1024;
    // mbSize = kbSize * 1024;
    // gbSize = mbSize * 1024;

    const suffixes = ["B", "KB", "MB", "GB"];
    // if (fileSize > 0 && fileSize <= byteSize) {
    //   return "${fileSize / byteSize} ${suffixes[0]}";
    // } else if (fileSize > byteSize && fileSize <= kbSize) {
    //   return "${fileSize / kbSize} ${suffixes[1]}";
    // } else if (fileSize > kbSize && fileSize <= mbSize) {
    //   return "${fileSize / mbSize} ${suffixes[2]}";
    // } else if (fileSize > mbSize && fileSize <= gbSize) {
    //   return "${fileSize / gbSize} ${suffixes[3]}";
    // }
    // return "Invalid file size";

    var i = (log(fileSize) / log(1024)).floor();
    return ((fileSize / pow(1024, i)).toStringAsFixed(2)) + ' ' + suffixes[i];
  }

  hideKeyboard(BuildContext context) {
    var currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }
}
