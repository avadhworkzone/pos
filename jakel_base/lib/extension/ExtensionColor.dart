import 'package:flutter/material.dart';

extension ExtensionColor on MaterialColor {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();

    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Color appBg() {
    return fromHex("#031E37");
  }


}
