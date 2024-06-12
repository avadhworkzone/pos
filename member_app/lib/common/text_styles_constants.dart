import 'package:flutter/material.dart';
import 'package:member_app/common/size_constants.dart';

/////////////////////////////////
///   TEXT STYLES
////////////////////////////////
TextStyle getTextVeryLight({Color colors = Colors.white, size = 14.0}) {
  return TextStyle(
      color: colors,
      fontFamily: 'WorkSans',
      fontSize: size,
      fontWeight: FontWeight.w200,
      letterSpacing: -0.2);
}

TextStyle getTextLight({Color colors = Colors.white, size = 14.0,letterSpacing = -0.2}) {
  return TextStyle(
      color: colors,
      fontFamily: 'WorkSans',
      fontSize: size,
      fontWeight: FontWeight.w300,
      letterSpacing: letterSpacing);
}

TextStyle getTextRegular(
    {Color colors = Colors.white,
    size = 14.0,
    heights = 1.2,
    letterSpacing = -0.2,
      mTextDecoration = TextDecoration.none}) {
  return TextStyle(
    color: colors,
    fontFamily: 'WorkSans',
    fontSize: size,
    fontWeight: FontWeight.normal,
    letterSpacing: letterSpacing,
    height: heights,
    decoration: mTextDecoration,
  );
}

TextStyle getTextMedium(
    {Color colors = Colors.white, size = 14.0, heights = 1.2,letterSpacing=-0.2}) {
  return TextStyle(
      color: colors,
      fontFamily: 'WorkSans',
      fontSize: size,
      fontWeight: FontWeight.w500,
      letterSpacing: letterSpacing,
      height: heights);
}

TextStyle getTextSemiBold(
    {Color colors = Colors.white, size = 14.0, heights = 1.2,letterSpacing=-0.2}) {
  return TextStyle(
      color: colors,
      fontFamily: 'WorkSans',
      fontSize: size,
      fontWeight: FontWeight.w600,
      wordSpacing: -0.5,
      height: heights,
      letterSpacing: letterSpacing);
}

// Events
TextStyle getTextBold({Color colors = Colors.white, size = 14.0}) {
  return TextStyle(
      color: colors,
      fontFamily: 'WorkSans',
      fontSize: size,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.2);
}
TextStyle getTextBigBold({Color colors = Colors.white, size = 14.0}) {
  return TextStyle(
      color: colors,
      fontFamily: 'WorkSans',
      fontSize: size,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.2);
}

TextStyle getTextVeryBigBold({Color colors = Colors.white, size = 14.0}) {
  return TextStyle(
      color: colors,
      fontFamily: 'WorkSans',
      fontSize: size,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.2);
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

getGreenTag(String sTitle) {
  return Container(
    margin:
        EdgeInsets.only(left: SizeConstants.s_10),
    alignment: Alignment.center,
    padding: EdgeInsets.only(
        top: SizeConstants.width * 0.02, bottom: SizeConstants.width * 0.02),
    width: SizeConstants.width * 0.23,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ],
      color: Colors.green.shade300,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
    child: Text(
      sTitle,
      style: getTextRegular(colors: Colors.white, size: SizeConstants.s_12),
    ),
  );
}

getBlueTag(String sTitle) {
  return Container(
    margin:
        EdgeInsets.only(left: SizeConstants.s_10),
    alignment: Alignment.center,
    padding: EdgeInsets.only(
        top: SizeConstants.width * 0.02, bottom: SizeConstants.width * 0.02),
    width: SizeConstants.width * 0.23,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 1), // changes position of shadow
        ),
      ],
      color: Colors.blue.shade300,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
    child: Text(
      sTitle,
      style: getTextRegular(colors: Colors.white, size: SizeConstants.s_12),
    ),
  );
}
