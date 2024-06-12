import 'dart:ui';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:member_app/common/alert/alert_action.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/dotted_border/dotted_border.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/data/all_bloc/member_voucher_paginated_list_bloc/repo/member_voucher_paginated_list_response.dart';

class AppAlert {
  AppAlert._();

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

  /// Vouchers Active
  static showDialogVouchersActive(
      BuildContext context, double width, Vouchers mVouchers) {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Color(0xbb000000),
        builder: (BuildContext context) {
          String sAmount =
              "RM${mVouchers.flatAmount.toString() == "null" ? "0.0" : mVouchers.flatAmount.toString()} OFF";
          if (mVouchers.flatAmount.toString() == "null") {
            sAmount =
                "${mVouchers.percentage.toString() == "null" ? "0.0" : mVouchers.percentage.toString()}% OFF";
          }
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(SizeConstants.s_30),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            closeDialog(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(SizeConstants.s_12),
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
                            child: Image.asset(ImageAssets.imageCloseCross),
                          ),
                        ),
                        SizedBox(
                          width: SizeConstants.s_15,
                        ),
                        Text(sAmount,
                            style: getTextSemiBold(
                                colors: ColorConstants.cWhite,
                                size: SizeConstants.s_22,
                                letterSpacing: 0.1)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(SizeConstants.s_20),
                    height: width * 0.6,
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
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ColorConstants.kPrimaryColor.shade400,
                            ColorConstants.kPrimaryColor.shade600,
                            ColorConstants.kPrimaryColor.shade800,
                            ColorConstants.kPrimaryColor.shade900,
                          ],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Container(
                                padding: EdgeInsets.only(
                                  left: SizeConstants.s_26,
                                  right: SizeConstants.s_26,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.all(SizeConstants.s_15),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0,
                                                  1), // changes position of shadow
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8))),
                                      height: SizeConstants.s_72,
                                      width: SizeConstants.s_72,
                                      child: Image.asset(
                                          ImageAssets.imageVouchersListActive),
                                    ),
                                    SizedBox(
                                      height: SizeConstants.s_20,
                                    ),
                                    Text(sAmount,
                                        style: getTextSemiBold(
                                            colors: ColorConstants.cWhite,
                                            size: SizeConstants.s_20,
                                            letterSpacing: 0.5)),
                                    SizedBox(
                                      height: SizeConstants.s_18,
                                    ),
                                    Text("Minimum Spend",
                                        style: getTextLight(
                                            colors: ColorConstants.cWhite,
                                            size: SizeConstants.s_16,
                                            letterSpacing: 0.5)),
                                    Text("RM${mVouchers.minimumSpendAmount}",
                                        style: getTextSemiBold(
                                            colors: ColorConstants.cWhite,
                                            size: SizeConstants.s_18,
                                            letterSpacing: 0.5)),
                                  ],
                                ))),
                        Padding(
                          padding: EdgeInsets.only(
                            left: SizeConstants.s_8,
                            right: SizeConstants.s_8,
                          ),
                          child: DottedBorder(
                            dashPattern: const [3, 5],
                            strokeWidth: 1,
                            color: ColorConstants.cDividerLightColor,
                            padding: EdgeInsets.all(0.0),
                            child: Container(),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: SizeConstants.s_20,
                                  ),
                                  Expanded(
                                      child: Center(
                                          child: Container(
                                              height:
                                                  SizeConstants.width * 0.16,
                                              padding: EdgeInsets.only(
                                                left: SizeConstants.s_10,
                                                right: SizeConstants.s_10,
                                                top: SizeConstants.s_10,
                                                bottom: SizeConstants.s5,
                                              ),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                      offset: const Offset(0,
                                                          1), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8))),
                                              child: Column(
                                                children: [
                                                  BarcodeWidget(
                                                    barcode: Barcode.code128(),
                                                    data: mVouchers.number
                                                        .toString(),
                                                    height:
                                                        SizeConstants.width *
                                                            0.12,
                                                    width: SizeConstants.width *
                                                        0.6,
                                                    style: getTextRegular(
                                                        colors: Colors.black,
                                                        size:
                                                            SizeConstants.s_14,
                                                        letterSpacing: 1.0),
                                                  ),
                                                ],
                                              )))),
                                  Text('valid until ${mVouchers.expiryDate}',
                                      style: getTextLight(
                                          colors: ColorConstants.cWhite,
                                          size: SizeConstants.s_16,
                                          letterSpacing: 0.5)),
                                  SizedBox(
                                    height: SizeConstants.s_20,
                                  ),
                                ]))
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  /// Vouchers redeemed
  static showDialogVouchersRedeemed(
      BuildContext context, double width, Vouchers mVouchers) {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Color(0xbb000000),
        builder: (BuildContext context) {
          String sAmount =
              "RM${mVouchers.flatAmount.toString() == "null" ? "0.0" : mVouchers.flatAmount.toString()} OFF";
          if (mVouchers.flatAmount.toString() == "null") {
            sAmount =
                "${mVouchers.percentage.toString() == "null" ? "0.0" : mVouchers.percentage.toString()}% OFF";
          }
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(SizeConstants.s_30),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          closeDialog(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(SizeConstants.s_12),
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
                          child: Image.asset(ImageAssets.imageCloseCross),
                        ),
                      ),
                      SizedBox(
                        width: SizeConstants.s_15,
                      ),
                      Text(sAmount,
                          style: getTextSemiBold(
                              colors: ColorConstants.cWhite,
                              size: SizeConstants.s_22,
                              letterSpacing: 0.1)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(SizeConstants.s_20),
                  height: width * 0.5,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xffD3D0D0),
                          Color(0xff454545),
                        ],
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 7,
                          child: Container(
                              padding: EdgeInsets.only(
                                left: SizeConstants.s_26,
                                right: SizeConstants.s_26,
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(SizeConstants.s_15),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0,
                                                1), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    height: SizeConstants.s_72,
                                    width: SizeConstants.s_72,
                                    child: Image.asset(
                                        ImageAssets.imageVouchersListRedeemed),
                                  ),
                                  SizedBox(
                                    height: SizeConstants.s_20,
                                  ),
                                  Text(sAmount,
                                      style: getTextSemiBold(
                                          colors: ColorConstants.cWhite,
                                          size: SizeConstants.s_20,
                                          letterSpacing: 0.5)),
                                  SizedBox(
                                    height: SizeConstants.s_18,
                                  ),
                                  Text("Minimum Spend",
                                      style: getTextLight(
                                          colors: ColorConstants.cWhite,
                                          size: SizeConstants.s_16,
                                          letterSpacing: 0.5)),
                                  Text("RM${mVouchers.minimumSpendAmount}",
                                      style: getTextSemiBold(
                                          colors: ColorConstants.cWhite,
                                          size: SizeConstants.s_18)),
                                ],
                              ))),
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConstants.s_8,
                          right: SizeConstants.s_8,
                        ),
                        child: DottedBorder(
                          dashPattern: const [3, 5],
                          strokeWidth: 1,
                          color: ColorConstants.cDividerLightColor,
                          padding: EdgeInsets.all(0.0),
                          child: Container(),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                                'Redeemed on ${mVouchers.usedAt.toString()}',
                                style: getTextLight(
                                    colors: ColorConstants.cWhite,
                                    size: SizeConstants.s_14,
                                    letterSpacing: 0.3)),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
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
                    padding: EdgeInsets.all(SizeConstants.s_16),
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
                  margin: EdgeInsets.all(SizeConstants.s_30),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          closeDialog(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(SizeConstants.s_12),
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
                          child: Image.asset(ImageAssets.imageCloseCross),
                        ),
                      ),
                      SizedBox(
                        width: SizeConstants.s_15,
                      ),
                      Text(sTitle,
                          style: getTextSemiBold(
                              colors: ColorConstants.cWhite,
                              size: SizeConstants.s_20,
                              letterSpacing: 0.1)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConstants.s_26, right: SizeConstants.s_26),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizeConstants.s_8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConstants.s_26,
                            bottom: SizeConstants.s_12),
                        child: Text(message,
                            style: getTextSemiBold(
                              colors: Colors.black87,
                              size: SizeConstants.s_18,
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
                                                        SizeConstants.s_15))),
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
                                width: SizeConstants.s_14,
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
                                                        SizeConstants.s_15))),
                                            backgroundColor:
                                                ColorConstants.kPrimaryColor),
                                        onPressed: () {
                                          closeDialog(context,
                                              sText:
                                                  AlertAction.yes.toString());
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
                    // Container(
                    //   margin: EdgeInsets.all(SizeConstants.s_30),
                    //   child: Row(
                    //     children: [
                    //       GestureDetector(
                    //         onTap: () {
                    //           closeDialog(context);
                    //         },
                    //         child: Container(
                    //           padding: EdgeInsets.all(SizeConstants.s_12),
                    //           decoration: BoxDecoration(
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   color: Colors.grey.withOpacity(0.3),
                    //                   spreadRadius: 1,
                    //                   blurRadius: 3,
                    //                   offset: const Offset(
                    //                       0, 1), // changes position of shadow
                    //                 ),
                    //               ],
                    //               color: Colors.white,
                    //               borderRadius:
                    //               const BorderRadius.all(Radius.circular(8))),
                    //           height: SizeConstants.s1 * 41,
                    //           width: SizeConstants.s1 * 41,
                    //           child: Image.asset(ImageAssets.imageCloseCross),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: SizeConstants.s_15,
                    //       ),
                    //       Text(sTitle,
                    //           style: getTextSemiBold(
                    //               colors: ColorConstants.cWhite,
                    //               size: SizeConstants.s_20,
                    //               letterSpacing: 0.1)),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.only(
                          left: SizeConstants.s_26, right: SizeConstants.s_26),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(SizeConstants.s_8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConstants.s_12,
                                right: SizeConstants.s_12,
                                top: SizeConstants.s_26,
                                bottom: SizeConstants.s_12),
                            child: Text(message,
                                textAlign: TextAlign.center,
                                style: getTextSemiBold(
                                  colors: Colors.black87,
                                  size: SizeConstants.s_18,
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
                                                                    .s_15))),
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
                                    width: SizeConstants.s_14,
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
                                                                    .s_15))),
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
    //               margin: EdgeInsets.all(SizeConstants.s_30),
    //               width: SizeConstants.width,
    //               child: Row(
    //                 children: [
    //                   GestureDetector(
    //                     onTap: () {
    //                       closeDialog(context);
    //                     },
    //                     child: Container(
    //                       padding: EdgeInsets.all(SizeConstants.s_12),
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
    //                     width: SizeConstants.s_15,
    //                   ),
    //                   Text(AppConstants.mWordConstants.sSuccess,
    //                       style: getTextSemiBold(
    //                           colors: ColorConstants.cWhite,
    //                           size: SizeConstants.s_20,
    //                           letterSpacing: 0.1)),
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               width: SizeConstants.width,
    //               margin: EdgeInsets.only(
    //                   left: SizeConstants.s_26, right: SizeConstants.s_26),
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.rectangle,
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(SizeConstants.s_8),
    //               ),
    //               child: Padding(
    //                 padding: EdgeInsets.only(
    //                   left: SizeConstants.s_15,
    //                   right: SizeConstants.s_15,
    //                   top: SizeConstants.s_30,
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
    //                       margin: EdgeInsets.only(top: SizeConstants.s_15),
    //                       child: Text(message,
    //                           textAlign: TextAlign.center,
    //                           style: getTextSemiBold(
    //                             colors: ColorConstants.cSuccess,
    //                             size: SizeConstants.s_18,
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
    //               margin: EdgeInsets.all(SizeConstants.s_30),
    //               child: Row(
    //                 children: [
    //                   GestureDetector(
    //                     onTap: () {
    //                       closeDialog(context);
    //                     },
    //                     child: Container(
    //                       padding: EdgeInsets.all(SizeConstants.s_12),
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
    //                     width: SizeConstants.s_15,
    //                   ),
    //                   Text(AppConstants.mWordConstants.sError,
    //                       style: getTextSemiBold(
    //                           colors: ColorConstants.cWhite,
    //                           size: SizeConstants.s_20,
    //                           letterSpacing: 0.1)),
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               width: SizeConstants.width,
    //               margin: EdgeInsets.only(
    //                   left: SizeConstants.s_26, right: SizeConstants.s_26),
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.rectangle,
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(SizeConstants.s_8),
    //               ),
    //               child: Padding(
    //                 padding: EdgeInsets.only(
    //                   left: SizeConstants.s_15,
    //                   right: SizeConstants.s_15,
    //                   top: SizeConstants.s_30,
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
    //                       margin: EdgeInsets.only(top: SizeConstants.s_15),
    //                       child: Text(message,
    //                           textAlign: TextAlign.center,
    //                           style: getTextSemiBold(
    //                             colors: ColorConstants.cError,
    //                             size: SizeConstants.s_18,
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
}
