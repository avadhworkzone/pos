import 'dart:convert';
import 'dart:ui';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:internal_base/common/alert/filter_custom_dialog.dart';
import 'package:internal_base/common/alert/filter_value.dart';
import 'package:internal_base/common/app_constants.dart';
import 'package:internal_base/common/color_constants.dart';
import 'package:internal_base/common/image_assets.dart';
import 'package:internal_base/common/size_constants.dart';
import 'package:internal_base/common/text_styles_constants.dart';
import 'package:internal_base/common/utils/app_calendar_utils.dart';
import 'package:internal_base/data/local/shared_prefs/shared_prefs.dart';

enum AlertAction { yes, no, ok, cancel }

class AppAlert {
  AppAlert._();

  static bool showProgress = false;

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    ));
  }

  ///all Dialog close
  static closeDialog(BuildContext context, {String sText = ""}) {
    if (sText.isEmpty) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop(sText);
    }
  }

  /// show Progress Dialog loading
  static showProgressDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.all(SizeConstants.s1 * 16),
                    height: 80,
                    width: 80,
                    child: const CircularProgressIndicator(
                      strokeWidth: 6.0,
                      color: ColorConstants.kPrimaryColor,
                    ),
                  ),
                ),
              ));
        });
  }

  /// show FilterDialog for product
  static Future<String> showFilterDialog(
      BuildContext context, String sTitle, String message) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: const Color(0xbb000000),
        builder: (BuildContext context) {
          return FilterCustomDialog(
            message: message,
          );
        });
    return action;
  }

  /// show filterDialog for promoter
  // static Future<String> showFilterDialogPromoter(
  //     BuildContext context, String sTitle, String message) async {
  //   final action = await showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       barrierColor: const Color(0xbb000000),
  //       builder: (BuildContext context) {
  //         return FilterCustomDialog(
  //           message: message,
  //         );
  //       });
  //   return action;
  // }

  /// show NoYes
  static Future<AlertAction> showCustomDialogYesNo(
    BuildContext context,
    String sTitle,
    String message, {
    String buttonOneText = "No",
    String buttonTwoText = "Yes",
  }) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: const Color(0xbb000000),
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(SizeConstants.s1 * 30),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          closeDialog(context);
                        },
                        child: Container(
                          // padding: EdgeInsets.all(SizeConstants.s1 * 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          height: SizeConstants.s1 * 41,
                          width: SizeConstants.s1 * 41,
                          child: Icon(Icons.clear_outlined),
                        ),
                      ),
                      SizedBox(
                        width: SizeConstants.s1 * 15,
                      ),
                      Text(sTitle,
                          style: getTextSemiBold(
                              colors: ColorConstants.cWhite,
                              size: SizeConstants.s1 * 20,
                              letterSpacing: 0.1)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConstants.s1 * 26,
                      right: SizeConstants.s1 * 26),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizeConstants.s1 * 8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConstants.s1 * 26,
                            bottom: SizeConstants.s1 * 12),
                        child: Text(message,
                            style: getTextSemiBold(
                              colors: Colors.black87,
                              size: SizeConstants.s1 * 18,
                            )),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(
                              SizeConstants.width * 0.08,
                              SizeConstants.width * 0.06,
                              SizeConstants.width * 0.08,
                              SizeConstants.width * 0.08),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                    height: SizeConstants.width * 0.12,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          closeDialog(context,
                                              sText: AlertAction.cancel
                                                  .toString());
                                        },
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        SizeConstants.s1 *
                                                            15))),
                                            backgroundColor: Colors.black,
                                            side: const BorderSide(
                                                width: 1.5,
                                                color: ColorConstants.cBlack)),
                                        child: Text(
                                          buttonOneText,
                                          style: getTextMedium(
                                            colors: ColorConstants.cWhite,
                                            size: SizeConstants.width * 0.04,
                                          ),
                                        ))),
                              ),
                              SizedBox(
                                width: SizeConstants.s1 * 14,
                              ),
                              Expanded(
                                child: SizedBox(
                                    height: SizeConstants.width * 0.12,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        SizeConstants.s1 *
                                                            15))),
                                            backgroundColor:
                                                ColorConstants.kPrimaryColor),
                                        onPressed: () {
                                          print("sTitle1 $sTitle");
                                          print(
                                              "sTitle2 ${AppConstants.cWordConstants.wLogoutText}");
                                          print(
                                              "sTitle3 ${sTitle == AppConstants.cWordConstants.wLogoutText}");
                                          if (sTitle ==
                                              AppConstants
                                                  .cWordConstants.wLogoutText) {
                                            SharedPrefs()
                                                .clearSharedPreferences();
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                          } else {
                                            closeDialog(context,
                                                sText:
                                                    AlertAction.yes.toString());
                                          }
                                        },
                                        child: Text(
                                          buttonTwoText,
                                          style: getTextMedium(
                                            colors: Colors.white,
                                            size: SizeConstants.width * 0.04,
                                          ),
                                        ))),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
    if (action.toString() != "null" ||
        action.toString() != "AlertAction.cancel") {
      if (action.toString() == "AlertAction.yes") {
        return AlertAction.yes;
      } else if (action.toString() == "AlertAction.no") {
        return AlertAction.no;
      } else if (action.toString() == "AlertAction.ok") {
        return AlertAction.ok;
      } else {
        return AlertAction.cancel;
      }
    } else {
      return AlertAction.cancel;
    }
  }

  /// show YesNo
  static Future<AlertAction> showCustomDialogNoYes(
    BuildContext context,
    String sTitle,
    String message, {
    String buttonOneText = "No",
    String buttonTwoText = "Yes",
  }) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: const Color(0xbb000000),
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: SizeConstants.s1 * 26,
                          right: SizeConstants.s1 * 26),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(SizeConstants.s1 * 8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConstants.s1 * 12,
                                right: SizeConstants.s1 * 12,
                                top: SizeConstants.s1 * 26,
                                bottom: SizeConstants.s1 * 12),
                            child: Text(message,
                                textAlign: TextAlign.center,
                                style: getTextSemiBold(
                                  colors: Colors.black87,
                                  size: SizeConstants.s1 * 18,
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(
                                  SizeConstants.width * 0.08,
                                  SizeConstants.width * 0.06,
                                  SizeConstants.width * 0.08,
                                  SizeConstants.width * 0.08),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                        height: SizeConstants.width * 0.12,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                SizeConstants
                                                                        .s1 *
                                                                    15))),
                                                backgroundColor: ColorConstants
                                                    .kPrimaryColor),
                                            onPressed: () {
                                              closeDialog(context,
                                                  sText: AlertAction.yes
                                                      .toString());
                                            },
                                            child: Text(
                                              buttonTwoText,
                                              style: getTextMedium(
                                                colors: Colors.white,
                                                size:
                                                    SizeConstants.width * 0.04,
                                              ),
                                            ))),
                                  ),
                                  SizedBox(
                                    width: SizeConstants.s1 * 14,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                        height: SizeConstants.width * 0.12,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              closeDialog(context,
                                                  sText: AlertAction.cancel
                                                      .toString());
                                            },
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                SizeConstants
                                                                        .s1 *
                                                                    15))),
                                                backgroundColor: Colors.black,
                                                side: const BorderSide(
                                                    width: 1.5,
                                                    color:
                                                        ColorConstants.cBlack)),
                                            child: Text(
                                              buttonOneText,
                                              style: getTextMedium(
                                                colors: ColorConstants.cWhite,
                                                size:
                                                    SizeConstants.width * 0.04,
                                              ),
                                            ))),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
    if (action.toString() != "null" ||
        action.toString() != "AlertAction.cancel") {
      if (action.toString() == "AlertAction.yes") {
        return AlertAction.yes;
      } else if (action.toString() == "AlertAction.no") {
        return AlertAction.no;
      } else if (action.toString() == "AlertAction.ok") {
        return AlertAction.ok;
      } else {
        return AlertAction.cancel;
      }
    } else {
      return AlertAction.cancel;
    }
  }

  ///Success
  // static Future<AlertAction> showSuccess(
  static Future<void> showSuccess(BuildContext context, String message) async {
    AppAlert.showSnackBar(context, message);
    // final action = await showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     barrierColor: Color(0xbb000000),
    //     builder: (BuildContext context) {
    //       return BackdropFilter(
    //         filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Container(
    //               margin: EdgeInsets.all(SizeConstants.s1*30),
    //               width: SizeConstants.width,
    //               child: Row(
    //                 children: [
    //                   GestureDetector(
    //                     onTap: () {
    //                       closeDialog(context);
    //                     },
    //                     child: Container(
    //                       padding: EdgeInsets.all(SizeConstants.s1*12),
    //                       decoration: BoxDecoration(
    //                           boxShadow: [
    //                             BoxShadow(
    //                               color: Colors.grey.withOpacity(0.3),
    //                               spreadRadius: 1,
    //                               blurRadius: 3,
    //                               offset: const Offset(
    //                                   0, 1), // changes position of shadow
    //                             ),
    //                           ],
    //                           color: Colors.white,
    //                           borderRadius:
    //                               const BorderRadius.all(Radius.circular(8))),
    //                       height: SizeConstants.s1 * 41,
    //                       width: SizeConstants.s1 * 41,
    //                       child: Image.asset(ImageAssets.imageCloseCross),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     width: SizeConstants.s1*15,
    //                   ),
    //                   Text(AppConstants.mWordConstants.sSuccess,
    //                       style: getTextSemiBold(
    //                           colors: ColorConstants.cWhite,
    //                           size: SizeConstants.s1*20,
    //                           letterSpacing: 0.1)),
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               width: SizeConstants.width,
    //               margin: EdgeInsets.only(
    //                   left: SizeConstants.s1*26, right: SizeConstants.s1*26),
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.rectangle,
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(SizeConstants.s1*8),
    //               ),
    //               child: Padding(
    //                 padding: EdgeInsets.only(
    //                   left: SizeConstants.s1*15,
    //                   right: SizeConstants.s1*15,
    //                   top: SizeConstants.s1*30,
    //                   bottom: SizeConstants.s_50,
    //                 ),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     Image.asset(
    //                       height: SizeConstants.s1 * 60,
    //                       ImageAssets.imageSuccess,
    //                       fit: BoxFit.fitWidth,
    //                     ),
    //                     Container(
    //                       margin: EdgeInsets.only(top: SizeConstants.s1*15),
    //                       child: Text(message,
    //                           textAlign: TextAlign.center,
    //                           style: getTextSemiBold(
    //                             colors: ColorConstants.cSuccess,
    //                             size: SizeConstants.s1*18,
    //                           )),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     });
    // if (action.toString() != "null" ||
    //     action.toString() != "AlertAction.cancel") {
    //   if (action.toString() == "AlertAction.yes") {
    //     return AlertAction.yes;
    //   } else if (action.toString() == "AlertAction.no") {
    //     return AlertAction.no;
    //   } else if (action.toString() == "AlertAction.ok") {
    //     return AlertAction.ok;
    //   } else {
    //     return AlertAction.cancel;
    //   }
    // } else {
    //   return AlertAction.cancel;
    // }
  }

  ///Error
  // static Future<AlertAction> showError(
  static Future<void> showError(BuildContext context, String message) async {
    AppAlert.showSnackBar(context, message);

    // final action = await showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     barrierColor: const Color(0xbb000000),
    //     builder: (BuildContext context) {
    //       return BackdropFilter(
    //         filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Container(
    //               margin: EdgeInsets.all(SizeConstants.s1*30),
    //               child: Row(
    //                 children: [
    //                   GestureDetector(
    //                     onTap: () {
    //                       closeDialog(context);
    //                     },
    //                     child: Container(
    //                       padding: EdgeInsets.all(SizeConstants.s1*12),
    //                       decoration: BoxDecoration(
    //                           boxShadow: [
    //                             BoxShadow(
    //                               color: Colors.grey.withOpacity(0.3),
    //                               spreadRadius: 1,
    //                               blurRadius: 3,
    //                               offset: const Offset(
    //                                   0, 1), // changes position of shadow
    //                             ),
    //                           ],
    //                           color: Colors.white,
    //                           borderRadius:
    //                           const BorderRadius.all(Radius.circular(8))),
    //                       height: SizeConstants.s1 * 41,
    //                       width: SizeConstants.s1 * 41,
    //                       child: Image.asset(ImageAssets.imageCloseCross),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     width: SizeConstants.s1*15,
    //                   ),
    //                   Text(AppConstants.mWordConstants.sError,
    //                       style: getTextSemiBold(
    //                           colors: ColorConstants.cWhite,
    //                           size: SizeConstants.s1*20,
    //                           letterSpacing: 0.1)),
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               width: SizeConstants.width,
    //               margin: EdgeInsets.only(
    //                   left: SizeConstants.s1*26, right: SizeConstants.s1*26),
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.rectangle,
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(SizeConstants.s1*8),
    //               ),
    //               child: Padding(
    //                 padding: EdgeInsets.only(
    //                   left: SizeConstants.s1*15,
    //                   right: SizeConstants.s1*15,
    //                   top: SizeConstants.s1*30,
    //                   bottom: SizeConstants.s_50,
    //                 ),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     Image.asset(
    //                       height: SizeConstants.s1 * 60,
    //                       ImageAssets.imageError,
    //                       fit: BoxFit.fitWidth,
    //                     ),
    //                     Container(
    //                       margin: EdgeInsets.only(top: SizeConstants.s1*15),
    //                       child: Text(message,
    //                           textAlign: TextAlign.center,
    //                           style: getTextSemiBold(
    //                             colors: ColorConstants.cError,
    //                             size: SizeConstants.s1*18,
    //                           )),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     });
    // if (action.toString() != "null" ||
    //     action.toString() != "AlertAction.cancel") {
    //   if (action.toString() == "AlertAction.yes") {
    //     return AlertAction.yes;
    //   } else if (action.toString() == "AlertAction.no") {
    //     return AlertAction.no;
    //   } else if (action.toString() == "AlertAction.ok") {
    //     return AlertAction.ok;
    //   } else {
    //     return AlertAction.cancel;
    //   }
    // } else {
    //   return AlertAction.cancel;
    // }
  }

  ///CalendarDialog
  static Future<List<String>> buildCalendarDialog(
      BuildContext context,
      List<DateTime?> dialogCalendarPickerValue,
      CalendarDatePicker2WithActionButtonsConfig mConfig) async {
    final values = await showCalendarDatePicker2Dialog(
      context: context,
      config: mConfig,
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
      value: dialogCalendarPickerValue,
      dialogBackgroundColor: Colors.white,
    );
    return getValueText(mConfig.calendarType, values ?? []);
  }
}
