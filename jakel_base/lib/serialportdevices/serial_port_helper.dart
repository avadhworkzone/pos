import 'dart:convert';
import 'dart:typed_data';

import '../utils/MyLogUtils.dart';

//ASCII Decimal Values
const startOfText = 2;
const endOfText = 3;

//https://www.eso.org/~ndelmott/ascii.html - ASCII Lists
String getLrc(String input) {
  final bytes = utf8.encode(input);
  final byte = bytes.reduce((o, i) => o ^= i);
  var asciiCharacterOfLrcValue = String.fromCharCode(byte);
  var hexValue = byte.toRadixString(16);

  MyLogUtils.logDebug(
      "getLrc of $input is : $byte  & asciiCharacterOfLrcValue: $asciiCharacterOfLrcValue"
      " & hex value: $hexValue");

  return asciiCharacterOfLrcValue;
}

String convertUInt8ListToString(Uint8List input) {
  String value = "";
  for (var element in input) {
    var charCode = String.fromCharCode(element);
    charCode = getCustomAsciiCharCode(element, charCode);
    value = "$value$charCode";
  }
  return value;
}

Uint8List convertStringToUInt8List(String input) {
  MyLogUtils.logDebug("convertStringToUInt8List of  input : $input");
  List<int> list = utf8.encode(input);
  var result = Uint8List.fromList(list);
  MyLogUtils.logDebug("convertStringToUInt8List of $input is : $result");
  return result;
}

//https://www.eso.org/~ndelmott/ascii.html - ASCII Lists
String getCustomAsciiCharCode(int code, String defaultValue) {
  if (code == 0) {
    return "NULL";
  }
  if (code == 1) {
    return "SOH";
  }
  if (code == 2) {
    return "<STX>";
  }
  if (code == 3) {
    return "<ETX>";
  }
  if (code == 4) {
    return "EOT";
  }
  if (code == 5) {
    return "ENQ";
  }
  if (code == 6) {
    return "ACK";
  }
  if (code == 21) {
    return "NAK";
  }
  return defaultValue;
}

bool isStatusCodeInResponseSuccess(String decimalValue) {
  return decimalValue == "00";
}
