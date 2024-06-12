import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:member_app/common/app_constants.dart';
import 'package:member_app/common/appbars_constants.dart';
import 'package:member_app/common/button_constants.dart';
import 'package:member_app/common/color_constants.dart';
import 'package:member_app/common/image_assets.dart';
import 'package:member_app/common/size_constants.dart';
import 'package:member_app/common/text_styles_constants.dart';
import 'package:member_app/common/widget/app_bar_bottom_view.dart';
import 'package:member_app/modules/common/skill_selection/model/web_model.dart';
import 'package:member_app/routes/route_constants.dart';

class WelcomeScreenWidget extends StatefulWidget {
  const WelcomeScreenWidget({super.key});

  @override
  State<WelcomeScreenWidget> createState() => _WelcomeScreenWidgetState();
}

class _WelcomeScreenWidgetState extends State<WelcomeScreenWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBars.appNoBar(), body: _buildWelcomeView());
  }

  _buildWelcomeView() {
    return FocusDetector(
        child: SafeArea(
            child: Column(
      children: [
        appBarBottomViewWithText("", mAlignment: Alignment.center),
        Expanded(
            child: SingleChildScrollView(
                child: SizedBox(
          width: double.infinity,
          height: SizeConstants.height * 0.92,
          child: Column(children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                    top: SizeConstants.s_16, left: SizeConstants.s_16),
                child: Text(
                  AppConstants.mWordConstants.sWelcomeText,
                  style: getTextSemiBold(
                      size: SizeConstants.s1 * 38, colors: Colors.black),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: SizeConstants.s_16),
              padding: EdgeInsets.all(SizeConstants.s_16),
              child: Image.asset(ImageAssets.imageWelcomeHandIcon,
                  height: SizeConstants.width * 0.28, fit: BoxFit.fitHeight),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: SizeConstants.s_26),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConstants.s1 * 20),
                  topRight: Radius.circular(SizeConstants.s1 * 20),
                ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(
                          0, 1), // changes position of shadow
                    ),
                  ],
              ),
              child: Column(
                children: [
                  Text(
                    AppConstants.mWordConstants.sWelcomeTextRegistered,
                    textAlign: TextAlign.center,
                    style: getTextRegular(
                        size: SizeConstants.s1 * 20,
                        colors: ColorConstants.cDividerLightColor),
                  ),
                  SizedBox(
                    height: SizeConstants.s_26,
                  ),
                  Center(
                    child: rectangleRoundedCornerButton(
                        appbarActionInterface: (value) {
                          Navigator.pushNamed(
                            context,
                            RouteConstants.rLoginMobileNumberScreenWidget,
                          );
                        },
                        sButtonTitle: AppConstants.mWordConstants.sLogin,
                        cButtonBackGroundColor:
                            ColorConstants.kPrimaryColor.shade600,
                        cButtonTextColor: ColorConstants.cWhite,
                        dButtonTextSize: SizeConstants.s_16,
                        cButtonBorderColor:
                            ColorConstants.kPrimaryColor.shade600,
                        dButtonWidth: SizeConstants.width * 0.35),
                  ),
                  SizedBox(
                    height: SizeConstants.s_26,
                  ),
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: SizeConstants.s_26,
                        height: SizeConstants.s_05,
                        color: ColorConstants.cDividerLightColor,
                      ),
                      SizedBox(
                        width: SizeConstants.s_15,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            SizeConstants.s_15,
                            SizeConstants.s_15,
                            SizeConstants.s_15,
                            SizeConstants.s1 * 17),
                        decoration:  BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                          color: ColorConstants.cDividerMoreLightColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text("or",
                            style: getTextRegular(
                                size: SizeConstants.s1 * 20,
                                colors: ColorConstants.kPrimaryColor.shade600)),
                      ),
                      SizedBox(
                        width: SizeConstants.s_15,
                      ),
                      Container(
                        width: SizeConstants.s_26,
                        height: SizeConstants.s_05,
                        color: ColorConstants.cDividerLightColor,
                      ),
                    ],
                  )),
                  SizedBox(
                    height: SizeConstants.s_26,
                  ),
                  GestureDetector(
                    onTap: () {

                      Navigator.pushNamed(
                        context,
                        RouteConstants.rCommonWebView,
                        ///staging
                        arguments: WebModel("Registration","https://stagingretail.ariani.my/38/member-registration")
                       ///live
                        // arguments: WebModel("Registration","https://retail.ariani.my/55/member-registration")
                      );
                    },
                    child: Container(
                        padding: EdgeInsets.only(
                          bottom: SizeConstants.s3,
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: ColorConstants.kPrimaryColor.shade600,
                          width: SizeConstants
                              .s1, // This would be the width of the underline
                        ))),
                        child: Text(
                            AppConstants.mWordConstants.sClickHereToRegister,
                            style: getTextRegular(
                              size: SizeConstants.s1 * 20,
                              colors: ColorConstants.kPrimaryColor.shade600,
                            ))),
                  ),
                  SizedBox(
                    height: SizeConstants.s_10,
                  ),
                  Text(AppConstants.mWordConstants.sAsAMember,
                      style: getTextRegular(
                          size: SizeConstants.s1 * 20,
                          colors: ColorConstants.cDividerLightColor)),
                ],
              ),
            )),
          ]),
        ))),
      ],
    )));
  }
}
